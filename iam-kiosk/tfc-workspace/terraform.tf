terraform {
  cloud {
    organization = "citrusoft"

    workspaces {
      name = "infrastructure"
    }
  }
}
