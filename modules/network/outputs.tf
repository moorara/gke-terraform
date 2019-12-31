# https://www.terraform.io/docs/configuration/outputs.html

output "network" {
  value       = google_compute_network.main.self_link
  description = "The reference (self_link) to the VPC network."
}

output "private_subnetwork" {
  value       = google_compute_subnetwork.private.self_link
  description = "The reference (self_link) to the private subnetwork."
}

output "public_subnetwork" {
  value       = google_compute_subnetwork.public.self_link
  description = "The reference (self_link) to the public subnetwork."
}
