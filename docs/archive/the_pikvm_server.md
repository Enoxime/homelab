# The pikvm server

There is only two steps here. The first one is to Install the pivkm image with
some custom configuration inside the SD card. The second is to set up the server
with the configuration needed.

## Pikvm: Install pikvm in a SD card

```bash
ansible-playbook \
  --vault-password-file=/PATH_TO_SECRET_FILE/secret \
  --extra-vars=@/PATH_TO_VARIABLES_FILE/variables.yaml \
  --inventory hosts.yaml \
  --tags setup_pikvm \
  prepare_infra.yaml
```

## Pikvm: Configure pikvm

```bash
ansible-playbook \
  --vault-password-file=/PATH_TO_SECRET_FILE/secret \
  --extra-vars=@/PATH_TO_VARIABLES_FILE/variables.yaml \
  --inventory hosts.yaml \
  --limit pikvm \
  setup.yaml
```
