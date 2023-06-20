/*
 * # CSCOE IAM kiosk
 * Terraform submodule which creates SAF2.0 compliant roles and policies.
*/
#
# Filename    : cscoe-iam-kiosk/modules/federated-roles
# Date        : Mar 16, 2023
# Author      : Tommy Hunt (tahv@pge.com)
# Description : iam partner-roles creation with policies from yaml files.
#

terraform {
  # required_version = ">= 1.4" # terraform://version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
      configuration_aliases = [ aws.partner ]
    }
  }
}

# data "aws_caller_identity" "saml" {
#   provider = aws.saml
# }

data "aws_caller_identity" "partner" {
  provider = aws.partner
}

###############
# PARTNER ROLE
###############
data "aws_iam_policy_document" "trust_saml2assume_partner_role" {
  provider = aws.partner
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.auth_account_num}:root"]
      # identifiers = ["arn:aws:iam::${data.aws_caller_identity.saml.account_id}:root"]
    }
  }
}

#################################################
# Partner-Role, simple due to optional policies.
#################################################
resource "aws_iam_role" "partner_role" {
  provider = aws.partner

  name                       = var.name
  path                       = var.path
  description                = var.description
  assume_role_policy = data.aws_iam_policy_document.trust_saml2assume_partner_role.json

  force_detach_policies      = var.force_detach_policies
  max_session_duration       = var.max_session_duration
  tags     = merge(merge(var.tags, var.optional_tags), {
                workspace = "ccoe-iam-${var.account_num}"
              })
}

#######################################
# Create Inline policy(s) for the role
#######################################
resource "aws_iam_role_policy" "partner_inline_policy" {
  provider = aws.partner

  count  = length(var.inline_policies)
  name   = "${var.name}-Inline-${count.index + 1}"
  policy = element(var.inline_policies, count.index)
  role   = aws_iam_role.partner_role.id
}

###########################################
# Attach Managed policy(s) to Partner role
###########################################
resource "aws_iam_role_policy_attachment" "partner_managed_policy" {
  provider = aws.partner

  count      = length(var.managed_policies)
  role       = aws_iam_role.partner_role.name
  policy_arn = element(var.managed_policies, count.index)
}
