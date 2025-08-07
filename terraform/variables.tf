variable "environment" {
  type        = string
  description = "Deployment environment, e.g. local, production"
}

variable "hcloud_token" {
  type        = string
  sensitive   = true
  description = "Hetzner Cloud API token"
}

variable "location" {
  type        = string
  description = "Hetzner Cloud location, e.g. fsn1 or nbg1"
}

variable "ansible_user_name" {
  type        = string
  description = "SSH user used for Ansible"
}

variable "servers_count" {
  type        = number
  description = "How many servers to create"
}
