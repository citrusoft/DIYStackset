terraform {
  backend "s3" {
    bucket = "cscoe-terragrunt-spike-241689241215"
    key = "terraform"
    region = "us-west-2"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
}

locals {
  aws_region = var.aws_region
  ss_account_num = var.ss_account_num
}

provider "aws" {
  region = "${local.aws_region}"
}

provider "aws" {
  alias  = "target"
  region = "${local.aws_region}"
  assume_role {
    role_arn = "arn:aws:iam::${var.target_account_id}:role/IAMPipelineRole"
  }
}

resource "aws_iam_role" "cross_account_role" {
  provider = aws.target

  name = "stackset_cross_account_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "${local.ss_account_num}"
        }
      },
    ]
  })
}

variable "target_account_id" {
  type = string
  default = "241689241215" # "424304752381"
}

variable "ss_account_num" {
  type        = string
  description = "Shared services account number."
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
