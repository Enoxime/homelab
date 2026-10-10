# The bootstrap server

The bootstrap server serves as a PXE server, Unifi Network Application, DNS and
CA server with ACME. It is the main part of our infrastructure that manage the
creation and maintenance of the infrastructure.

> [!TIP]
> Once the Unifi Network Application is set, we can use the DHCP to help the
> Unifi devices to find where is the controller.
> See [Unifi l3 adoption](https://tcpip.wtf/en/unifi-l3-adoption-with-dhcp-option-43-on-pfsense-mikrotik-and-others.htm)

[](application/ignored)

> [!IMPORTANT]
> Sometimes Unifi devices looks for an Unifi host inside the network.
> It is recommended to set a `unifi.YOURDOMA.IN` to point it to the Unifi
> Network Application.

The OS of choice is [IncusOS](https://linuxcontainers.org/incus-os/docs/main/).
I choose IncusOS because it is immutable, easy to configure and maintain.

Requirements:

- ansible
- incus

## Instal IncusOS

### Create a client certificate

Create a client certificate to install with IncusOs. It will permit you to
connect to the remote server via the incus cli tool.

```bash
openssl req \
  -newkey ec:<(openssl ecparam -name secp384r1) \
  -SHA384 \
  -nodes \
  -x509 \
  -keyout client.key \
  -out client.crt \
  -days 36500 \
  -subj '/O=Homelab/CN=IncusOS client certificate'
```

Store the client.crt content in a secret variable for the ansible templates.

### Run the ansible playbook to prepare the required installation files

```bash
ansible-playbook \
  --vault-password-file={path-to-the-password-file} \
  --extra-vars=@{path-to-the-secret-file} \
  --inventory hosts.yaml \
  prepare_infra.yaml \
  --extra-vars ansible_user={local-username}
```

### Generate a USB image with IncusOS

```bash
# see https://linuxcontainers.org/incus-os/docs/main/reference/seed/
podman run --interactive --rm \
  --volume ./incusos:/incusos:rw,Z \
  golang:latest /bin/bash <<EOF
go install github.com/lxc/incus-os/incus-osd/cmd/flasher-tool@latest
tar --create --verbose --file incusos.tar /incusos/*
flasher-tool \
  --channel stable \
  --format img \
  --seed incusos.tar
mv IncusOS*.img /incusos/.
exit
EOF
```

Delete all partitions in the USB if there are some and then install the img file
in the USB.

```bash
sudo dd if=incusos/IncusOS_*.img of=/dev/sda status=progress
```

Make sure to reset the secure boot keys if it is the first time with this
server.
When the installation is done remove the USB key and let the server reboot by
itself.

### Connect to the remote server

Add the prior generated certificate to your local incus trust store.

```bash
incus config trust add-certificate client.crt \
  --name bootstrap \
  --description "bootstrap admin certificate"
```

Then add the remote server to your list.

```bash
incus remote add bootstrap {remote-server-ip-or-hostname}
```

### Optional: add docker|github repositories

```bash
# For docker
incus remote add docker https://docker.io --protocol=oci

# For github container registry (ghcr)
incus remote add github https://ghcr.io --protocol=oci
```

## Configure Incus

```bash
incus config set bootstrap: core.https_address="{mgmt-ip}:8443"

# https://linuxcontainers.org/incus/docs/main/metrics/#add-a-metrics-certificate-to-incus
incus config set bootstrap: core.metrics_address="{metrics-ip}:8443"
```

### Create metrics certificate for monitoring only

```bash
openssl req \
  -x509 \
  -newkey ec \
  -pkeyopt ec_paramgen_curve:secp384r1 \
  -sha384 \
  -nodes \
  -keyout metrics.key \
  -out metrics.crt \
  -days 36500 \
  -subj "/O=Homelab/CN=IncusOS metrics certificate"
```

```bash
incus config trust add-certificate bootstrap: metrics.crt \
  --name bootstrap-metrics \
  --description "bootstrap metrics certificate" \
  --type=metrics
```
