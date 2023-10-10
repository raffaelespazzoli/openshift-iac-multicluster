# ARO - ROSA - Declarative

We assume you have a running cluster and credentials for ARO and ROSA.

## Creating the credentials

Run the following to create the secrets needed for the ARO and ROSA credentials

```sh

```



## Argocd Bootstrap

This will kick off the Day2 configuration in the cluster.
This should be needed only for the first cluster (hub)

```sh
oc apply -f boostrap/subscription.yaml
oc apply -f boostrap/argocd.yaml -n openshift-gitops
oc apply -f boostrap/cluster-rolebinding.yaml -n openshift-gitops
oc apply -f boostrap/applicationset.yaml -n openshift-gitops
```

After the the configurations are deployed, the provisioning of ARO and ROSA clusters will start automatically.