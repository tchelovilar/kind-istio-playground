# Kind Istio Playground

Spin up a local Kubernetes cluster using kind to execute experiments on istio.


## Pre requisites

- kind
- kubectl
- helm


## Creating local cluster

Run the command `make start` to init the local cluster.

```
make start
```

Once is started you can access the test website from:
https://localhost:8443/web


## Generating istio settings

```
# Operator
istioctl operator dump > manifests/istio-operator/operator/dump.yaml

# Istio
istioctl profile dump demo > manifests/istio-system/istio/dump.yaml
```
