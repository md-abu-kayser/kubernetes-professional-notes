#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# velero-backup-schedule.sh – Create a scheduled backup using Velero.
# Requires: velero CLI installed and configured with a storage provider.
# Usage: ./velero-backup-schedule.sh <schedule-name> <cron-expression> [ttl]
# Example: ./velero-backup-schedule.sh daily "0 2 * * *" 720h0m0s
# -----------------------------------------------------------------------------
set -euo pipefail

if ! command -v velero &> /dev/null; then
  echo "velero CLI not found. Install it from https://velero.io/docs/" >&2
  exit 1
fi

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <schedule-name> <cron-expression> [ttl]" >&2
  echo "Example: $0 daily \"0 2 * * *\" 720h0m0s" >&2
  exit 1
fi

NAME="$1"
CRON="$2"
TTL="${3:-720h0m0s}"

echo "Creating Velero schedule: $NAME (cron: $CRON, ttl: $TTL)"
velero schedule create "$NAME" \
  --schedule="$CRON" \
  --ttl "$TTL" \
  --include-namespaces "*" \
  --exclude-namespaces "kube-system,velero" \
  --snapshot-volumes=true \
  --wait

echo "Schedule created. Listing schedules:"
velero schedule get