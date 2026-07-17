#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# etcd-backup-script.sh – Backup etcd from a kubeadm cluster.
# Run this script on a control-plane node as root (or with appropriate access).
# The etcd certificates are typically in /etc/kubernetes/pki/etcd.
# -----------------------------------------------------------------------------
set -euo pipefail

BACKUP_DIR="${BACKUP_DIR:-/var/backups/etcd}"
RETENTION_DAYS="${RETENTION_DAYS:-7}"
CACERT="${CACERT:-/etc/kubernetes/pki/etcd/ca.crt}"
CERT="${CERT:-/etc/kubernetes/pki/etcd/server.crt}"
KEY="${KEY:-/etc/kubernetes/pki/etcd/server.key}"

if [[ ! -f "$CACERT" ]] || [[ ! -f "$CERT" ]] || [[ ! -f "$KEY" ]]; then
  echo "ETCD certificates not found at /etc/kubernetes/pki/etcd/. Are you on a control-plane node?" >&2
  exit 1
fi

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="${BACKUP_DIR}/etcd-$(date +%Y%m%d-%H%M%S).db"

echo "Creating etcd snapshot to $BACKUP_FILE ..."
ETCDCTL_API=3 etcdctl --endpoints https://127.0.0.1:2379 \
  --cacert="$CACERT" \
  --cert="$CERT" \
  --key="$KEY" \
  snapshot save "$BACKUP_FILE"

echo "Compressing backup..."
gzip "$BACKUP_FILE"

echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -name "*.db.gz" -mtime +$RETENTION_DAYS -delete

echo "Backup completed: ${BACKUP_FILE}.gz"