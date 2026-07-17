#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# multi-cluster-switch.sh – Interactive kubectl context switcher.
# Requires: kubectl, and optionally fzf (for fuzzy search).
# Usage: ./multi-cluster-switch.sh
# -----------------------------------------------------------------------------
set -euo pipefail

if ! command -v kubectl &> /dev/null; then
  echo "kubectl is not installed." >&2
  exit 1
fi

contexts=$(kubectl config get-contexts -o name)
if [[ -z "$contexts" ]]; then
  echo "No contexts found in kubeconfig." >&2
  exit 1
fi

if command -v fzf &> /dev/null; then
  # Fuzzy selection
  selected=$(echo "$contexts" | fzf --prompt="Select context: " --height=20%)
else
  # Simple numbered menu
  echo "Available contexts:"
  i=0
  mapfile -t ctx_array <<< "$contexts"
  for ctx in "${ctx_array[@]}"; do
    echo "  $((++i))) $ctx"
  done
  read -rp "Choose a number (1-${#ctx_array[@]}): " num
  selected="${ctx_array[$((num-1))]}"
fi

if [[ -n "$selected" ]]; then
  kubectl config use-context "$selected"
  echo "Switched to context: $selected"
else
  echo "No context selected."
fi