# Kind Istio Playground

Spin up a local Kubernetes cluster using kind to execute experiments on istio.

## Generating istio settings

```
# Operator
istioctl operator dump > manifests/istio-operator/operator/dump.yaml

# Istio
istioctl profile dump demo > manifests/istio-system/istio/dump.yaml
```