
# standardization

Ensure all instances respect basics policies and compliancy.

- Ensure Python is installed to support Ansible
- Ensure the timezone is set to the correct parameter
- Ensure the correct hostname is set

## Variables

Name | Default value | Description
-- | -- | --
need_sudo | `false` | Boolean. Use sudo to install Python if needed.
package_mgr | `""` | Global variable to set the package manager. Could be apt for example.
pkg_flags | `""` | Add parameters to the package manager if needed.
python | `""` | The python package name.
timezone | `""` | The timezone. Could be UTC for example.
hostname | `{{ inventory_hostname }}` | Set the system hostname. DEfault to the inventory hostname.
hostname_fqdn | `""` | Define the fqdn of the instance. For example: `127.0.0.1 server.local server localhost`
