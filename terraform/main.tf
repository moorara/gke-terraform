# https://www.terraform.io/docs/configuration/terraform.html
# https://www.terraform.io/docs/backends/index.html
# https://www.terraform.io/docs/backends/types/gcs.html
terraform {
  # Equivalent to ">= 0.12, < 1.0"
  required_version = "~> 0.12"
  backend "gcs" {}
}

# https://www.terraform.io/docs/providers/google
# https://www.terraform.io/docs/providers/google/getting_started.html
# https://www.terraform.io/docs/configuration/providers.html#version-provider-versions
provider "google" {
  # Equivalent to ">= 2.20.0, < 2.0.0"
  version     = "~> 2.20"
  credentials = file("account.json")
  project     = var.project
  region      = var.region
}
