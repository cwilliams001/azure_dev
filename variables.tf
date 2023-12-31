variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure location where the resources should be created."
  type        = string
}

variable "environment_tag" {
  description = "The environment tag to be used"
  type        = string
}

variable "vm_count" {
  description = "The number of VMs to create."
  type        = number
}

variable "vm_name_prefix" {
  description = "The prefix for the VM names."
  type        = string
  default     = "dev-vm"
}

variable "admin_username" {
  description = "The admin username for the VMs."
  type        = string
}

variable "ssh_public_key_path" {
  description = "The file path of the SSH public key to be used for the VMs."
  type        = string
}

variable "record_prefix" {
  description = "The prefix to use for the DNS records."
  type        = string
}

variable "domain_name" {
  description = "The domain name for the DNS zone."
  type        = string
}

variable "acme_email" {
  description = "The email address to use for Let's Encrypt."
  type        = string

}
