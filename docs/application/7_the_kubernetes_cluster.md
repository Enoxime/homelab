# The kubernetes cluster

The Kubernetes cluster is the main attraction of the homelab. The cluster manage
pretty much all of the applications and VMs. The Kubernetes cluster is composed
of three control plane and five workers. Two workers have a graphic card for the
AI process. The Kubernetes runs on [TalosOS](https://www.talos.dev/). All the
nodes are described in yaml format with
[Talhelper](https://budimanjojo.github.io/talhelper/latest/).

Requirements:

- [age](https://github.com/FiloSottile/age)
- [sops](https://github.com/getsops/sops)
- [talhelper](https://budimanjojo.github.io/talhelper/latest/)

## Talhelper

### Generate a secret under kubernetes/k8s00/talos

```bash
talhelper gensecret > talsecret.sops.yaml
```

### Ensure that the secret stays secret

```bash
# Generate a key and copy the public key
age-keygen -o ~/.config/sops/age/keys.txt

# Move to the talos folder
cd kubernetes/k8s00/talos

# Create a .sops.yaml file in talos folder and paste the public key
cat <<EOD > .sops.yaml
---
creation_rules:
  - age: >-
      PUBLIC_KEY_HERE

EOD

# Encrypt the talsecret.sops.yaml file
sops -ei talsecret.sops.yaml
```

### Generate talconfig.yaml

Refer to
[talhelper configuration](https://budimanjojo.github.io/talhelper/latest/reference/configuration/)

### Generate talos cluster config files and command lines needed

```bash
# To generate the cluster config files
talhelper genconfig

# To apply on nodes to install talosOS
talhelper gencommand apply --extra-flags --insecure

# To bootstrap the cluster
talhelper gencommand bootstrap

# To obtain the kubeconfig of the created cluster
talhelper gencommand kubeconfig

# Ensure the workers a tagged as workers
kubectl label node <worker node name>.... node-role.kubernetes.io/worker=worker
```

## Kubernetes cluster

Move to the folder kubernetes/k8s00

### Boostrap the local storage and cilium

```bash
kubectl kustomize bootstrap --enable-helm | kubectl apply -f -
```

### Bootstrap flux

```bash
export GITHUB_TOKEN=<gh-token>
flux bootstrap github \
  --token-auth \
  --owner=Enoxime \
  --repository=homelab \
  --branch=main \
  --path=kubernetes/clusters/k8s00 \
  --private=false \
  --personal=true
```

### Add SOPS age-key secrets

```bash
cat TO_THE_AGE_KEY | \
  kubectl create secret generic sops-age \
    --namespace=flux-system \
    --from-file=age.agekey=/dev/stdin
```
