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


# resource "tfe_project" "iam-kiosk" {
#   organization = tfe_organization.citrusoft.name
#   name = "iam-kiosk"
# }

provider "tfe" {
  hostname = var.tfe_hostname
  organization = var.organization
}

# data "tfe_organization" "citrusoft" {
#   name = var.organization
# }

# resource "tfe_organization" "citrusoft" {
#   name  = var.organization
#   email = "thunt@citrusoft.org"
# }

locals {
  # Use the provided config file path or default to the current dir

  resource_files = fileset(var.account_file_path, "*/*/*.yaml")

  # TODO make a set of AWS accts to prevent duplicates #
  account_set = toset([ 
    for filename in local.resource_files:
      regex("[0-9]{12}", filename)
  ])

  # flatten yaml data for resource creation
  lws = flatten([
    for account in local.account_set: {
      key                = account
      account            = account # vars.account
      branch             = "tfe-workspaces" # vars.branch
      environment        = "tfc-dev"
      policy_env         = account
      queue_all_runs     = true
      auto_apply         = true
      working_directory  = null
      tf_vars            = {}
      env_vars           = {}
      var_file           = null
      parallelism        = null
      varset             = "AWSAccessKeys"
      github_org         = "citrusoft" #lookup(ws_val, "github_org", "citrusoft")
      github_repo        = "DIYStackset" # ws_val.github_repo
      # read_only_ad_group = ws_val.read_only_ad_group
      # apply_ad_group     = ws_val.apply_ad_group
      tags               = [ ] # lookup(ws_val, "tags", [])
      terraform_version  = "1.3.6" # lookup(ws_val, "terraform_version", "1.3.6")
      drift_detection    = false # lookup(ws_val, "drift_detection", false)
    }
  ])
  # local used to create workspaces, flattened workspaces.
  workspaces = { for ws in local.lws : ws.key => ws }
  # Makes a unique set of AD groups
  # teams = toset(concat(local.lws[*].read_only_ad_group, local.lws[*].apply_ad_group))
}


# Module used to create the workspace, add workspace variables, and teams access.
module "workspaces" {
  source            = "./modules/workspaces"
  for_each          = local.workspaces
  name              = each.key
  organization      = var.organization
  queue_all_runs    = each.value.queue_all_runs
  auto_apply        = each.value.auto_apply
  working_directory = each.value.working_directory
  tf_vars           = each.value.tf_vars
  varset            = each.value.varset
  var_file          = each.value.var_file
  parallelism       = each.value.parallelism
  tag_names         = [ "environment" ]
  policy_env        = each.value.policy_env
  terraform_version = each.value.terraform_version
  drift_detection   = each.value.drift_detection
  # tag_names         = setunion(each.value.tags, [each.value.environment])
  # env_vars          = merge(each.value.env_vars, contains(keys(each.value.env_vars), "TF_CLI_ARGS_plan") ? {} : each.value.var_file != null ? tomap({ TF_CLI_ARGS_plan = "" }) : {}, contains(keys(each.value.env_vars), "TF_CLI_ARGS_apply") ? {} : each.value.parallelism != null ? tomap({ TF_CLI_ARGS_apply = "" }) : {})
  # vcs_repo = {
  #   branch             = each.value.branch
  #   identifier         = "${each.value.github_org}/${each.value.github_repo}"
  #   ingress_submodules = try(each.value.ingress_submodules, false)
  #   oauth_token_id     = var.oauth_token_id
  # }
}

# resource "null_resource" "list-files" {

#   provisioner "local-exec" {
#     command = <<-EOT
#     find . -type f -print
#     EOT
#   }
# }
