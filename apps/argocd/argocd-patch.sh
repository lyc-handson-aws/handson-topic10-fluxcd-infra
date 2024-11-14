#kubectl patch cm argocd-cmd-params-cm -n argocd --type merge -p '{"data":{"application.namespaces":"app1,app2"}}'
#kubectl rollout restart -n argocd deployment argocd-argocd-topic10-server
#kubectl rollout restart -n argocd statefulset argocd-argocd-topic10-application-controller

#port-forward the argocd service
kubectl port-forward svc/argocd-server -n argocd 8080:443

#init admin user password
argocd admin initial-password -n argocd

# add 2 user
kubectl patch configmap argocd-cm -n argocd --type merge -p '
{
  "data": {
    "accounts.ops-project": "login",
    "accounts.ops-infra": "apiKey,login",
    "accounts.greader": "login"
  }
}'

# check users are created
argocd account list

#context namespace need to be argocd, if it's not set before
kubectl config set-context --current --namespace=argocd

#login a user 
argocd login --username admin --password xxxxx
#update 
argocd account update-password --account ops-infra --current-password current_user_pwd --new-password new_account_pwd
#will be launched in ci to give a temporary access
argocd account generate-token --account xx --expires-in 15m 

#define 2 roles and assigne 2 roles to 2 created users
kubectl patch configmap argocd-rbac-cm -n argocd --type merge -p '
{
  "data": {
    "policy.csv": "p, greader, applications, get, */*, allow\np, greader, projects, get, */*, allow\np, role:opsproject, applications, *, */*, allow\np, role:opsproject, repositories, *, */*, allow\np, role:opsproject, logs, get, *, allow\np, role:opsproject, clusters, *, */*, allow\np, role:opsproject, exec, *, */*, allow\np, role:opsproject, certificates, sync, */*, deny\np, role:opsproject, gpgkeys, sync, */*, deny\np, role:opsproject, accounts, sync, */*, deny\np, role:opsproject, extensions, sync, */*, deny\ng, ops-project, role:opsproject\ng, ops-infra, role:admin"
  }
}'
