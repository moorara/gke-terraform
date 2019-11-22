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

  resource_labels = merge(local.common_labels, local.region_label, {
    name = local.name
  })
}

# https://cloud.google.com/kubernetes-engine/docs/concepts/node-pools
# https://www.terraform.io/docs/providers/google/r/container_node_pool.html
resource "google_container_node_pool" "main" {
  name       = local.name
  location   = var.region
  cluster    = google_container_cluster.main.name

  # https://www.terraform.io/docs/providers/google/r/container_node_pool.html#management
  management { 
    auto_repair  = true
    auto_upgrade = true
  }

  # https://www.terraform.io/docs/providers/google/r/container_node_pool.html#node_count
  node_count = 1

  # https://www.terraform.io/docs/providers/google/r/container_cluster.html#node_config
  node_config {
    # preemptible  = true
    machine_type = var.machine_type
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb

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
  depends_on = [ google_container_cluster.main ]

  provisioner "local-exec" {
    command = <<EOF
      kubectl config set clusters.${local.name}-cluster.server ${google_container_cluster.main.endpoint}
      kubectl config set clusters.${local.name}-cluster.certificate-authority-data ${google_container_cluster.main.master_auth.0.cluster_ca_certificate}
      kubectl config set users.${local.name}-user.client-certificate-data ${google_container_cluster.main.master_auth.0.client_certificate}
      kubectl config set users.${local.name}-user.client-key-data ${google_container_cluster.main.master_auth.0.client_key}
      kubectl config set contexts.${local.name}.cluster ${local.name}-cluster
      kubectl config set contexts.${local.name}.namespace default
      kubectl config set contexts.${local.name}.user ${local.name}-user
      kubectl config use-context ${local.name}
    EOF
  }
}

# Clean up kubectl configurations
# https://www.terraform.io/docs/provisioners/null_resource.html
# https://www.terraform.io/docs/provisioners/index.html#destroy-time-provisioners
# https://www.terraform.io/docs/provisioners/local-exec.html
resource "null_resource" "cleanup_kubectl" {
  provisioner "local-exec" {
    when    = "destroy"
    command = <<EOF
      kubectl config unset clusters.${local.name}-cluster
      kubectl config unset users.${local.name}-user
      kubectl config unset contexts.${local.name}
    EOF
  }
}
