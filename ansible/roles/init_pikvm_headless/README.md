
# init_pikvm_headless

This role setup a pikvm system on a SD card to boot headless.

## Variables

Name | Default value | Description
-- | -- | --
init_pikvm_headless_default.device_path | `"/dev/mmcblk0"` | Path of the device to install pikvm.
init_pikvm_headless_default.temporary_folder_path | `"/tmp/pikvm"` | Path where a temporary folder will created for all the operations.
pikvm.hostname | `{}` | (optional) Hostname configuration containing the name and FQDN.
pikvm.hostname.fqdn | `""` | FQDN of the system.
pikvm.hostname.name | `""` | Name of the system.
pikvm.ip | `{}` | (optional) Network definition for the system.
pikvm.ip.address | `""` | CIDR of the IP address like `192.168.0.5/24`.
pikvm.ip.gateway | `""` | Network gateway like `192.168.0.1`.
pikvm.ip.dns | `[]` | DNS list for the default interface.
