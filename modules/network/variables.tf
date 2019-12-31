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

variable "flow_log_sampling" {
  type        = number
  description = "The sampling rate of network flow logs (1.0 means all logs and 0.0 means no logs)."
  default     = 0.0
}

# https://en.wikipedia.org/wiki/Classful_network
variable "subnetwork_cidrs" {
  type        = map(string)
  description = "Subnetwork CIDR for each Google Cloud region."
  default = {
    asia-east1              = "10.10.0.0/16"
    asia-east2              = "10.11.0.0/16"
    asia-northeast1         = "10.12.0.0/16"
    asia-northeast2         = "10.13.0.0/16"
    asia-south1             = "10.14.0.0/16"
    asia-southeast1         = "10.15.0.0/16"
    australia-southeast1    = "10.16.0.0/16"
    europe-north1           = "10.17.0.0/16"
    europe-west1            = "10.18.0.0/16"
    europe-west2            = "10.19.0.0/16"
    europe-west3            = "10.20.0.0/16"
    europe-west4            = "10.21.0.0/16"
    europe-west6            = "10.22.0.0/16"
    northamerica-northeast1 = "10.23.0.0/16"
    southamerica-east1      = "10.24.0.0/16"
    us-central1             = "10.25.0.0/16"
    us-east1                = "10.26.0.0/16"
    us-east4                = "10.27.0.0/16"
    us-west1                = "10.28.0.0/16"
    us-west2                = "10.29.0.0/16"
  }
}
