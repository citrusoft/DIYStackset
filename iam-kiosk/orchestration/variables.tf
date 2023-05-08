variable "config_auto_apply" {
  type        = bool
  description = "Controls Terraform Cloud workspace auto-apply feature"
  default     = true
}

variable "terraform_version" {
  type        = string
  description = "The version of Terraform to use for this workspace. Defaults to the latest available version."
  default     = null
}

variable "github_org" {
  description = "Name of the github organization."
  type        = string
  default     = "citrusoft"
}

variable "github_repo" {
  description = "Name of the github repository."
  type        = string
  default     = "DIYStackset"
}

variable "github_base_folder" {
  description = "Relative path to folder of account dirs."
  type        = string
  default     = "iam-kiosk/orchestration/test/resources/"
}

variable "branch" {
  description = "Branch name."
  type        = string
  default = "tfe-workspaces"
}

variable "oauth_token_id" {
  description = "Token ID of the VCS Connection (OAuth Connection Token) to use."
  type        = string
}

variable "tfe_hostname" {
  description = "The Terraform Enterprise hostname to connect to. Defaults to `app.terraform.io`. Can be overridden by setting the `TFE_HOSTNAME` environment variable."
  default     = "app.terraform.io"
  type        = string
}

variable "organization" {
  description = "Name of the organization."
  type        = string
  default     = "citrusoft"
}

variable "project_name" {
  description = "Name of the project."
  type        = string
  default     = "iam-kiosk"
}

variable "root_workspace" {
  description = "Root of all the workspaces."
  type        = string
  default     = "orchestration"
}

variable "account_file_path" {
  description = "paths to YAML specification of this federated-role."
  type        = string
  default     = "./test/resources/"
}

variable "yamllint_validation_filename" {
  type        = string
  description = "File name used for YAMLLint validation"
  default     = "workspace-validation.sh"
}
