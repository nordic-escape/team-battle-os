#!/usr/bin/env bash
set -euo pipefail

# --- Load credentials ---
if [ ! -f .env ]; then
  echo "Missing .env file. Create one with GHCR_USERNAME and GHCR_TOKEN." >&2
  exit 1
fi
# shellcheck disable=SC1091
source .env

if [[ -z "${GHCR_USERNAME:-}" || -z "${GHCR_TOKEN:-}" ]]; then
  echo "Error: GHCR_USERNAME or GHCR_TOKEN not set in .env" >&2
  exit 1
fi

# --- Create Docker auth file ---
AUTH=$(echo -n "${GHCR_USERNAME}:${GHCR_TOKEN}" | base64)
cat > stage2/99-wayfire/files/config.json <<EOF
{
  "auths": {
    "ghcr.io": {
      "auth": "${AUTH}"
    }
  }
}
EOF
echo "✅ Docker authentication ready"

# --- Run pi-gen build ---
if [ ! -f config ]; then
  echo "Missing pi-gen config file." >&2
  exit 1
fi

sudo update-binfmts --enable qemu-aarch64
sudo ./build.sh -c config
