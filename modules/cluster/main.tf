# https://www.terraform.io/docs/configuration/terraform.html
terraform {
  # Re-usable modules should constrain only the minimum allowed version.
  required_version = ">= 0.12"
}

# https://cloud.google.com/kubernetes-engine
# https://www.terraform.io/docs/providers/google/r/container_cluster.html
resource "google_container_cluster" "main" {
  provider = google-beta

  name    = var.name
  project = var.project

  # https://www.terraform.io/docs/providers/google/r/container_cluster.html#location
  location = var.region

  network    = var.network
  subnetwork = var.subnetwork

  # We cannot create a cluster with no node pool defined, but we want to only use  separately managed node pools.
  # So we create the smallest possible default node pool and immediately delete it.
  initial_node_count       = 1
  remove_default_node_pool = true

  # https://www.terraform.io/docs/providers/google/r/container_cluster.html#master_auth
  master_auth {
    username = ""
    password = ""

    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#client_certificate_config
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  # https://www.terraform.io/docs/providers/google/r/container_cluster.html#network_policy_config
  addons_config {
    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#network_policy_config
    network_policy_config {
      disabled = false
    }

    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#http_load_balancing
    http_load_balancing {
      disabled = false
    }

    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#horizontal_pod_autoscaling
    horizontal_pod_autoscaling {
      disabled = false
    }

    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#istio_config
    istio_config {
      disabled = true
    }

    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#cloudrun_config
    cloudrun_config {
      disabled = true
    }
  }

  # https://kubernetes.io/docs/concepts/services-networking/network-policies
  # https://www.terraform.io/docs/providers/google/r/container_cluster.html#network_policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  resource_labels = merge(var.common_labels, var.region_label, {
    name = var.name
  })
}

# https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools
# https://www.terraform.io/docs/providers/google/r/container_node_pool.html
resource "google_container_node_pool" "primary" {
  name       = var.name
  location   = var.region
  cluster    = google_container_cluster.main.name

  # https://www.terraform.io/docs/providers/google/r/container_node_pool.html#management
  management { 
    auto_repair  = true
    auto_upgrade = true
  }

  # https://www.terraform.io/docs/providers/google/r/container_node_pool.html#initial_node_count
  initial_node_count = 1

  # https://www.terraform.io/docs/providers/google/r/container_node_pool.html#autoscaling
  autoscaling { 
    min_node_count = var.node_pool_config.primary.min_node_count
    max_node_count = var.node_pool_config.primary.max_node_count
  }

  # https://www.terraform.io/docs/providers/google/r/container_cluster.html#node_config
  node_config {
    preemptible  = false
    machine_type = var.node_pool_config.primary.machine_type
    disk_type    = var.node_pool_config.primary.disk_type
    disk_size_gb = var.node_pool_config.primary.disk_size_gb

    service_account = var.service_account

    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#metadata
    metadata = {
      disable-legacy-endpoints = "true"
    }

    # https://www.terraform.io/docs/providers/google/r/container_cluster.html#oauth_scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]

    labels = merge(var.common_labels, var.region_label, {
      name = var.name
    })

    # If the cluster is private, the "private" tag needs to be added here
    tags = concat(var.common_tags, var.region_tag)
  }

  lifecycle {
    ignore_changes = [ initial_node_count ]
  }

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}
