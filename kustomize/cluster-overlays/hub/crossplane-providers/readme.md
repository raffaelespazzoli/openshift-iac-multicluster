manually run this command

```sh
oc create secret generic azure-secret -n aro-decl --from-file=creds=./kustomize/cluster-overlays/hub/crossplane-providers/azure-credentials.json

oc create secret generic aws-secret -n crossplane-system --from-file=creds=./kustomize/cluster-overlays/hub/crossplane-providers/aws-credentials.txt

```