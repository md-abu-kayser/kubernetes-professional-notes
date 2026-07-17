#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# resource-usage-monitor.sh – Show top resource-consuming pods or nodes.
# Requires: metrics-server installed in the cluster.
# Usage: ./resource-usage-monitor.sh [pod|node] [namespace]
# Default: pod, all namespaces
# -----------------------------------------------------------------------------
set -euo pipefail

RESOURCE="${1:-pod}"
NAMESPACE="${2:-}"

check_metrics_server() {
  if ! kubectl top pods -n kube-system &>/dev/null; then
    echo "WARNING: kubectl top failed. Is metrics-server installed?" >&2
    exit 1
  fi
}

case "$RESOURCE" in
  pod)
    check_metrics_server
    if [[ -n "$NAMESPACE" ]]; then
      kubectl top pods -n "$NAMESPACE" --sort-by=cpu
    else
      kubectl top pods --all-namespaces --sort-by=cpu
    fi
    ;;
  node)
    check_metrics_server
    kubectl top nodes --sort-by=cpu
    ;;
  *)
    echo "Usage: $0 [pod|node] [namespace]" >&2
    exit 1
    ;;
esac