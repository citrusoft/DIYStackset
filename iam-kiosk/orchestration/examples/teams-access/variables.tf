variable "tfe_hostname" {
  description = "The Terraform Enterprise hostname to connect to. Defaults to `app.terraform.io`. Can be overridden by setting the `TFE_HOSTNAME` environment variable."
  default     = "app.terraform.io"
  type        = string
}

variable "organization" {
  description = "Name of the organization."
  type        = string
  default     = "pgetech"
}

variable "config_file_path" {
  description = "path where the yaml files are stored"
  default     = "../workspaces"
  type        = string
}

variable "config_file_pattern" {
  type        = string
  description = "File pattern used to locate configuration files"
  default     = "APP-{[0-9],[0-9][0-9],[0-9][0-9][0-9],[0-9][0-9][0-9][0-9],[0-9][0-9][0-9][0-9][0-9],[0-9][0-9][0-9][0-9][0-9][0-9]}.yaml"
}

variable "yamllint_validation_filename" {
  type        = string
  description = "File name used for YAMLLint validation"
  default     = "workspace-validation.sh"
}
