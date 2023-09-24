oc delete secret azure-sp -n aro-decl
oc create secret generic azure-sp -n aro-decl --from-file=creds=./kustomize/cluster-overlays/hub/crossplane-providers/azure-credentials.json