
# flatcar

Generate Butane file from a given template then generate an Ingition file from
it.

## Variables

Name | Default value | Description
-- | -- | --
flatcar | `[]` | Butane template definition.
flatcar[].name | `""` | Name of the Butane template. Example: *NAME*.butane.yaml.jinja
flatcar[].path | `""` | Path to the Butane template folder.
