#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# kube-ps1-setup.sh – Download and configure kube-ps1 (Bash/Zsh prompt).
# Usage: ./kube-ps1-setup.sh [install_dir]
# Default install dir: $HOME/.kube-ps1
# -----------------------------------------------------------------------------
set -euo pipefail

INSTALL_DIR="${1:-$HOME/.kube-ps1}"
REPO="https://github.com/jonmosco/kube-ps1"

echo "Installing kube-ps1 to ${INSTALL_DIR} ..."
if [[ ! -d "$INSTALL_DIR" ]]; then
  git clone --depth 1 "$REPO" "$INSTALL_DIR"
else
  echo "Directory exists; pulling latest changes ..."
  git -C "$INSTALL_DIR" pull
fi

echo ""
echo "Add the following lines to your ~/.bashrc or ~/.zshrc:"
echo "---------------------------------------------------------"
echo "export KUBE_PS1_SYMBOL_ENABLE=false"
echo "source ${INSTALL_DIR}/kube-ps1.sh"
echo "PS1='[\u@\h \W \$(kube_ps1)]\$ '"
echo "---------------------------------------------------------"