# The kubernetes cluster

The Kubernetes clusters are the main attractions of the homelab. The clusters
manage pretty much all of the applications and VMs. The Kubernetes cluster k8s00
is composed of three control plane and five workers. One worker have two graphic
cards for the AI process. The Kubernetes runs on
[Talos](https://www.talos.dev/). All the nodes are described in yaml format with
[Topf](https://postfinance.github.io/topf/main/).

Requirements:

- [age](https://github.com/FiloSottile/age)
- [sops](https://github.com/getsops/sops)
- [Topf](https://postfinance.github.io/topf/main/)

## topf

[topf website](https://postfinance.github.io/topf/main/)

### Generate topf.yaml file under kubernetes/starter/{cluster_name}/topf

Create a topf.yaml file by following
[this link](https://postfinance.github.io/topf/main/getting-started/)

### Generate a secret under kubernetes/starter/{cluster_name}/topf

```bash
# answer 'y' to confirm the generation of secrets
topf secrets > secrets.yaml
```

### Ensure that the secret stays secret

```bash
# Generate a key and copy the public key
age-keygen -o ~/.config/sops/age/keys.txt

# Move to the topf folder
cd kubernetes/starter/{cluster_name}/topf

# Create a .sops.yaml file in topf folder and paste the public key
cat <<EOD > .sops.yaml
---
creation_rules:
  - age: >-
      PUBLIC_KEY_HERE
    path_regex: topf\.yaml
    encrypted_regex: ^(data|clusterEndpoint|host)$
  - age: >-
      PUBLIC_KEY_HERE
    path_regex: secrets\.yaml
  - age: >-
      PUBLIC_KEY_HERE
stores:
  yaml:
    indent: 2

EOD

# Encrypt the secrets.yaml file
sops encrypt -i secrets.yaml

# Encrypt the topf.yaml file
sops encrypt -i topf.yaml

# Create a gitignore file
cat <<EOD > .gitignore
output/
talosconfig
kubeconfig

EOD
```

### Generate talos cluster config files and command lines needed

```bash
# To generate the cluster config files
topf render

# To generate the talos config file
topf talosconfig > talosconfig

# To apply on nodes to install talosOS
topf apply
# or
talosctl apply-config \
  --nodes <node> \
  --talosconfig ./talosconfig \
  --insecure \
  --file ./output/<node>.yaml

# To bootstrap the cluster
talosctl bootstrap \
  --nodes <first-control-plane> \
  --endpoint <first-control-plane> \
  --talosconfig ./talosconfig

# To obtain the kubeconfig of the created cluster for one year validity
# (default is 12h)
topf kubeconfig --validity 8760h > kubeconfig
# or
talosctl kubeconfig --talosconfig=./talosconfig

# To obtain the kubeconfig of the created cluster (when multiple clusters are defined)
talosctl kubeconfig --talosconfig=./talosconfig --merge
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

# Add SOPS age-key secrets
cat <path-to-age-key> | \
  kubectl create secret generic sops-age \
    --namespace=flux-system \
    --from-file=age.agekey=/dev/stdin \
    --dry-run=client -o yaml | kubectl apply -f -

flux create kustomization {cluster_name} \
  --source=GitRepository/homelab \
  --path=./kubernetes/clusters/{cluster_name} \
  --decryption-provider=sops \
  --decryption-secret=sops-age \
  --prune=true \
  --interval=10m
```

## Upgrades

### To upgrade Talos

```bash
topf upgrade
```

### To upgrade Kubernetes

> [!IMPORTANT]
> Check the state of the rook-ceph cluster during the upgrade.

```bash
talosctl upgrade-k8s --to=v<kubernetes-version> --nodes=<control-plane-node>

# Change the version to the one needed and check the state of the rook-ceph
# cluster during the upgrade process.

kubectl rook-ceph ceph status
```

## Cluster specific information

- [bootstrap00](./kubernetes/bootstrap00/README.md)
- [k8s00](./kubernetes/k8s00/README.md)
