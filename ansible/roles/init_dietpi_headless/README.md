
# init_dietpi_headless

This role setup a dietpi system on a SD card to boot headless.

## Variables

Name | Default value | Description
-- | -- | --
init_dietpi_headless_device_path | `/dev/mmcblk0` | Path to the block device.
init_dietpi_headless_temporary_folder_path | `/tmp/init_dietpi_headless` | Path to the temporary folder.
idh.default_password | `dietpi` | Root password of the machine. Strongly recommended to change it.
idh.hostname | `dietpi` | Hostname of the dietpi.
idh.net.dns | `[]` | List of dns IPs.
idh.net.gateway | `""` | Define the network gateway.
idh.net.ip | `""` | Define the static IP.
idh.net.mask | `255.255.255.0` | Define the netmask.
idh.net.static_ip | `0` | Define if the ip is static or not.
idh.net.wifi | `{}` | Enable the wifi configuration.
idh.net.wifi.country_code | `US` | Mandatory! Ensure that you set the correct country as different countries have different frequences in which they have the right to use. For more information, see the [dietpi.txt](./templates/dietpi.txt) template.
idh.net.wifi.name | `""` | Mandatory. SSID or "wifi name" in which the dietpi will connect to.
idh.net.wifi.password | `""` | Mandatory. The password of the wifi.
idh.root_ssh_pubkey | `""` | Mandatory if you want to be able to ssh into your headless dietpi.
idh.softwares | `[]` | List of softwares you wish to install. See [softwares](https://github.com/MichaIng/DietPi/wiki/DietPi-Software-list) for more informations.
idh.timezone | `UTC` | Set the system timezone.
