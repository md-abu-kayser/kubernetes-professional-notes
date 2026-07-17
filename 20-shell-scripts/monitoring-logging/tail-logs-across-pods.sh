#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# tail-logs-across-pods.sh – Stream logs from all pods matching a label selector.
# Usage: ./tail-logs-across-pods.sh [namespace] [label-selector] [container]
# Example: ./tail-logs-across-pods.sh default app=nginx
# Default: namespace=default, container=first container in pod
# -----------------------------------------------------------------------------
set -euo pipefail

NAMESPACE="${1:-default}"
SELECTOR="${2:-}"
CONTAINER="${3:-}"

if [[ -z "$SELECTOR" ]]; then
  echo "You must provide a label selector." >&2
  echo "Usage: $0 <namespace> <label-selector> [container]" >&2
  exit 1
fi

pods=$(kubectl get pods -n "$NAMESPACE" -l "$SELECTOR" -o jsonpath='{.items[*].metadata.name}')
if [[ -z "$pods" ]]; then
  echo "No pods found with selector '$SELECTOR' in namespace '$NAMESPACE'." >&2
  exit 1
fi

# Build stern-like multi-pod tail
log_args=()
for pod in $pods; do
  if [[ -n "$CONTAINER" ]]; then
    log_args+=("pod/$pod" -c "$CONTAINER")
  else
    log_args+=("pod/$pod")
  fi
done

echo "Tailing logs from: $pods"
kubectl logs -n "$NAMESPACE" -f --prefix=true "${log_args[@]}"