#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# setup-helm.sh – Install Helm 3 on Linux / macOS.
# -----------------------------------------------------------------------------
set -euo pipefail

if command -v helm &> /dev/null; then
  echo "Helm is already installed: $(helm version --short)"
  read -rp "Reinstall? [y/N] " yn
  if [[ ! "$yn" =~ ^[Yy]$ ]]; then
    exit 0
  fi
fi

echo "Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "Helm installed successfully."
helm version