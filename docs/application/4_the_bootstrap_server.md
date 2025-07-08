# The bootstrap server

As mentioned above, the bootstrap server serves as a PXE server, Unifi Network
Application and Ansible and Terraform agent. It is the main part of our
infrastructure that manage the creation and maintenance of the infrastructure.

TODO: Find a way to enable via the butane file the docker.service.

> [!TIP]
> Once the Unifi Network Application is set, we can use the DHCP to help the
> Unifi devices to find where is the controller.
> See [Unifi l3 adoption](https://tcpip.wtf/en/unifi-l3-adoption-with-dhcp-option-43-on-pfsense-mikrotik-and-others.htm)

[](ignored)

> [!IMPORTANT]
> Sometimes Unifi devices looks for an Unifi host inside the network.
> I would recommend to set a `unifi.YOURDOMA.IN` to point it to the Unifi
> Network Application.

The OS of choice is [flatcar](https://www.flatcar.org/). I choose flatcar
because it is pretty simple. It is an immutable OS that update itself
automatically. It will be used to host containers and that is all. To set up a
flatcar system, we will need to configure what we would like it to be with what
is called a butane file. It is pretty much a yaml file wrapped with a butane
specification. Once done, the butane file should be transformed to an ignition
file which is a json file of the yaml one (there are some differences but I will
let you learn that by yourself). The next step is to upload it to install
flatcar in the bootstrap server.

- [Butane to ignition](#butane-to-ignition)
- [Start flatcar on Bootstrap](#start-flatcar-on-bootstrap)
- [Start the ignition file server](#start-the-ignition-file-server)
- [Download the ignition file and install the system](#download-the-ignition-file-and-install-the-system)
- [Install the bootstrap system](#install-the-bootstrap-system)

## Butane to ignition

Once the butane file is ready to be used I use an ansible-playbook to transform
it. See the
[documentation on the role](../../ansible/roles/flatcar/tasks/README.md).
Run [prepare_infra.yaml](../../ansible/prepare_infra.yaml).

```bash
ansible-playbook \
  --vault-password-file=/PATH_TO_SECRET_FILE/secret \
  --extra-vars=@/PATH_TO_VARIABLES_FILE/variables.yaml \
  --limit bootstrap \
  --inventory hosts.yaml \
  --tags flatcar_butane \
  prepare_infra.yaml
```

## Start flatcar on Bootstrap

Go to the [flatcar](https://www.flatcar.org/) website, download an image and
upload it in a USB key. Once done, start the Bootstrap server via the USB key.

## Start the ignition file server

Now we need to share the ignition file to the Bootstrap server. To do so, the
simple way would be to share the file via another USB key or to start an NGINX
server to retrieve our file.

```bash
# Go to the folder that contain the ignition file
cd flatcar

# Get the iP of the nginx server
ip a

# Start the nginx server
sudo podman run \
  --interactive \
  --tty \
  --rm \
  --name deploy_flatcar \
  --volume ./:/usr/share/nginx/html:ro \
  --publish 8080:80 \
  docker.io/nginx
```

## Download the ignition file and install the system

On the Bootstrap server curl the ignition file then start the installation.

```bash
# Curl the ignition file
curl http://IP_OF_THE_NGINX_SERVER:8080/bootstrap.ignition.json \
  --output /tmp/bootstrap.ignition.json

# Install flatcar
sudo flatcar-install \
  -d /dev/DISK_WHERE_TO_INSTALL_FLATCAR \
  -C stable \
  -i /tmp/bootstrap.ignition.json

# Last step is to reboot and remove the USB key
sudo reboot
```

## Install the bootstrap system

Now the only thing to do is to install netbootxyz, Unifi network application and
semaphore (Ansible and Terrafom/Tofu) via containers. All the endpoints will
be managed by Traefik and the auto-update of container versions will be managed
by beatkind/watchtower. The official Watchtower seems to not be maintained
anymore. Refer to the documentations on
[directories_files](../../ansible/roles/directories_files/README.md) and
[docker_mgmt](../../ansible/roles/docker_mgmt/README.md).
Run [setup.yaml](../../ansible/setup.yaml).

```bash
ansible-playbook \
  --vault-password-file=/PATH_TO_SECRET_FILE/secret \
  --extra-vars=@/PATH_TO_VARIABLES_FILE/variables.yaml \
  --limit bootstrap \
  --inventory hosts.yaml \
  setup.yaml
```
