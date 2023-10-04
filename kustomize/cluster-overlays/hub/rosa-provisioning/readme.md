```sh
oc delete secret cluster-admin -n rosa-decl
oc create secret generic cluster-admin -n rosa-decl --from-file=admin-json=./kustomize/cluster-overlays/hub/rosa-provisioning/cluster-admin.json
```
