# https://cloud.google.com/kubernetes-engine
# https://www.terraform.io/docs/providers/google/r/container_cluster.html
resource "google_container_cluster" "main" {
  name = local.name

  # https://www.terraform.io/docs/providers/google/r/container_cluster.html#location
  location = var.region

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
    network_policy_config {
      disabled = false
    }
  }

  # https://kubernetes.io/docs/concepts/services-networking/network-policies
  # https://www.terraform.io/docs/providers/google/r/container_cluster.html#network_policy
  network_policy {
    enabled  = true
    provider = "CALICO"
  }

  resource_labels = merge(local.common_labels, local.region_label, {
    name = local.name
  })
}

# https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools
# https://www.terraform.io/docs/providers/google/r/container_node_pool.html
resource "google_container_node_pool" "primary" {
  name       = local.name
  location   = var.region
  cluster    = google_container_cluster.main.name

  # https://www.terraform.io/docs/providers/google/r/container_node_pool.html#management
  management { 
    auto_repair  = true
    auto_upgrade = true
  }

  # https://www.terraform.io/docs/providers/google/r/container_node_pool.html#initial_node_count
  initial_node_count = var.node_pool_config.primary.min_node_count

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

    labels = merge(local.common_labels, local.region_label, {
      name = local.name
    })

    tags = concat(local.common_tags, local.region_tag)
  }
}

# Configure kubectl
# https://www.terraform.io/docs/provisioners/null_resource.html
# https://www.terraform.io/docs/provisioners/index.html
# https://www.terraform.io/docs/provisioners/local-exec.html
resource "null_resource" "configure_kubectl" {
  depends_on = [
    google_container_cluster.main,
    google_container_node_pool.primary,
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
