# https://www.terraform.io/docs/configuration/terraform.html
# https://www.terraform.io/docs/backends/index.html
# https://www.terraform.io/docs/backends/types/gcs.html
terraform {
  # Equivalent to ">= 0.12, < 1.0"
  required_version = "~> 1.0"
  backend "gcs" {}
}

# ================================================================================
#  Providers
# ================================================================================

# https://www.terraform.io/docs/providers/google
# https://www.terraform.io/docs/providers/google/guides/provider_reference.html
# https://www.terraform.io/docs/providers/google/guides/provider_versions.html
# https://www.terraform.io/docs/configuration/providers.html#provider-versions
# https://www.terraform.io/docs/configuration/terraform.html
provider "google" {
  # Equivalent to ">= 3.9.0, < 4.0.0"
  version     = "~> 3.9"
  credentials = file("account.json")
  project     = var.project
  region      = var.region
}

# https://www.terraform.io/docs/providers/google
# https://www.terraform.io/docs/providers/google/guides/provider_reference.html
# https://www.terraform.io/docs/providers/google/guides/provider_versions.html
# https://www.terraform.io/docs/configuration/providers.html#provider-versions
# https://www.terraform.io/docs/configuration/terraform.html
provider "google-beta" {
  # Equivalent to ">= 3.9.0, < 4.0.0"
  version     = "~> 3.9"
  credentials = file("account.json")
  project     = var.project
  region      = var.region
}

# ================================================================================
#  Modules
# ================================================================================

module "network" {
  source = "../modules/network"

  name    = local.name
  project = var.project
  region  = var.region
}

module "firewall" {
  source = "../modules/firewall"

  name               = local.name
  project            = var.project
  network            = module.network.network
  subnetwork_private = module.network.private_subnetwork
  subnetwork_public  = module.network.public_subnetwork
}

module "service_account" {
  source = "../modules/service-account"

  name    = local.name
  project = var.project
}

module "cluster" {
  source = "../modules/cluster"

  name            = local.name
  project         = var.project
  region          = var.region
  network         = module.network.network
  subnetwork      = module.network.public_subnetwork
  service_account = module.service_account.email
  common_labels   = local.common_labels
  region_label    = local.region_label
  common_tags     = local.common_tags
  region_tag      = local.region_tag
}

# ================================================================================
#  Configuring kubectl
# ================================================================================

# Configure kubectl
# https://www.terraform.io/docs/provisioners/null_resource.html
# https://www.terraform.io/docs/provisioners/index.html
# https://www.terraform.io/docs/provisioners/local-exec.html
resource "null_resource" "configure_kubectl" {
  depends_on = [
    module.cluster,
  ]

  provisioner "local-exec" {
    command = <<EOF
      gcloud container clusters get-credentials ${local.name} --region ${var.region} --project ${var.project}
      sed -i '' "s/gke_${var.project}_${var.region}_${local.name}/${local.name}/g" ~/.kube/config
    EOF
  }
}

# Clean up kubectl configurations
# https://www.terraform.io/docs/provisioners/null_resource.html
# https://www.terraform.io/docs/provisioners/index.html#destroy-time-provisioners
# https://www.terraform.io/docs/provisioners/local-exec.html
resource "null_resource" "cleanup_kubectl" {
  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
      kubectl config unset clusters.${local.name}
      kubectl config unset users.${local.name}
      kubectl config unset contexts.${local.name}
    EOF
  }
}
