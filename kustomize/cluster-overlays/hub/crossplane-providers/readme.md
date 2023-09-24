manually run this command

```sh
oc delete secret azure-secret -n crossplane-system
oc create secret generic azure-secret -n crossplane-system --from-file=creds=./kustomize/cluster-overlays/hub/crossplane-providers/azure-credentials.json



oc create secret generic aws-secret -n crossplane-system --from-file=creds=./kustomize/cluster-overlays/hub/crossplane-providers/aws-credentials.txt

oc create secret generic ocm-token -n rosa-decl --from-file=token=./kustomize/cluster-overlays/hub/crossplane-providers/ocm-token.json

```