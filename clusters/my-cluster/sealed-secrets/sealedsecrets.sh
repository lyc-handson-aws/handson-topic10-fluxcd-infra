kubeseal --fetch-cert --controller-namespace=flux-system > mycert.pem

kubectl -n default create secret generic basic-auth \
--from-literal=AWS_ACCESS_KEY_ID=xxxxxxx \
--from-literal=AWS_SECRET_ACCESS_KEY=xxxxx \
--dry-run=client \
-o yaml > aws-credentials.yaml

kubeseal --format=yaml --cert=pub-sealed-secrets.pem \
< aws-credentials.yaml > aws-credentials-sealed.yaml