# https://www.terraform.io/docs/configuration/terraform.html
terraform {
  # Re-usable modules should constrain only the minimum allowed version.
  required_version = ">= 0.12"
}

# https://www.terraform.io/docs/configuration/locals.html
locals {
  private = "private"
  public  = "public"
}

# ================================================================================
#  Data Sources
# ================================================================================

# https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets
# https://www.terraform.io/docs/providers/google/d/datasource_compute_subnetwork.html
data "google_compute_subnetwork" "private" {
  self_link = var.subnetwork_private
}

# https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets
# https://www.terraform.io/docs/providers/google/d/datasource_compute_subnetwork.html
data "google_compute_subnetwork" "public" {
  self_link = var.subnetwork_public
}

# ================================================================================
#  Firewall Rules
# ================================================================================

# https://cloud.google.com/vpc/docs/firewalls
# https://www.terraform.io/docs/providers/google/r/compute_firewall.html
resource "google_compute_firewall" "private" {
  name    = "${var.name}-private"
  project = var.project
  network = var.network

  direction     = "INGRESS"
  target_tags   = [ local.private ]
  source_ranges = [
    data.google_compute_subnetwork.private.ip_cidr_range,
    data.google_compute_subnetwork.private.secondary_ip_range[0].ip_cidr_range,
    data.google_compute_subnetwork.public.ip_cidr_range,
    data.google_compute_subnetwork.public.secondary_ip_range[0].ip_cidr_range,
  ]

  allow {
    protocol = "all"
  }
}

# https://cloud.google.com/vpc/docs/firewalls
# https://www.terraform.io/docs/providers/google/r/compute_firewall.html
resource "google_compute_firewall" "public" {
  name    = "${var.name}-public"
  project = var.project
  network = var.network

  direction     = "INGRESS"
  target_tags   = [ local.public ]
  source_ranges = [ var.public_ip_range ]

  allow {
    protocol = "all"
  }
}
