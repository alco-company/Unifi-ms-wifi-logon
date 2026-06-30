#!/bin/sh
set -eu

template_dir="/opt/freeradius/templates"
radius_dir="/etc/raddb"
certs_dir="${RADIUS_CERTS_DIR:-${radius_dir}/certs}"

require_env() {
  var_name="$1"
  eval "var_value=\${$var_name:-}"
  if [ -z "$var_value" ]; then
    echo "Missing required environment variable: $var_name" >&2
    exit 1
  fi
}

require_file() {
  if [ ! -f "$1" ]; then
    echo "Missing required file: $1" >&2
    exit 1
  fi
}

escape_sed() {
  printf '%s' "$1" | sed 's/[\/&]/\\&/g'
}

render_template() {
  input_file="$1"
  output_file="$2"

  unifi_controller_ip_escaped="$(escape_sed "${UNIFI_CONTROLLER_IP}")"
  radius_secret_escaped="$(escape_sed "${RADIUS_SECRET}")"
  certs_dir_escaped="$(escape_sed "${certs_dir}")"

  sed \
    -e "s|__UNIFI_CONTROLLER_IP__|${unifi_controller_ip_escaped}|g" \
    -e "s|__RADIUS_SECRET__|${radius_secret_escaped}|g" \
    -e "s|__RADIUS_CERTS_DIR__|${certs_dir_escaped}|g" \
    "$input_file" > "$output_file"
}

require_env "UNIFI_CONTROLLER_IP"
require_env "RADIUS_SECRET"

mkdir -p \
  "${radius_dir}/mods-available" \
  "${radius_dir}/mods-enabled" \
  "${radius_dir}/sites-available" \
  "${radius_dir}/sites-enabled"

render_template "${template_dir}/clients.conf.template" "${radius_dir}/clients.conf"
render_template "${template_dir}/eap.conf.template" "${radius_dir}/mods-available/eap"
render_template "${template_dir}/default.template" "${radius_dir}/sites-available/default"

ln -sf ../mods-available/eap "${radius_dir}/mods-enabled/eap"
ln -sf ../sites-available/default "${radius_dir}/sites-enabled/default"

require_file "${certs_dir}/server.pem"
require_file "${certs_dir}/ca.pem"
require_file "${certs_dir}/dh"

exec "$@"
