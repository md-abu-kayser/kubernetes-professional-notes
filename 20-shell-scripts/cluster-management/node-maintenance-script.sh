#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# node-maintenance-script.sh – Cordon, drain, or uncordon a node.
# Usage: ./node-maintenance-script.sh <cordon|drain|uncordon> <node>
# -----------------------------------------------------------------------------
set -euo pipefail

usage() {
  echo "Usage: $0 <cordon|drain|uncordon> <node-name>"
  exit 1
}

if [[ $# -ne 2 ]]; then
  usage
fi

ACTION="$1"
NODE="$2"

# Verify node exists
if ! kubectl get node "$NODE" &> /dev/null; then
  echo "Node '$NODE' not found." >&2
  exit 1
fi

case "$ACTION" in
  cordon)
    echo "Cordoning node: $NODE"
    kubectl cordon "$NODE"
    ;;
  drain)
    echo "Draining node: $NODE (ignoring daemonsets, deleting emptyDir data)"
    kubectl drain "$NODE" --ignore-daemonsets --delete-emptydir-data
    ;;
  uncordon)
    echo "Uncordoning node: $NODE"
    kubectl uncordon "$NODE"
    ;;
  *)
    usage
    ;;
esac