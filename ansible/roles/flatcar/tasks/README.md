
# flatcar

Generate Butane file from a given template then generate an Ingition file from
it.

## Variables

Name | Default value | Description
-- | -- | --
flatcar.butane_list | `[]` | List of Butane templates.
flatcar.butane_list[].name | `""` | Name of the Butane template. Example: *NAME*.butane.yaml.jinja
flatcar.butane_list[].path | `""` | Path to the Butane template folder.
