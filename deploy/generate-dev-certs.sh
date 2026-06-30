#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
env_file="${script_dir}/.env"
cert_dir="${script_dir}/freeradius/certs"
valid_days="${CERT_VALIDITY_DAYS:-365}"

if ! command -v openssl >/dev/null 2>&1; then
  echo "openssl is required to generate development certificates." >&2
  exit 1
fi

if [[ -f "${env_file}" ]]; then
  set -a
  # shellcheck disable=SC1090
  . "${env_file}"
  set +a
fi

radius_host="${1:-${RADIUS_HOST:-radius.firma.dk}}"
ca_name="${STEP_CA_INIT_NAME:-Local WiFi Dev CA}"

mkdir -p "${cert_dir}"
rm -f \
  "${cert_dir}/ca.key" \
  "${cert_dir}/ca.pem" \
  "${cert_dir}/server.key" \
  "${cert_dir}/server.crt" \
  "${cert_dir}/server.csr" \
  "${cert_dir}/server.pem" \
  "${cert_dir}/server.cnf" \
  "${cert_dir}/ca.srl" \
  "${cert_dir}/dh"

openssl genrsa -out "${cert_dir}/ca.key" 4096
openssl req \
  -x509 \
  -new \
  -nodes \
  -key "${cert_dir}/ca.key" \
  -sha256 \
  -days "${valid_days}" \
  -out "${cert_dir}/ca.pem" \
  -subj "/CN=${ca_name}"

cat > "${cert_dir}/server.cnf" <<EOF
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
CN = ${radius_host}

[v3_req]
subjectAltName = @alt_names
extendedKeyUsage = serverAuth
keyUsage = critical, digitalSignature, keyEncipherment

[alt_names]
DNS.1 = ${radius_host}
DNS.2 = localhost
IP.1 = 127.0.0.1
EOF

openssl genrsa -out "${cert_dir}/server.key" 2048
openssl req \
  -new \
  -key "${cert_dir}/server.key" \
  -out "${cert_dir}/server.csr" \
  -config "${cert_dir}/server.cnf"

openssl x509 \
  -req \
  -in "${cert_dir}/server.csr" \
  -CA "${cert_dir}/ca.pem" \
  -CAkey "${cert_dir}/ca.key" \
  -CAcreateserial \
  -out "${cert_dir}/server.crt" \
  -days "${valid_days}" \
  -sha256 \
  -extensions v3_req \
  -extfile "${cert_dir}/server.cnf"

cat "${cert_dir}/server.crt" "${cert_dir}/server.key" > "${cert_dir}/server.pem"
openssl dhparam -out "${cert_dir}/dh" 2048

rm -f \
  "${cert_dir}/server.csr" \
  "${cert_dir}/server.cnf" \
  "${cert_dir}/ca.srl"

cat <<EOF
Development certificates generated in ${cert_dir}

Files:
- ca.pem
- server.pem
- dh

These certificates are for local Docker testing only and should be replaced in production.
EOF
