#!/bin/bash
set -e

echo "[INFO] Generating kubeconfig dynamically..."

mkdir -p /var/jenkins_home/.kube

export KUBECONFIG=/var/jenkins_home/.kube/config
export TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
export CA_CERT="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
export SERVER="https://kubernetes.default.svc"

kubectl config set-cluster default-cluster \
  --server="${SERVER}" \
  --certificate-authority="${CA_CERT}" \
  --embed-certs=true \
  --kubeconfig="${KUBECONFIG}"

kubectl config set-credentials default-user \
  --token="${TOKEN}" \
  --kubeconfig="${KUBECONFIG}"

kubectl config set-context default-context \
  --cluster=default-cluster \
  --user=default-user \
  --kubeconfig="${KUBECONFIG}"

kubectl config use-context default-context --kubeconfig="${KUBECONFIG}"

echo "[INFO] Starting Jenkins..."
exec /usr/local/bin/jenkins.sh
