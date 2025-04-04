
# certificate_authority_server

Role that install and setup step-ca with an optional noise generator key and
optional yubikey. Strongly inspired by
[Build a Tiny Certificate Authority For Your Homelab](https://smallstep.com/blog/build-a-tiny-ca-with-raspberry-pi-yubikey/).

To know more about the yubikey part of the role, please, read the
[yubikey.yaml](./tasks/yubikey.yaml) file.

## Variables

Name | Default value | Description
-- | -- | --
cas_root_key_password | `""` | **secret!** Root CA password key. This variable shoud be passed as a secret.
certificate_authority_server_temporary_folder_path | `/tmp/cas` | Temporary folder path.
cas_yubikey.management_key | `""` | **secret!** Yubikey's management key. This variable should be passed as a secret.
cas_yubikey.pin | `""` | **secret!** Yubikey's pin code. This variable shoud be passed as a secret.
cas.config.authority | `{}` | Authority configuration. See [step-ca documentation](https://smallstep.com/docs/step-ca/configuration/#example-configuration) and example below.
cas.mount.fstype | `ext4` | Filesystem type of the USB key that will hold the configurations.
cas.mount.path | `/mnt` | Path where to mount the USB key.
cas.mount.src | `""` | Path of the device block. Could also be a label as `LABEL=usbkey`.
cas.root_ca.dns | `""` | To which dns the application answers to? An example would be `192.168.0.2` or `ca.example.com` or both!
cas.root_ca.listen | `:443` | In which IP:PORT to listen to.
cas.root_ca.name | `""` | Name of the root certificate.
cas.root_ca.provisioner | `""` | Who provision the service ? Could be any email like `admin@example.com`.
cas.trng.enabled | `false` | Set trng. A noise generator on a usb stick. See [Infinite Noise TRNG](https://github.com/leetronics/infnoise)
cas.yubikey.enabled | `false` | Define whether the setup include a yubikey sets.
cas.yubikey.intermediate.slot | `""` | Slot ID where the certificate is on the yubikey.
cas.yubikey.product_id | `407` | Udev product id of the yubikey.

```yaml
cas:
  config:
    authority:
      claims:
        # 3 months
        maxTLSCertDuration: 2160h
      policy:
        x509:
          # Allow to serve certificates from this domain only
          allow:
            dns:
              - "*.example.com"
```
