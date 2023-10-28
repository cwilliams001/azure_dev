variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The Azure location where the resources should be created."
  type        = string
}

variable "environment_tag" {
  description = "The environment for the network resources"
  type        = string
  default     = "dev"  // Optional: Set a default value if desired
}