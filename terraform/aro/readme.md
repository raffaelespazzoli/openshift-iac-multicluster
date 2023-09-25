```sh
terraform apply -var-file ./vars.json -var-file ../../kustomize/cluster-overlays/hub/crossplane-providers/azure-credentials.json -var-file ../../kustomize/cluster-overlays/hub/aro-provisioning/azure-credentials.json -var-file ./pull-secret.json
```