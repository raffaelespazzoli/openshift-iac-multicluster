```sh
oc delete secret admin-secret -n rosa-decl
oc create secret generic admin-secret -n rosa-decl --from-file=admin-json=./kustomize/cluster-overlays/hub/rosa-provisioning/admin-secret.json
```