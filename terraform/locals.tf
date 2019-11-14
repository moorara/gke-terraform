# https://www.terraform.io/docs/configuration/locals.html

locals {
  name      = format("gke-%s", var.environment)
  subdomain = format("k8s.%s.%s", var.environment, var.domain)

  # A map of common labels for every resource
  common_labels = {
    environment = var.environment
    uuid        = var.uuid
    owner       = var.owner
    git_url     = var.git_url
    git_branch  = var.git_branch
    git_commit  = var.git_commit
  }

  # A map of region label for regional resources
  region_label = {
    region = var.region
  }

  # A map of zone label for zonal resources
  zone_label = {
    zone = var.zone
  }

  # A list of common tags for every resource
  common_tags = [
    var.environment,
    var.uuid,
    var.owner,
    var.git_commit,
  ]

  # A list of region tag for regional resources
  region_tag = [
    var.region
  ]

  # A list of zone tag for zonal resources
  zone_tag = [
    var.zone
  ]
}
