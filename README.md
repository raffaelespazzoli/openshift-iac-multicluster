# openshift-iac-multicluster





## Argocd Bootstrap

This will kick off the Day2 configuration in the cluster.
This should be needed only for the first cluster (hub)

```sh
oc apply -f boostrap/subscription.yaml
oc apply -f boostrap/argocd.yaml -n openshift-gitops
oc apply -f boostrap/cluster-rolebinding.yaml -n openshift-gitops
oc apply -f boostrap/applicationset.yaml -n openshift-gitops
```