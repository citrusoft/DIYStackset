/*
 * # TFC Workspaces
 * Terraform module that provisions the workspaces
*/
#
#  Filename    : modules/workspaces/main.tf
#  Date        : 08 Feb 2022
#  Author      : Jacob Taunton (j2tw@pge.com)
#  Description : creates the workspace resources in TFC
#
# locals {
  # Only allowing execution mode for TFC agent, no remote or local.
  # default_execution_mode = "agent"
  # agent_pool_name        = "pge-tfc-agents"
  # We only have one runtask at this time so using local for prisma-cloud
  # runtask_id = "task-b1ZiP8kGxqfK91NW"
# }
# Get the agent pool id
# data "tfe_agent_pool" "pge-agent-pool" {
#   name         = local.agent_pool_name
#   organization = var.organization
# }

# Create the workspace
resource "tfe_workspace" "this" {
  name                  = var.name
  organization          = var.organization
  tag_names             = [for tag in var.tag_names : lower(tag)]

  project_id            = var.project_id
  auto_apply            = var.auto_apply
  # execution_mode        = local.default_execution_mode
  # agent_pool_id         = data.tfe_agent_pool.pge-agent-pool.id
  file_triggers_enabled = var.file_triggers_enabled
  queue_all_runs        = var.queue_all_runs
  ssh_key_id            = var.ssh_key_id
  terraform_version     = var.terraform_version
  trigger_prefixes      = var.trigger_prefixes
  working_directory     = var.working_directory
  assessments_enabled   = var.drift_detection
  speculative_enabled   = true
  vcs_repo {
    branch              = var.branch
    identifier          = var.identifier
    # ingress_submodules = var.ingress_submodules
    oauth_token_id      = var.oauth_token_id
  }
}

  # dynamic "vcs_repo" {
  #   for_each = [var.vcs_repo]
  #   content {
  #     branch             = var.vcs_repo.branch
  #     identifier         = var.vcs_repo.identifier
  #     ingress_submodules = var.vcs_repo.ingress_submodules
  #     oauth_token_id     = var.vcs_repo.oauth_token_id
  #   }
  # }
# Add the terraform variables to the workspace
# resource "tfe_variable" "tf_vars" {
#   for_each     = var.tf_vars
#   workspace_id = tfe_workspace.this.id
#   category     = "terraform"
#   key          = each.key
#   value        = each.value
# }
# Add the environment variables to the workspace
# resource "tfe_variable" "env_vars" {
#   for_each     = var.env_vars
#   workspace_id = tfe_workspace.this.id

#   category = "env"
#   key      = each.key
#   value = (each.key == "TF_CLI_ARGS_plan" ? (var.var_file == null ? each.value : join(" ", [each.value, "-var-file=\"${var.var_file}\""])) : each.key == "TF_CLI_ARGS_apply" ? var.parallelism == null ? each.value : join(" ", [each.value, "-parallelism=${var.parallelism}"]) : each.value)
# }

# Add the workspace id as environment variable
# resource "tfe_variable" "workspace_id" {
#   workspace_id = tfe_workspace.this.id
#   category     = "env"
#   key          = "TF_VAR_workspace_id"
#   value        = tfe_workspace.this.id
# }
# Add the workspace name as environment variable
# resource "tfe_variable" "workspace_name" {
#   workspace_id = tfe_workspace.this.id
#   category     = "env"
#   key          = "TF_VAR_workspace_name"
#   value        = tfe_workspace.this.name
# }

# Get the varset_id. Varset must already exist.
# data "tfe_variable_set" "this" {
#   name         = var.varset
#   organization = var.organization
# }
# Attach varset to workspace
# resource "tfe_workspace_variable_set" "attach_varset" {
#   variable_set_id = data.tfe_variable_set.this.id
#   workspace_id    = tfe_workspace.this.id
# }
# Attach policy set to workspace
# data "tfe_policy_set" "this" {
#   name         = "${var.policy_env}-policy-set"
#   organization = var.organization
# }
# resource "tfe_workspace_policy_set" "this" {
#   policy_set_id = data.tfe_policy_set.this.id
#   workspace_id  = tfe_workspace.this.id
# }
# # Python is no longer required to attach varset to workspace
# # Use Python to attach existing varsets to workspaces
# resource "null_resource" "add-varset" {
#   triggers = { update_varset = var.varset }
#   provisioner "local-exec" {
#     command = <<-EOT
#     pip install requests
#     python3 ${path.module}/add_varset.py -w ${tfe_workspace.this.id} -v ${data.tfe_variable_set.this.id} -t ${var.tfe_token}
#     EOT
#   }
# }
## This is defective at the moment. Cannot add runtask to workspace from tfc only Prisma.
# Use Python to attach existing runtask to workspaces
# resource "null_resource" "add-runtask" {
#   provisioner "local-exec" {
#     command = "python3 ${path.module}/add_runtask.py -w ${tfe_workspace.this.id} -r ${local.runtask_id} -t ${var.tfe_token}"
#   }
# }