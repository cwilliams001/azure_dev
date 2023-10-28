variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "domain_name" {
  description = "The domain name for the DNS zone."
  type        = string
}

variable "ip_addresses" {
  description = "A map of VM names to their public IP addresses."
  type        = map(string)
}

variable "location" {
  description = "The Azure location where the resources should be created."
  type        = string
}

variable "record_prefix" {
  description = "The prefix to use for the DNS records."
  type        = string
  default     = "hs"
}

variable "environment_tag" {
  description = "The environment tag to be used"
  type        = string
  default     = "dev"
}
