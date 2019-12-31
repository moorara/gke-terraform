# https://www.terraform.io/docs/configuration/outputs.html

output "name" {
  value       = var.name
  description = "The name of Kubernetes cluster."
}

output "endpoint" {
  value       = google_container_cluster.main.endpoint
  description = "The IP address of the Kubernetes cluster master."
}

output "certificate_authority" {
  value       = google_container_cluster.main.master_auth.0.cluster_ca_certificate
  description = "Public certificate authority that is the root of trust for the cluster (base64-encoded)."
}

output "client_certificate" {
  value       = google_container_cluster.main.master_auth.0.client_certificate
  description = "Public certificate for clients to authenticate to the cluster (base64-encoded)."
}

output "client_key" {
  value       = google_container_cluster.main.master_auth.0.client_key
  description = "Private key for clients to authenticate to the cluster (base64-encoded)."
}
