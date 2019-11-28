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

variable "node_pool_config" {
  description = ""

  type = map(object({
    machine_type   = string  // The name of a Google Compute Engine machine type.
    disk_type      = string  // Type of the disk attached to each node (pd-standard or pd-ssd).
    disk_size_gb   = number  // Size of the disk attached to each node in GB.
    min_node_count = number  // The minimum number of nodes in the node pool.
    max_node_count = number  // The maximum number of nodes in the node pool.
  }))

  default = {
    primary = {
      machine_type   = "n1-standard-1"
      disk_type      = "pd-standard"
      disk_size_gb   = 32
      min_node_count = 1
      max_node_count = 3
    }
  }
}
