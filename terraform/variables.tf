# https://www.terraform.io/docs/configuration/variables.html
# https://www.terraform.io/docs/configuration/types.html

# ======================================== Credentials ========================================

variable "project" {
  type        = string
  description = "The Google Cloud project to manage resources in."
}

variable "region" {
  type        = string
  description = "The Google Cloud region to manage resources in."
}

# ======================================== Metadata ========================================

variable "environment" {
  type        = string
  description = "The name of environment for deployment."
}

variable "uuid" {
  type        = string
  description = "A unique identifier for the deployment."
}

variable "owner" {
  type        = string
  description = "An identifiable name, username, or ID that owns the deployment."
}

variable "git_branch" {
  type        = string
  description = "The name of the git branch."
}

variable "git_commit" {
  type        = string
  description = "The short or long hash of the git commit."
}

# ======================================== Configurations ========================================

variable "domain" {
  type        = string
  description = "A full domain name for the deployment."
}

variable "machine_type" {
  type        = string
  description = "The name of a Google Compute Engine machine type."
  default     = "n1-standard-1"
}

variable "disk_type" {
  type        = string
  description = "Type of the disk attached to each node (pd-standard or pd-ssd)."
  default     = "pd-standard"
}

variable "disk_size_gb" {
  type        = number
  description = "Size of the disk attached to each node in GB."
  default     = "32"
}
