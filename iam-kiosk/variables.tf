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

variable "target_account_id" {
  type = string
  # default = "241689241215" # "424304752381"
}

variable "ss_account_num" {
  type        = string
  description = "Shared services account number."
  default = "241689241215" # PGE-SharedServices-Dev
}

variable "saml_account_num" {
  type        = string
  description = "AWS-SAML Integration account number, mandatory"
  default = "241689241215" # PGE-SharedServices-Dev
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "aws_role" {
  description = "AWS role to assume"
  type        = string
  default     = "CloudAdmin"
}

variable "role_file_paths" {
  description = "paths to YAML specification of this federated-role."
  type        = list(string)
}

variable "user_file_paths" {
  description = "paths to YAML specification of this service-account."
  type        = list(string)
}


variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}

# variable "AppID" {
#   description = "Identify the application this asset belongs to by its AMPS APP ID.Format = APP-####"
#   type        = number
# }

# variable "Environment" {
#   type        = string
#   description = "The environment in which the resource is provisioned and used, such as Dev, Test, QA, Prod."
# }

# variable "DataClassification" {
#   type        = string
#   description = "Classification of data - can be made conditionally required based on Compliance.One of the following: Public, Internal, Confidential, Restricted, Privileged (only one)"
# }

# variable "Compliance" {
#   type        = list(string)
#   description = "Compliance	Identify assets with compliance requirements (SOX, HIPAA, etc.) Note: not adding NERC workloads to cloud"
# }

# variable "CRIS" {
#   type        = string
#   description = "Cyber Risk Impact Score High, Medium, Low (only one)"
# }

# variable "Notify" {
#   type        = list(string)
#   description = "Who to notify for system failure or maintenance. Should be a group or list of email addresses."
# }

# variable "Owner" {
#   type        = list(string)
#   description = "List three owners of the system, as defined by AMPS Director, Client Owner and IT Leadeg LANID1_LANID2_LANID3"
# }

# variable "optional_tags" {
#   description = "Optional_tags"
#   type        = map(string)
#   default     = {}
# }

