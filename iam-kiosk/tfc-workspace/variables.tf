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

variable "vcs_repo" {
  type        = map(string)
  description = "The VCS repository to configure."
  default     = {}
}

variable "tfe_hostname" {
  description = "The Terraform Enterprise hostname to connect to. Defaults to `app.terraform.io`. Can be overridden by setting the `TFE_HOSTNAME` environment variable."
  default     = "app.terraform.io"
  type        = string
}

variable "oauth_token_id" {
  default     = "ot-YF3Y8nWd2uU8MJpR" # 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
  description = "Token ID of the VCS Connection (OAuth Connection Token) to use."
  type        = string
}

variable "organization" {
  description = "Name of the organization."
  type        = string
  default     = "citrusoft"
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
