#!/bin/sh
#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# install-kubectl.sh – Installs the latest stable kubectl on Linux / macOS.
# Usage: ./install-kubectl.sh
# -----------------------------------------------------------------------------
set -euo pipefail

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"
case "$ARCH" in
  x86_64) ARCH="amd64" ;;
  aarch64) ARCH="arm64" ;;
  armv7l) ARCH="arm" ;;
esac

# Check for existing installation
if command -v kubectl &> /dev/null; then
  echo "kubectl is already installed: $(kubectl version --client --short 2>/dev/null || true)"
  read -rp "Reinstall? [y/N] " yn
  if [[ ! "$yn" =~ ^[Yy]$ ]]; then
    exit 0
  fi
fi

echo "Fetching latest kubectl version..."
STABLE_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)

DOWNLOAD_URL="https://dl.k8s.io/release/${STABLE_VERSION}/bin/${OS}/${ARCH}/kubectl"
echo "Downloading kubectl ${STABLE_VERSION} for ${OS}/${ARCH}..."
curl -LO "$DOWNLOAD_URL"

chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

echo "kubectl installed successfully."
kubectl version --client --output=yaml