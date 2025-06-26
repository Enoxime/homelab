
# pikvm_config

This role configure pikvm.

## Variables

Name | Default value | Description
-- | -- | --
pikvm.override | `{}` | Enable the override.yaml file configuration.
pikvm.override.gpio | `{}` | Enable the gpio section of override.yaml file configuration.
pikvm.override.gpio.drivers | `""` | Add drivers configuration. Currently only `"ezcoo"` option is supported.
pikvm.override.gpio.input | `[]` | List of input names.
pikvm.web.users | `[]` | List of names and passwords for the web application.
pikvm.web.users[].name | `""` | Name of the user.
pikvm.web.users.password | `""` | Password of the user.
pikvm.certificates | `[]` | List of CA certificate to add to the trust store.
pikvm.certificates[].name | `""` | Name with crt extension of the certificate. `"test.crt"`
pikvm.certificates[].url | `""` | Url to get the CA certificate. `"https://ca.com/roots.pem"`
pikvm.certificates[].validate_cert | `true` | Bool true by default. Validate the certificate of the url given.
pikvm.letsencrypt | `{}` | Set an automatic let's encrypt certificate for the web UI.
pikvm.letsencrypt.server | `""` | Optional. Define the ACME server.
pikvm.letsencrypt.domains | `[]` | List of domains to obtain a certificate.
