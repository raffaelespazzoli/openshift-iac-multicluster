# openshift-iac-multicluster





## Argocd Bootstrap

This will kick off the Day2 configuration in the cluster.
This should be needed only for the first cluster (hub)

```sh
oc apply -k kustomize/argo-bootstrap/openshift-gitops-operator
oc apply -k kustomize/argo-acm-bootstrap -n openshift-gitops
helm upgrade --install pxm-acm-argo-appset helm/charts/argo-application --debug --set clusters.0=pxm-acm -n openshift-gitops
```