# garage

```bash
# Get status
kubectl exec --stdin --tty -n garage garage-0 -- ./garage status

# initiate node in layout then apply changes
kubectl exec \
  --stdin \
  --tty \
  -n garage garage-0 -- ./garage layout assign NODE-ID \
    -z home \
    -c 1TB \
    -t k8s00 \
    -t nas \
    -t homelab
kubectl exec --stdin --tty -n garage garage-0 -- ./garage layout show
kubectl exec --stdin --tty -n garage garage-0 -- ./garage layout apply \
  --version 1
kubectl exec --stdin --tty -n garage garage-0 -- ./garage status

# Set aws-cli to browse the object storage
mkdir -p $HOME/.aws

cat <<EOD > $HOME/.aws/credentials
[default]
aws_access_key_id=<AWS_ACCESS_KEY_ID>         # Replace with your AWS access key ID
aws_secret_access_key=<AWS_SECRET_ACCESS_KEY> # Replace with your AWS secret access key
EOD

cat <<EOD > $HOME/.aws/config
[default]
region=garage
endpoint_url=<endpoint_url> # scheme://host:port
EOD
```
