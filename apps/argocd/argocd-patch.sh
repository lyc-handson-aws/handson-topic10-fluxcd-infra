# add 2 user
kubectl patch configmap argocd-cm -n argocd --type merge -p '
{
  "data": {
    "accounts.ops-project": "login",
    "accounts.ops-infra": "apiKey,login"
    "accounts.greader": "login"
  }
}'


#context namespace need to be argocd, if it's not set before
kubectl config set-context --current --namespace=argocd
# check user
argocd account list
#update 
argocd account update-password --account ops-infra --current-password $current_user_pwd --new-password $new_account_pwd
#will be launched in ci to give a temporary access
argocd account generate-token --account xx --expires-in 15m 

#define 2 roles and assigne 2 roles to 2 created users
kubectl patch configmap argocd-rbac-cm -n argocd --type merge -p '
{
  "data": {
    "policy.csv": "p, greader, applications, get, */*, allow\np, greader, projects, get, */*, allow\np, role:opsproject, applications, *, */*, allow\np, role:opsproject, repositories, *, */*, allow\np, role:opsproject, logs, get, *, allow\np, role:opsproject, clusters, *, */*, allow\np, role:opsproject, exec, *, */*, allow\np, role:opsproject, certificates, sync, */*, deny\np, role:opsproject, gpgkeys, sync, */*, deny\np, role:opsproject, accounts, sync, */*, deny\np, role:opsproject, extensions, sync, */*, deny\ng, ops-project, role:opsproject\ng, ops-infra, role:admin"
  }
}'


