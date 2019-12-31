# https://www.terraform.io/docs/configuration/variables.html
# https://www.terraform.io/docs/configuration/types.html

variable "name" {
  type        = string
  description = "A name to be used as prefix in resource names."
}

variable "project" {
  type        = string
  description = "The Google Cloud project to manage resources in."
}

variable "region" {
  type        = string
  description = "The Google Cloud region to manage resources in."
}

variable "network" {
  type        = string
  description = "A reference (self_link) to the VPC network."
}

variable "subnetwork" {
  type        = string
  description = "A reference (self_link) to the subnetwork."
}

variable "service_account" {
  type        = string
  description = "The service account to be used by the nodes."
}

variable "common_labels" {
  type        = map(string)
  description = "A map of labels to be applied to every resource."
}

variable "region_label" {
  type        = map(string)
  description = "A map of labels to be applied to regional resources."
}

variable "common_tags" {
  type        = list(string)
  description = "A list of tags to be applied to every resource."
}

variable "region_tag" {
  type        = list(string)
  description = "A list of tags to be applied to regional resources."
}

variable "node_pool_config" {
  type = map(object({
    machine_type   = string  # The name of a Google Compute Engine machine type.
    disk_type      = string  # Type of the disk attached to each node (pd-standard or pd-ssd).
    disk_size_gb   = number  # Size of the disk attached to each node in GB.
    min_node_count = number  # The minimum number of nodes in the node pool.
    max_node_count = number  # The maximum number of nodes in the node pool.
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
