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
