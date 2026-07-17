#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# kube-bench-automation.sh – Run CIS benchmark checks on a cluster.
# Requires: kube-bench installed (https://github.com/aquasecurity/kube-bench)
# Usage: ./kube-bench-automation.sh [master|node]
# This script runs kube-bench against the current node type.
# -----------------------------------------------------------------------------
set -euo pipefail

if ! command -v kube-bench &> /dev/null; then
  echo "kube-bench not found. Install it from https://github.com/aquasecurity/kube-bench" >&2
  exit 1
fi

NODE_TYPE="${1:-master}"

# Detect if we are running on a control-plane node
if [[ "$NODE_TYPE" == "auto" ]]; then
  if kubectl get node "$(hostname)" -o jsonpath='{.metadata.labels.node-role\.kubernetes\.io/control-plane}' 2>/dev/null | grep -q true; then
    NODE_TYPE="master"
  else
    NODE_TYPE="node"
  fi
fi

echo "Running kube-bench for node type: $NODE_TYPE"
kube-bench --benchmark cis-1.7 --targets "$NODE_TYPE" --json | tee "kube-bench-report-${NODE_TYPE}-$(date +%Y%m%d-%H%M%S).json"