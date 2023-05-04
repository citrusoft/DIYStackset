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

#Schema Validator Validation
data "jsonschema_validator" "values" {
  for_each = local.config_filenames
  document = jsonencode(yamldecode(file("${local.config_file_path}/${each.key}")))
  schema   = file("schema.json")
}

#YAML Lint Validation
data "external" "yamllint" {
  for_each = local.config_filenames
  program  = ["bash", "${path.cwd}/${var.yamllint_validation_filename}"]
  query = {
    file = "${local.config_file_path}/${each.key}"
  }
}

module "workspaces" {
  source           = "../"
  config_file_path = var.config_file_path
  organization     = var.organization
  oauth_token_id   = var.oauth_token_id
}

# Use Python to attach update teams access by triggering workspace
resource "null_resource" "add_teams_access" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<-EOT
    pip install requests
    python3 add_teams_access.py
    EOT
  }
  depends_on = [
    module.workspaces
  ]
}
