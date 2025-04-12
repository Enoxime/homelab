
# base

This role is used to setup the basics for an Debian based server as:

- Set timezone
- Update and install needed packages
- Deactivate DNSStubListener if needed

## Variables

Name | Default value | Description
-- | -- | --
base.vlan | `{}` | Set up and install VLANs.
base.vlan.enabled | `false` | Enable the installation and set up of VLANs.
base.vlan.vlans_definition | `""` | Network definition of VLANs
dns_53 | `""` | IP of a DNS server to use. Enable sytemd-resolved.
hosts_file | `[]` | List of hosts to add in the hosts file.
hosts_file[].names | `[]` | List of host names.
hosts_file[].ip | `""` | IP whom the host names refere to.
install_base_package | `false` | Sets what I consider basics in a general instance.
packages_list | `[]` | Packages to install.
sysctl_options | `[]` | Manage sysctl options.
sysctl_options[].name | `""` | Sysctl name.
sysctl_options[].state | `present` | State of the option. Could be `present` or `absent`.
sysctl_options[].value | `""` | Sysctl value.
timezone | `""` | Set a timezone for the instance. Example: `UTC`.
