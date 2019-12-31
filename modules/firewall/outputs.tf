# https://www.terraform.io/docs/configuration/outputs.html

output "private" {
  value       = local.private
  description = "The private tag string."
}

output "public" {
  value       = local.public
  description = "The public tag string."
}
