# Terraform workspace automation using module.  
The module is in the root directory and calls submodules.  
To use this module refer to the /examples folder.  
YAML files in the config folder will be used to create the workspaces. 

Example YAML file.

```
---
---
workspaces:
  svc1:
    read_only_ad_group: AWS-A2102-All-CloudAdmin
    apply_ad_group: AWS-A2102-All-SuperAdmin
    github_repo: test-tfc-demo
    tags: ["tfc","iac","app-3113"]
    environment:
      dev:
        account: 056672152820
        branch: Dev
        tf_vars:
          tf_var1: tf_value1
        env_vars:
          env_var1: evn_var1
```

YAML files should be stored in workspaces directory for pge-tfc-workspaces repo.

<!-- BEGIN_TF_DOCS -->
# TFC Workspace Automation
Terraform module that reads the YAML files for the projects and calls submodule to create workspaces.

Source can be found at https://github.com/pgetech/pge-terraform-modules

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | = 0.37.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | = 0.37.0 |

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
| <a name="module_workspaces"></a> [workspaces](#module\_workspaces) | ./modules/workspaces | n/a |

## Resources

| Name | Type |
|------|------|
| [tfe_team.this](https://registry.terraform.io/providers/hashicorp/tfe/0.37.0/docs/resources/team) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_config_auto_apply"></a> [config\_auto\_apply](#input\_config\_auto\_apply) | Controls Terraform Cloud workspace auto-apply feature | `bool` | `true` | no |
| <a name="input_config_file_path"></a> [config\_file\_path](#input\_config\_file\_path) | Relative path to YAML config files | `string` | `null` | no |
| <a name="input_config_file_pattern"></a> [config\_file\_pattern](#input\_config\_file\_pattern) | File pattern used to locate configuration files | `string` | `"APP-{[0-9],[0-9][0-9],[0-9][0-9][0-9],[0-9][0-9][0-9][0-9],[0-9][0-9][0-9][0-9][0-9],[0-9][0-9][0-9][0-9][0-9][0-9]}.yaml"` | no |
| <a name="input_oauth_token_id"></a> [oauth\_token\_id](#input\_oauth\_token\_id) | Token ID of the VCS Connection (OAuth Connection Token) to use. | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | Name of the organization. | `string` | n/a | yes |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | The version of Terraform to use for this workspace. Defaults to the latest available version. | `string` | `null` | no |
| <a name="input_vcs_repo"></a> [vcs\_repo](#input\_vcs\_repo) | The VCS repository to configure. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workspace"></a> [workspace](#output\_workspace) | results from the module to create workspaces |


<!-- END_TF_DOCS -->