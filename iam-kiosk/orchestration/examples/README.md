<!-- BEGIN_TF_DOCS -->


Source can be found at https://github.com/pgetech/pge-terraform-modules

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_jsonschema"></a> [jsonschema](#requirement\_jsonschema) | 0.1.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >= 0.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.2.2 |
| <a name="provider_jsonschema"></a> [jsonschema](#provider\_jsonschema) | 0.1.0 |

## Usage

Usage information can be found in `modules/examples/*`

`cd pge-terraform-modules/modules/examples/*`

`terraform init`

`terraform validate`

`terraform plan`

`terraform apply`

Run `terraform destroy` when you don't need these resources.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_teams-access"></a> [teams-access](#module\_teams-access) | ../../tfc-team-access | n/a |
| <a name="module_workspaces"></a> [workspaces](#module\_workspaces) | ../ | n/a |

## Resources

| Name | Type |
|------|------|
| [external_external.yamllint](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [jsonschema_validator.values](https://registry.terraform.io/providers/xxxbobrxxx/jsonschema/0.1.0/docs/data-sources/validator) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_file_path"></a> [config\_file\_path](#input\_config\_file\_path) | path where the yaml files are stored | `string` | `"workspaces"` | no |
| <a name="input_config_file_pattern"></a> [config\_file\_pattern](#input\_config\_file\_pattern) | File pattern used to locate configuration files | `string` | `"APP-{[0-9],[0-9][0-9],[0-9][0-9][0-9],[0-9][0-9][0-9][0-9],[0-9][0-9][0-9][0-9][0-9],[0-9][0-9][0-9][0-9][0-9][0-9]}.yaml"` | no |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | Token ID of the VCS Connection (OAuth Connection Token) to use. | `string` | `"123456"` | no |
| <a name="input_organization"></a> [organization](#input\_organization) | Name of the organization. | `string` | `"pgetech"` | no |
| <a name="input_tfe_hostname"></a> [tfe\_hostname](#input\_tfe\_hostname) | The Terraform Enterprise hostname to connect to. Defaults to `app.terraform.io`. Can be overridden by setting the `TFE_HOSTNAME` environment variable. | `string` | `"app.terraform.io"` | no |
| <a name="input_yamllint_validation_filename"></a> [yamllint\_validation\_filename](#input\_yamllint\_validation\_filename) | File name used for YAMLLint validation | `string` | `"workspace-validation.sh"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspaces"></a> [workspaces](#output\_workspaces) | A list of project workspaces & their configurations. |


<!-- END_TF_DOCS -->