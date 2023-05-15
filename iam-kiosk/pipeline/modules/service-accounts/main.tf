/*
 * # CSCOE IAM kiosk
 * Terraform module which creates SAF2.0 IAM User, aka service-account, in AWS.
*/
#
# Filename    : cscoe-iam-kiosk/modules/service-accounts
# Date        : Mar 16, 2023
# Author      : Tommy Hunt (tahv@pge.com)
# Description : Creates IAM users and their policies.
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

########################################################
# IAM user without pgp_key, login profiles, access keys 
########################################################
resource "aws_iam_user" "service_account" {
  provider = aws.partner
  # name     = "SVC-A${trimprefix(var.tags["AppID"], "APP-")}-${var.tags["Environment"]}-${var.name}"
  name     = startswith("${var.name}", "SVC-") ? "${var.name}" : "SVC-${var.name}"
  tags     = merge(var.tags, var.optional_tags)
}

#######################################
# Create Inline policy(s) for the user
#######################################
resource "aws_iam_user_policy" "user_policy" {
  provider = aws.partner
  count    = length(var.inline_policies)
  name     = "${var.name}-Inline-${count.index + 1}"
  policy   = element(var.inline_policies, count.index)
  user     = aws_iam_user.service_account.name
}

#####################################
# Attach Managed policy(s) to user
#####################################
resource "aws_iam_user_policy_attachment" "attach_managed_policy" {
  provider   = aws.partner
  count      = length(var.managed_policies)
  user       = aws_iam_user.service_account.name
  policy_arn = element(var.managed_policies, count.index)
}
