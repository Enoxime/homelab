
# directories_files

Create directories and files

## Variables

Name | Default value | Description
-- | -- | --
directories_files.directories | `[]` | List of directories to create.
directories_files.directories[].path | `""` | Path where the directory should be created.
directories_files.directories[].mode | `755` | The permission of the directory.
directories_files.directories[].owner | `"root"` | The directory owner.
directories_files.directories[].group | `"root"` | The directory group.
directories_files.files | `[]` | List of files to copy to the remote.
directories_files.files[].path | `""` | Path where the file should be created.
directories_files.files[].mode | `755` | The permission of the file.
directories_files.files[].owner | `"root"` | The file owner.
directories_files.files[].group | `"root"` | The file group.
directories_files.contents | `[]` | List of files to create from contents.
directories_files.contents[].dest | `""` | Path where the file should be created.
directories_files.contents[].mode | `755` | The permission of the file.
directories_files.contents[].owner | `"root"` | The file owner.
directories_files.contents[].group | `"root"` | The file group.
directories_files.contents[].content | `""` | The file content.
