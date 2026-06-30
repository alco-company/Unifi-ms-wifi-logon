#!/usr/bin/env bash
set -euo pipefail

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo is required" >&2
  exit 1
fi

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg lsb-release

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

mkdir -p /opt/unifi-radius/{step-ca,freeradius/certs,intune,unifi}

cat <<'EOF'
Installation complete.
Log out and back in, or run: newgrp docker
Then bootstrap the Docker environment and start the stack with:
  chmod +x deploy/bootstrap-docker-env.sh deploy/generate-dev-certs.sh
  ./deploy/bootstrap-docker-env.sh
  ./deploy/generate-dev-certs.sh   # optional development-only certs
  cd deploy
  docker compose up -d
EOF
