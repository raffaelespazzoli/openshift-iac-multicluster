manually run this command

```sh
oc create secret generic azure-secret -n crossplane-system --from-file=creds=./azure-credentials.json
```