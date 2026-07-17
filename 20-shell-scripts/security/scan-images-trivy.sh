#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# scan-images-trivy.sh – Scan container images used in a Kubernetes cluster.
# Requires: trivy installed (https://github.com/aquasecurity/trivy)
# Usage: ./scan-images-trivy.sh [namespace|--all-namespaces]
# Default: scans all pods in the current context namespace.
# -----------------------------------------------------------------------------
set -euo pipefail

if ! command -v trivy &> /dev/null; then
  echo "trivy not found. Install it from https://github.com/aquasecurity/trivy" >&2
  exit 1
fi

NAMESPACE_FLAG=""
if [[ "${1:-}" == "--all-namespaces" ]]; then
  NAMESPACE_FLAG="--all-namespaces"
elif [[ -n "${1:-}" ]]; then
  NAMESPACE_FLAG="-n $1"
fi

echo "Gathering unique images from running pods..."
images=$(kubectl get pods $NAMESPACE_FLAG -o jsonpath='{range .items[*]}{.spec.containers[*].image}{"\n"}{end}' | sort -u)

if [[ -z "$images" ]]; then
  echo "No images found." >&2
  exit 1
fi

echo "Scanning images with Trivy..."
for img in $images; do
  echo "----------------------------------------"
  echo "Image: $img"
  trivy image --severity HIGH,CRITICAL --ignore-unfixed "$img" 2>/dev/null || true
done