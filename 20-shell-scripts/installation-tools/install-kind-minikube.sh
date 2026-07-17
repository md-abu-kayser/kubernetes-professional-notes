#!/bin/sh
#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# install-kind-minikube.sh – Installs kind and/or minikube on Linux/macOS.
# Usage: ./install-kind-minikube.sh [kind|minikube|both]
# Default: both
# -----------------------------------------------------------------------------
set -euo pipefail

MODE="${1:-both}"

install_kind() {
  echo "Installing kind..."
  OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
  [[ "$OS" == "darwin" ]] && OS="darwin"
  curl -Lo ./kind "https://kind.sigs.k8s.io/dl/v0.20.0/kind-${OS}-amd64"
  chmod +x kind
  sudo mv kind /usr/local/bin/kind
  kind version
}

install_minikube() {
  echo "Installing minikube..."
  OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
  ARCH="amd64"
  curl -Lo minikube "https://storage.googleapis.com/minikube/releases/latest/minikube-${OS}-${ARCH}"
  chmod +x minikube
  sudo mv minikube /usr/local/bin/minikube
  minikube version
}

case "$MODE" in
  kind) install_kind ;;
  minikube) install_minikube ;;
  both)
    install_kind
    install_minikube
    ;;
  *)
    echo "Usage: $0 [kind|minikube|both]"
    exit 1
    ;;
esac

echo "Done."