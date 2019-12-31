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

variable "network" {
  type        = string
  description = "The reference (self_link) to a VPC network."
}

variable "subnetwork_private" {
  type        = string
  description = "The reference (self_link) to the private subnetwork of the network."
}

variable "subnetwork_public" {
  type        = string
  description = "The reference (self_link) to the public subnetwork of the network."
}

variable "public_ip_range" {
  type        = string
  description = "A range of IP addresses in CIDR format for public access."
  default     = "0.0.0.0/0"
}
