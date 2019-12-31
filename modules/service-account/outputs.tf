# https://www.terraform.io/docs/configuration/outputs.html

output "id" {
  value       = google_service_account.main.unique_id
  description = "The unique id of the service account."
}

output "name" {
  value       = google_service_account.main.name
  description = "The fully-qualified name of the service account."
}

output "email" {
  value       = google_service_account.main.email
  description = "The email address of the service account."
}
