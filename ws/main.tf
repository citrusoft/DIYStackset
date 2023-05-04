
provider "tfe" {
  hostname = var.tfe_hostname
  organization = var.organization
  token = var.token
}

resource "tfe_workspace" "test" {
  name         = "my-workspace-name"
  organization = var.organization
  tag_names    = ["test", "app"]
}

variable "tfe_hostname" {
  description = "The Terraform Enterprise hostname to connect to. Defaults to `app.terraform.io`. Can be overridden by setting the `TFE_HOSTNAME` environment variable."
  default     = "app.terraform.io"
  type        = string
}

variable "organization" {
  description = "Name of the organization."
  type        = string
  default     = "citrusoft"
}

variable "token" {
  description = "API token for this organization."
  type        = string
  default     = "gBVSMR2dzCjIfg.atlasv1.SkxdOWjuJCMZPdZeDLJmbqwED1Yn8voqsdAbhR5NrharZdkvr0EsAWhXEvsrdApl9gg"
}

