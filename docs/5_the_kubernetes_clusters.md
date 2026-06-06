# The kubernetes cluster

The Kubernetes clusters are the main attractions of the homelab. The clusters
manage pretty much all of the applications and VMs. The Kubernetes cluster k8s00
is composed of three control plane and five workers. One worker have two graphic
cards for the AI process. The Kubernetes runs on
[Talos](https://www.talos.dev/). All the nodes are described in yaml format with
[Talhelper](https://budimanjojo.github.io/talhelper/latest/).

Requirements:

- [age](https://github.com/FiloSottile/age)
- [sops](https://github.com/getsops/sops)
- [talhelper](https://budimanjojo.github.io/talhelper/latest/)

## Talhelper

### Generate a secret under kubernetes/starter/{cluster_name}/talos

```bash
talhelper gensecret > talsecret.sops.yaml
```

### Ensure that the secret stays secret

```bash
# Generate a key and copy the public key
age-keygen -o ~/.config/sops/age/keys.txt

# Move to the talos folder
cd kubernetes/starter/{cluster_name}/talos

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

# To obtain the kubeconfig of the created cluster (when multiple clusters are defined)
talhelper gencommand kubeconfig --extra-flags --merge

# Ensure the workers a tagged as workers
kubectl label node <worker node name>.... node-role.kubernetes.io/worker=worker
```

## Kubernetes cluster

Move to the folder kubernetes/starter/{cluster_name}

### Boostrap the local storage and cilium

```bash
kubectl kustomize bootstrap --enable-helm | kubectl apply -f -
```

### Bootstrap fluxcd

```bash
flux install

flux create source git homelab \
  --url=https://github.com/Enoxime/homelab \
  --branch=main \
  --interval=1m

flux create kustomization {cluster_name} \
  --source=GitRepository/homelab \
  --path=./kubernetes/clusters/{cluster_name} \
  --decryption-provider=sops \
  --decryption-secret=sops-age \
  --prune=true \
  --interval=10m
```

For the legacy way (only on k8s00):

```bash
export GITHUB_TOKEN=<gh-token>
flux bootstrap github \
  --token-auth \
  --owner=Enoxime \
  --repository=homelab \
  --branch=main \
  --path=kubernetes/clusters/{cluster_name} \
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

## Upgrades

### To upgrade Talos

```bash
talhelper gencommand upgrade
```

### To upgrade Kubernetes

> [!IMPORTANT]
> Check the state of the rook-ceph cluster during the upgrade.

```bash
talhelper gencommand upgrade-k8s

# Change the version to the one needed and check the state of the rook-ceph
# cluster during the upgrade process.

kubectl rook-ceph ceph status
```

## Cluster specific information

- [bootstrap00](./kubernetes/bootstrap00/README.md)
- [k8s00](./kubernetes/k8s00/README.md)
