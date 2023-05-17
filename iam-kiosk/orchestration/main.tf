/*
 * # CSCOE IAM Workspace Automation
 * Creates a TFC workspace per account.
 * Each workspace encapsulates the iam roles, policies, users
*/
#
#  Filename    : modules/workspaces/main.tf
#  Date        : 28 Apr 2023
#  Author      : Tommy Hunt (tahv@pge.com)
#  Description : Simply creates a workspace named with AWS account number.
#                configures github repo and auto-apply.
#


provider "tfe" {
  hostname = var.tfe_hostname
  organization = var.organization
}

data "tfe_organization" "citrusoft" {
  name = var.organization
}

data "tfe_project" "iam-kiosk" {
  organization = data.tfe_organization.citrusoft.name
  name = var.project_name
}

locals {
  # Use the provided config file path or default to the current dir

  resource_files = fileset("${var.resource_path}", "*/*/*.yaml")

  # TODO make a set of AWS accts to prevent duplicates #
  account_set = toset([ 
    for filename in local.resource_files:
      regex("[0-9]{12}", filename)
  ])

  # flatten yaml data for resource creation
  lws = [
    for account in local.account_set: {
      key                = account
      account            = account
      branch             = "tfe-workspaces" # vars.branch
      queue_all_runs     = true
      auto_apply         = true
      working_directory  = "iam-kiosk/pipeline"
      varset             = "${account}-vars"
      github_org         = var.github_org
      github_repo        = var.github_repo
      trigger_patterns   = [ "${var.resource_folder}/${account}/**/*", "iam-kiosk/pipeline/**/*" ]
      ws_tags            = [ "ccoe", "cscoe", "iam-kiosk" ] # lookup(ws_val, "tags", [])
      terraform_version  = var.terraform_version
      drift_detection    = var.drift_detection
    }
  ]
  # local used to create workspaces, flattened workspaces.
  workspaces = { for ws in local.lws : ws.key => ws }
}


# Module used to create the workspace, add workspace variables, and teams access.
module "workspaces" {
  source            = "./modules/workspaces"
  for_each          = local.workspaces
  name              = each.key
  organization      = data.tfe_organization.citrusoft.name
  project_id        = data.tfe_project.iam-kiosk.id
  queue_all_runs    = each.value.queue_all_runs
  auto_apply        = each.value.auto_apply
  working_directory = each.value.working_directory
  varset            = each.value.varset
  tag_names         = each.value.ws_tags
  terraform_version = each.value.terraform_version
  drift_detection   = each.value.drift_detection
  trigger_patterns  = each.value.trigger_patterns
  # env_vars          = merge(each.value.env_vars, contains(keys(each.value.env_vars), "TF_CLI_ARGS_plan") ? {} : each.value.var_file != null ? tomap({ TF_CLI_ARGS_plan = "" }) : {}, contains(keys(each.value.env_vars), "TF_CLI_ARGS_apply") ? {} : each.value.parallelism != null ? tomap({ TF_CLI_ARGS_apply = "" }) : {})
  identifier        = "${var.github_org}/${var.github_repo}" #"${each.value.github_org}/${each.value.github_repo}"
  oauth_token_id    = var.oauth_token_id
  branch            = var.branch
  # ingress_submodules = false # try(each.value.ingress_submodules, false)
}

# resource "null_resource" "list-files" {

#   provisioner "local-exec" {
#     command = <<-EOT
#     find . -type f -print
#     EOT
#   }
# }
