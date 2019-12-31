# https://www.terraform.io/docs/configuration/terraform.html
terraform {
  # Re-usable modules should constrain only the minimum allowed version.
  required_version = ">= 0.12"
}

# ================================================================================
#  VPC Network
# ================================================================================

# https://cloud.google.com/vpc/docs/vpc
# https://www.terraform.io/docs/providers/google/r/compute_network.html
resource "google_compute_network" "main" {
  name                            = "${var.name}-network"
  project                         = var.project
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  delete_default_routes_on_create = false
}

# ================================================================================
#  Subnetworks
# ================================================================================

# https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets
# https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html
resource "google_compute_subnetwork" "private" {
  name                     = "${var.name}-subnet-private"
  project                  = var.project
  region                   = var.region
  network                  = google_compute_network.main.self_link
  private_ip_google_access = true
  ip_cidr_range            = cidrsubnet(lookup(var.subnetwork_cidrs, var.region), 8, 1)

  # https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html#secondary_ip_range
  secondary_ip_range {
    range_name = "public-services"
    ip_cidr_range = cidrsubnet(lookup(var.subnetwork_cidrs, var.region), 8, 2)
  }

  # https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html#log_config
  log_config {
    aggregation_interval = "INTERVAL_1_MIN"
    flow_sampling        = var.flow_log_sampling
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# https://cloud.google.com/vpc/docs/vpc#vpc_networks_and_subnets
# https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html
resource "google_compute_subnetwork" "public" {
  name                     = "${var.name}-subnet-public"
  project                  = var.project
  region                   = var.region
  network                  = google_compute_network.main.self_link
  private_ip_google_access = true
  ip_cidr_range            = cidrsubnet(lookup(var.subnetwork_cidrs, var.region), 8, 128)

  # https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html#secondary_ip_range
  secondary_ip_range {
    range_name = "public-services"
    ip_cidr_range = cidrsubnet(lookup(var.subnetwork_cidrs, var.region), 8, 129)
  }

  # https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html#log_config
  log_config {
    aggregation_interval = "INTERVAL_1_MIN"
    flow_sampling        = var.flow_log_sampling
    metadata             = "INCLUDE_ALL_METADATA"
  }
}

# ================================================================================
#  Routers
# ================================================================================

# https://cloud.google.com/router/docs/concepts/overview
# https://www.terraform.io/docs/providers/google/r/compute_router.html
resource "google_compute_router" "main" {
  name    = "${var.name}-router"
  project = var.project
  region  = var.region
  network = google_compute_network.main.self_link
}

# https://cloud.google.com/router/docs/concepts/overview
# https://www.terraform.io/docs/providers/google/r/compute_router_nat.html
resource "google_compute_router_nat" "main" {
  name    = "${var.name}-nat"
  project = var.project
  region  = var.region
  router  = google_compute_router.main.name

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.public.self_link
    source_ip_ranges_to_nat = [ "ALL_IP_RANGES" ]
  }
}
