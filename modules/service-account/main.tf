# https://www.terraform.io/docs/configuration/terraform.html
terraform {
  # Re-usable modules should constrain only the minimum allowed version.
  required_version = ">= 0.12"
}

locals {
  roles = concat(var.roles, [
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter",
    "roles/stackdriver.resourceMetadata.writer",
  ])
}

# https://cloud.google.com/iam/docs/overview
# https://cloud.google.com/iam/docs/understanding-service-accounts
# https://cloud.google.com/compute/docs/access/service-accounts
# https://www.terraform.io/docs/providers/google/r/google_service_account.html
resource "google_service_account" "main" {
  account_id   = var.name
  project      = var.project
  display_name = var.name
}

# https://www.terraform.io/docs/providers/google/r/google_project_iam.html
resource "google_project_iam_member" "main" {
  for_each = toset(local.roles)

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.main.email}"
}
