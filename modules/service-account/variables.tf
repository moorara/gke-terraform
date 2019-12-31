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

variable "roles" {
  type        = list(string)
  description = "Additional roles to be added to the service account."
  default     = []
}
