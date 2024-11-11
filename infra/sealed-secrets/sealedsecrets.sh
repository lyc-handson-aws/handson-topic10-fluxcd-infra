kubeseal --fetch-cert --controller-namespace=flux-system > mycert.pem

kubectl -n default create secret generic basic-auth \
--from-literal=user=admin \
--from-literal=password=change-me \
--dry-run=client \
-o yaml > basic-auth.yaml