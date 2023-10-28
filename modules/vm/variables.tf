variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure location where the resources should be created."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet."
  type        = string
}

variable "vm_count" {
  description = "The number of VMs to create."
  type        = number
  default     = 1
}

variable "vm_name_prefix" {
  description = "The prefix for the VM names."
  type        = string
  default     = "dev-vm"
}

variable "admin_username"{
  description = "The username of the admin user."
  type        = string
  default     = "adminuser"
}

variable "ssh_public_key_path" {
  description = "The path to the SSH public key."
  type        = string
  default    = "~/.ssh/dev-azure.pub"
}

variable "environment_tag" {
  description = "The environment tag to be used"
  type        = string
  default     = "dev"
}