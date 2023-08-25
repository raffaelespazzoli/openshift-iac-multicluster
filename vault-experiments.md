# Some Experiments with vault

Requirements

- secrets will be organized in this fashion `/root/<cluster>/applications/<cmdbid>/<namespace>/static-secrets/<secret-name>`
- openshift namespace naming convention: `<application>-<environment>`
- okta group for openshift: `prefix.<cmdbid>.<environment>.<role>`
- okta group for vault: `prefix.<cmdbid>.<role>`


## Create Okta configuration in Vault

```sh
source vault-experiments-secrets.sh
export VAULT_TOKEN=$(oc get secret vault-init -n vault -o json | jq -r .data.root_token | base64 -d)
export VAULT_ADDR=https://$(oc get route vault -n vault -o jsonpath="{.spec.host}")
export VAULT_SKIP_VERIFY=true
export OKTA_CLIENT_ID=0oaau92rizgjZ2l935d7
export OKTA_CLIENT_SECRET=${okta_secret}
export OKTA_DOMAIN=dev-98921715.okta.com
export CLUSTER=lab
export ENVIRONMENTS=("dev" "sit" "uat")
declare -A CMDBIDS
export CMDBIDS=([app1]=cmdb1 [app2]=cmdb2)
declare -A APPLICATIONS
export APPLICATIONS=([cmdb1]=app1 [cmdb2]=app2)



for cmdbid in ${CMDBIDS[@]}; do
cat << EOF | vault policy write secret-writer-${cmdbid} -
# Read permission on the secrets
path "/root/${CLUSTER}/applications/${cmdbid}/*" {
    capabilities = ["list", "create", "update", "delete"]
}
EOF
done

# Prepare human authentication

vault auth enable -path=/${CLUSTER}/okta oidc 

vault write auth/${CLUSTER}/okta/config \
         oidc_discovery_url="https://$OKTA_DOMAIN" \
         oidc_client_id="$OKTA_CLIENT_ID" \
         oidc_client_secret="$OKTA_CLIENT_SECRET" \
         default_role="vault-role-okta-default"

vault write auth/${CLUSTER}/okta/role/vault-role-okta-group-vault-developer \
      bound_audiences="$OKTA_CLIENT_ID" \
      allowed_redirect_uris="$VAULT_ADDR/ui/vault/auth/oidc/oidc/callback" \
      allowed_redirect_uris="http://localhost:8250/oidc/callback" \
      user_claim="sub" \
      token_policies="default" \
      oidc_scopes="groups" \
      groups_claim="groups"

OIDC_AUTH_ACCESSOR=$(vault auth list -format=json  | jq -r '."'${CLUSTER}/okta/'".accessor')      

for cmdbid in ${CMDBIDS[@]}; do
      vault write identity/group name="prefix.${cmdbid}.secretsetter" type="external" \
            policies="secret-writer-${cmdbid}" \
            metadata=application="${cmdbid}"
      GROUP_ID=$(vault read -field=id identity/group/name/prefix.${cmdbid}.secretsetter)
      vault write identity/group-alias name="prefix.${cmdbid}.secretsetter" \
            mount_accessor="${OIDC_AUTH_ACCESSOR}" \
            canonical_id="${GROUP_ID}"      
done 

# Prepare secret kv engine

for cmdbid in ${CMDBIDS[@]}; do
      echo ${cmdbid}
      echo ${APPLICATIONS[${cmdbid}]}
      for env in ${ENVIRONMENTS[@]}; do
            echo ${env}
            vault secrets enable -version=1 -path=/root/${CLUSTER}/applications/${cmdbid}/${APPLICATIONS[${cmdbid}]}-${env}/static-secrets kv
      done
done

# Prepare kube authentication

vault auth enable -path=/${CLUSTER}/kubernetes kubernetes
oc get configmap kube-root-ca.crt -n default -o jsonpath='{.data.ca\.crt}' > /tmp/ca.crt
vault write auth/${CLUSTER}/kubernetes/config \
    kubernetes_host=https://kubernetes.default.svc:443 \
    kubernetes_ca_cert=@/tmp/ca.crt

KUBE_AUTH_ACCESSOR=$(vault auth list -format=json  | jq -r '."'${CLUSTER}/kubernetes/'".accessor') 

for cmdbid in ${CMDBIDS[@]}; do
cat << EOF | vault policy write secret-reader-${cmdbid} -
# Read permission on the secrets
path "/root/${CLUSTER}/applications/${cmdbid}/{{identity.entity.aliases.${KUBE_AUTH_ACCESSOR}.metadata.service_account_namespace}}/*" {
    capabilities = ["read", "list"]
}
EOF

NAMESPACES=()
for env in ${ENVIRONMENTS[@]}; do {
      ns="${APPLICATIONS[${cmdbid}]}-${env}"
      echo "$ns"
      oc create namespace "${ns}" 2>/dev/null || oc get namespace "${ns}" 
      oc create sa -n "${ns}" "${ns}" 2>/dev/null || oc get sa -n "${ns}" "${ns}"
      NAMESPACES+=(bound_service_account_namespaces="$ns")
}
done

echo "${NAMESPACES[*]}"
echo "$(IFS=,; echo "${NAMESPACES[*]}")"

vault write auth/${CLUSTER}/kubernetes/role/${cmdbid} "$(IFS=,; echo "${NAMESPACES[*]}")" \
    bound_service_account_names="*" \
    policies=secret-reader-${cmdbid} \
    ttl=1h
done

```

