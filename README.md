# openshift-iac-multicluster





## Argocd Bootstrap

This will kick off the Day2 configuration in the cluster.
This should be needed only for the first cluster (hub)

```sh
oc apply -k kustomize/argo-bootstrap/openshift-gitops-operator
oc apply -k kustomize/argo-bootstrap/openshift-gitops-config -n openshift-gitops
helm upgrade --install hub-argo-appset helm/charts/argo-application --set clusters={hub} -n openshift-gitops
```