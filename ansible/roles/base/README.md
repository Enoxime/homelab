# base, ansible role for ubuntu base server

This role is used to setup the basics for an ubuntu server as:
- Set timezone (please, keep as much as you can in UTC by default as it is the most recommended)
- Update and install needed packages
- Deactivate DNSStubListener if needed

Configuration:
```yaml
timezone: "" # "UTC" is the recommended option
packages_list: [] # list of package names that you want installed
dns_53: "" # if present the default internal dns resolver will be deactivated and replaced by the dns server address in the dns_53 variable.
```