## test user

```sh
export VAULT_ADDR=https://$(oc get route vault -n vault -o jsonpath="{.spec.host}")
export VAULT_SKIP_VERIFY=true
export CLUSTER=lab
export ENVIRONMENT=dev
export APPLICATION=app1
export CMDBID=cmdb1
vault login -method=oidc -path=/${CLUSTER}/okta role="vault-role-okta-group-vault-developer"
vault kv put -mount=/root/${CLUSTER}/applications/${CMDBID}/${APPLICATION}-${ENVIRONMENT}/static-secrets foo bar=baz

# this should fail:
vault kv get -mount=/root/${CLUSTER}/applications/${CMDBID}/${APPLICATION}-${ENVIRONMENT}/static-secrets foo
```


## test service account

```sh
export VAULT_ADDR=https://$(oc get route vault -n vault -o jsonpath="{.spec.host}")
export VAULT_SKIP_VERIFY=true
export CLUSTER=lab
export ENVIRONMENT=dev
export APPLICATION=app1
export CMDBID=cmdb1
export JWT_TOKEN=$(oc create token ${APPLICATION}-${ENVIRONMENT} -n ${APPLICATION}-${ENVIRONMENT})
export VAULT_TOKEN=$(vault write -format json auth/${CLUSTER}/kubernetes/login role=${CMDBID} jwt=${JWT_TOKEN} | jq -r .auth.client_token)
vault kv get -mount=/root/${CLUSTER}/applications/${CMDBID}/${APPLICATION}-${ENVIRONMENT}/static-secrets foo

# this should fail
vault kv put -mount=/root/${CLUSTER}/applications/${CMDBID}/${APPLICATION}-${ENVIRONMENT}/static-secrets foo bar=baz
```


# Test IaC

developer

```sh
export VAULT_ADDR=https://$(oc get route vault -n vault -o jsonpath="{.spec.host}")
export VAULT_SKIP_VERIFY=true
export CLUSTER=hub
export ENVIRONMENT=dev
export APPLICATION=app1
export CMDBID=cmdb1
vault login -method=oidc -path=/${CLUSTER}/okta role="vault-developer"
vault kv put -mount=/root/${CLUSTER}/applications/${CMDBID}/${APPLICATION}-${ENVIRONMENT}/static-secrets-${APPLICATION} foo bar=baz

# this should fail:
vault kv get -mount=/root/${CLUSTER}/applications/${CMDBID}/${APPLICATION}-${ENVIRONMENT}/static-secrets-${APPLICATION} foo
```

service account

```sh
export VAULT_ADDR=https://$(oc get route vault -n vault -o jsonpath="{.spec.host}")
export VAULT_SKIP_VERIFY=true
export CLUSTER=hub
export ENVIRONMENT=dev
export APPLICATION=app1
export CMDBID=cmdb1
export ns=${APPLICATION}-${ENVIRONMENT}
oc create sa -n "${ns}" "${ns}" 2>/dev/null || oc get sa -n "${ns}" "${ns}"
export JWT_TOKEN=$(oc create token ${ns} -n ${ns})
export VAULT_TOKEN=$(vault write -format json auth/${CLUSTER}/kubernetes/login role=secret-reader-${CMDBID} jwt=${JWT_TOKEN} | jq -r .auth.client_token)
vault kv get -mount=/root/${CLUSTER}/applications/${CMDBID}/${ns}/static-secrets-${APPLICATION} foo

# this should fail
vault kv put -mount=/root/${CLUSTER}/applications/${CMDBID}/${ns}/static-secrets-${APPLICATION} foo bar=baz
```