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

variable "account_num" {
  type        = string
  description = "User's account number."
}

variable "name" {
  description = "Unique name for the user"
  type        = string
  default     = null
}

variable "path" {
  description = "Path of IAM user"
  type        = string
  default     = ""
}

variable "description" {
  description = "Describe user here."
  type        = string
  default     = ""
}

variable "inline_policies" {
  description = "A string of json."
  type        = list(string)
  default     = []
}

variable "managed_policies" {
  description = "ARNs of IAM policies"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "tags"
  type        = map(string)
  default     = {}
}

variable "optional_tags" {
  description = "Optional_tags"
  type        = map(string)
  default     = {}
}
