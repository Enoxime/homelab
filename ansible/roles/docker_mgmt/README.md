
# docker_mgmt

Manage docker networks, volumes and containers.

## Variables

Name | Default value | Description
-- | -- | --
docker_mgmt.networks | `[]` | List of docker networks.
docker_mgmt.networks[].driver | `"bridge"` | The network driver.
docker_mgmt.networks[].name | `""` | The network name.
docker_mgmt.volumes | `[]` | List of volumes to declare.
docker_mgmt.volumes[].driver_options | `{}` | Dictionary of driver options.
docker_mgmt.volumes[].name | `""` | Volume name.
docker_mgmt.containers | `[]` | List of containers declaration.
docker_mgmt.containers[].capabilities | `[]` | List of capabilities.
docker_mgmt.containers[].command | `"" OR []` | Command to execute. Could be a string or a list.
docker_mgmt.containers[].devices | `[]` | List of device bindings to add to the container.
docker_mgmt.containers[].env | `{}` | Dictionary of environment variables.
docker_mgmt.containers[].exposed_ports | `[]` | List of exposed ports.
docker_mgmt.containers[].groups | `[]` | List of groups the container will run as.
docker_mgmt.containers[].healthcheck | `{}` | Health checks for the container.
docker_mgmt.containers[].image | `""` | Path to the image.
docker_mgmt.containers[].labels | `{}` | Dictionary of labels.
docker_mgmt.containers[].name | `""` | Container name.
docker_mgmt.containers[].network_mode | `""` | Connect the container to a network.
docker_mgmt.containers[].networks | `[]` | List of network the container belongs to.
docker_mgmt.containers[].privileged | `false` | Give extended privileges to the container.
docker_mgmt.containers[].published_ports | `[]` | List of ports to publish.
docker_mgmt.containers[].restart_policy | `"unless-stopped"` | Container restart policy.
docker_mgmt.containers[].user | `""` | User the container will run as.
docker_mgmt.containers[].volumes | `[]` | List of volumes to mount.
docker_mgmt.debug | `false` | Display the content of the deployment including the secrets contains in variables.
