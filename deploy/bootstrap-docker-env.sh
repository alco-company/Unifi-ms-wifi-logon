#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
env_example="${script_dir}/.env.example"
env_file="${script_dir}/.env"
cert_dir="${script_dir}/freeradius/certs"
step_ca_dir="${script_dir}/step-ca/data"

if [[ ! -f "${env_file}" ]]; then
  cp "${env_example}" "${env_file}"
  echo "Created ${env_file} from ${env_example}."
else
  echo "Using existing ${env_file}."
fi

mkdir -p "${cert_dir}"
mkdir -p "${step_ca_dir}"

cat <<EOF
Docker environment is prepared.

Next steps:
1. Edit ${env_file} and replace all example values.
2. For a local smoke test, run ./deploy/generate-dev-certs.sh
3. Start the stack:
     cd deploy
     docker compose up -d

Production note:
- Replace the development certs in ${cert_dir} with Step-CA-issued files before real deployment.
- Step-CA data will be persisted in ${step_ca_dir}
EOF
