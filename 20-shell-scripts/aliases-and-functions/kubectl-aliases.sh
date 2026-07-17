#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# kubectl-aliases.sh – Kubernetes CLI aliases and helper functions.
# Source this file in your ~/.bashrc or ~/.zshrc:
#   source /path/to/kubectl-aliases.sh
# -----------------------------------------------------------------------------

# -- Aliases ----------------------------------------------------------------
alias k='kubectl'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kaf='kubectl apply -f'
alias kcf='kubectl create -f'
alias kdf='kubectl delete -f'

alias kgp='kubectl get pods'
alias kgs='kubectl get svc'
alias kgd='kubectl get deploy'
alias kgn='kubectl get nodes'
alias kgns='kubectl get ns'

alias kdp='kubectl describe pod'
alias kdd='kubectl describe deploy'

alias kl='kubectl logs'
alias klf='kubectl logs -f'
alias kex='kubectl exec -it'

# Context & namespace
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# -- Functions --------------------------------------------------------------
# Change namespace interactively using fzf (falls back to plain list)
knsf() {
  local ns
  ns=$(kubectl get ns -o name | cut -d/ -f2 | fzf --prompt="Namespace> ")
  if [[ -n "$ns" ]]; then
    kubectl config set-context --current --namespace="$ns"
    echo "Switched to namespace \"$ns\""
  fi
}

# Get all pods with their node and status
kgpw() {
  kubectl get pods -o wide --all-namespaces "$@"
}

# Describe all pods matching a pattern
kdpn() {
  local pattern="${1:-.}"
  kubectl get pods --all-namespaces -o name | grep "$pattern" | while read pod; do
    echo "======= $pod ======="
    kubectl describe "$pod"
  done
}