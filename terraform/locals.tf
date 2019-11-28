# https://www.terraform.io/docs/configuration/locals.html

locals {
  name = format("gke-%s", var.environment)

  # A map of common labels for every resource
  common_labels = {
    environment = var.environment
    uuid        = var.uuid
    owner       = var.owner
    git_branch  = var.git_branch
    git_commit  = var.git_commit
  }

  # A map of region label for regional resources
  region_label = {
    region = var.region
  }

  # A list of common tags for every resource
  common_tags = [
    var.environment,
    var.owner,
  ]

  # A list of region tag for regional resources
  region_tag = [
    var.region
  ]
}
