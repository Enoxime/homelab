
# user_group

A role that manage users and groups.

## Variables

Name | Default value | Description
-- | -- | --
user_group.groups | `[]` | Group name to create.
user_group.sudo | `[]` | Add sudo configuration per users.
user_group.sudo[].as | `""` | If set, will run sudo as the mentionned user.
user_group.sudo[].cmd | `[]` | List of command authorized to run with sudo. Will set to ALL if not specified.
user_group.sudo[].name | `""` | Name of the sudo user.
user_group.sudo[].nopasswd | `false` | If set to true, the user will not be prompted for a password.
user_group.users | `[]` | List of user objects.
user_group.users[].create_home | `false` | Whether to create a home directory or not.
user_group.users[].group | `""` | Main user group name.
user_group.users[].groups | `[]` | List of other group names in which the user should be part of.
user_group.users[].name | `""` | Mandatory. User name.
user_group.users[].import_key.path | `""` | Local path of the private ssh key to import.
user_group.users[].key | `""` | Import public ssh key.
user_group.users[].password | `""` | User password. Will be hashed.
user_group.users[].shell | `/bin/bash` | Default user shell.
