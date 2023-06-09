/*
 * # CSCOE IAM kiosk
 * Terraform root-module which creates SAF2.0 compliant IAM resources:
 *  federated-roles = SAML Role + Partner Role + Policies
 *  service-accounts = User + Policies + Access Key
*/
#
# Filename    : cscoe-iam-kiosk
# Date        : Mar 16, 2023
# Author      : Tommy Hunt (tahv@pge.com)
# Description : iam users, roles creation with policies from yaml files
#
terraform {
  # required_version = ">= 1.4.0" # terraform://version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "${local.aws_region}"
}

provider "aws" {
  alias  = "partner"
  region = "${local.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.target_account_id}:role/${var.aws_role}"
  }
}

provider "aws" {
  alias   = "saml"
  assume_role {
    role_arn = "arn:aws:iam::${var.saml_account_num}:role/${var.aws_role}"
  }
  region = var.aws_region
}


data "aws_caller_identity" "saml" {
  provider = aws.saml
}

data "aws_caller_identity" "partner" {
  provider = aws.partner
}


locals {
  AppID              = var.AppID
  Environment        = var.Environment
  DataClassification = var.DataClassification
  CRIS               = var.CRIS
  Notify             = var.Notify
  Owner              = var.Owner
  Compliance         = var.Compliance
  optional_tags      = var.optional_tags
  aws_region        = var.aws_region
  ss_account_num    = var.ss_account_num
  target_account_id = var.target_account_id

  ### Read, Parse & Encode Role specification
  role_specs = [ for filename in var.role_file_paths: {
    key              = filename
    role_yaml_map    = yamldecode(file(filename))
  }]
  role_specifications = { for rspec in local.role_specs : rspec.key => rspec.role_yaml_map}

  ###### Read, Parse & Encode User specification
  user_specs = [ for filename in var.user_file_paths: {
    key              = filename
    user_yaml_map    = yamldecode(file(filename))
  }]
  user_specifications = { for uspec in local.user_specs : uspec.key => uspec.user_yaml_map}
}

#################################
# FEDERATED ROLES Specification
# PARTNER & SAML Role Creation
#################################
module "federated_roles" {
  source = "./modules/federated-roles"
  providers = {
    aws.partner = aws.partner
    aws.saml = aws.saml
   }

  for_each          = local.role_specifications
  account_num       = regex("[0-9]{12}", each.key)  # parse AWS acct #
  name              = each.value["Name"]
  managed_policies  = lookup(each.value, "ManagedPolicyArns", [])
  inline_policies   = lookup(each.value, "Statement", null) != null ? (
                    [ jsonencode({ "Version" : "2012-10-17", "Statement" : each.value["Statement"] })]
                    ) : ( [] )
  # tags              = merge(module.tags.tags, local.optional_tags)
}

###################################
# SERVICE ACCOUNT Specification
# Create managed policy and user
###################################
module "service_accounts" {
  source = "./modules/service-accounts"
  providers = {
    aws.partner = aws.partner
  }

  for_each          = local.user_specifications
  account_num       = local.target_account_id
  name              = each.value["Name"]
  managed_policies  = lookup(each.value, "ManagedPolicyArns", [])
  inline_policies   = lookup(each.value, "Statement", null) != null ? (
                    [ jsonencode({ "Version" : "2012-10-17", "Statement" : each.value["Statement"] })]
                    ) : ( [] )
  # tags       = merge(module.tags.tags, local.optional_tags)
}

# module "tags" {
#   source             = "app.terraform.io/pgetech/tags/aws"

#   AppID              = local.AppID
#   Environment        = local.Environment
#   DataClassification = local.DataClassification
#   CRIS               = local.CRIS
#   Notify             = local.Notify
#   Owner              = local.Owner
#   Compliance         = local.Compliance

# }
