# Configure the Terraform Enterprise Provider
# TFE Provider is for both Terraform Cloud and Enterprise.
provider "tfe" {
  hostname = var.tfe_hostname
}

locals {
  # Use the provided config file path or default to the current dir
  config_file_path = coalesce(var.config_file_path, path.cwd)
  # Result ex: [mrad.yaml,ecm.yaml,sbd.yaml, ...]
  config_filenames = fileset(local.config_file_path, var.config_file_pattern)
}

module "teams-access" {
  source           = "../../../tfc-team-access"
  organization     = var.organization
  config_file_path = var.config_file_path
}
