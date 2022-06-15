#!/bin/bash

# Tool Versions
CERTMANAGER_VERSION=1.8.0

# General Settings
CLUSTER_NAME=istio-mtls

# Exit in case of Mac
[[ "$(uname -s)" == "Darwin"* ]] && echo "Mac not supported" && exit 1


# Configure kind cluster
if ! kind get clusters | grep -s  -e "^${CLUSTER_NAME}$"
then
  if ! kind create cluster --name "$CLUSTER_NAME" --config=kind/config.yaml
  then
    echo "Fail to create kind cluster"
    exit 1
  fi
fi


kubectl create -f manifests/namespaces.yaml

##
## Install certmanager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v${CERTMANAGER_VERSION}/cert-manager.yaml
kubectl wait -n cert-manager --timeout=300s deployment/cert-manager-webhook --for condition=available

##
## Set up istio operator
kubectl apply -f manifests/istio-operator/operator/dump.yaml
kubectl wait -n istio-operator --timeout=300s deployment/istio-operator --for condition=available

##
## Create istio controller
kubectl apply -f manifests/istio-system/istio/istio.yaml
kubectl apply -f manifests/istio-system/istio/certificate.yaml

# Wait for istio be ready
sleep 10
kubectl wait -n istio-system --timeout=300s istiooperators/istio --for=jsonpath='{.status.status}'=HEALTHY

kubectl apply -f manifests/istio-system/istio/

# Apply web container test
kubectl apply -f manifests/default/web/

##
## Install prometheus stack
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install -n prometheus prometheus -f helm/prometheus/operator/values.yaml prometheus-community/kube-prometheus-stack
