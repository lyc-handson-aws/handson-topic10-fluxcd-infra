kubectl port-forward svc/argocd-argocd-topic10-server -n argocd 9999:443 &
argocd admin initial-password -n argocd
argocd login localhost:9999 --username admin --password xxxxxx 
argocd account update-password
kubectl config set-context --current --namespace=argocd