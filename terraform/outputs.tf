# https://www.terraform.io/docs/configuration/outputs.html

output "cluster_name" {
  value       = local.name
  description = "The name of Kubernetes cluster."
}

output "cluster_endpoint" {
  value       = module.cluster.endpoint
  description = "The IP address of the Kubernetes cluster master."
}

output "cluster_ca_certificate" {
  value       = module.cluster.cluster_ca_certificate
  description = "Public certificate authority that is the root of trust for the cluster (base64-encoded)."
}

output "client_certificate" {
  value       = module.cluster.client_certificate
  description = "Public certificate for clients to authenticate to the cluster (base64-encoded)."
}

output "client_key" {
  value       = module.cluster.client_key
  description = "Private key for clients to authenticate to the cluster (base64-encoded)."
}
