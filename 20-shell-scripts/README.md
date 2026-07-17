# Shell Scripts for Kubernetes Management

This directory contains a curated collection of shell scripts, aliases, and
automation helpers for everyday Kubernetes operations.

## Directory Layout

| Folder                   | Purpose                                                     |
| ------------------------ | ----------------------------------------------------------- |
| `aliases-and-functions/` | Reusable kubectl aliases, functions, and prompt setup.      |
| `cluster-management/`    | Scripts to switch contexts, cordon/drain nodes, etc.        |
| `installation-tools/`    | Installers for kubectl, kind, minikube, Helm.               |
| `monitoring-logging/`    | Real-time log streaming and resource monitoring.            |
| `security/`              | Image scanning with Trivy, CIS benchmark with kube-bench.   |
| `backup-restore/`        | etcd backup for kubeadm clusters, Velero scheduled backups. |

All scripts are idempotent where possible and include basic error handling.
