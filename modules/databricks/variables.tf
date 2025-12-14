variable "environment" {
  type = string
}

variable "location" {
  description = "The location for the resources"
  type        = string
}

variable "tenant_id" {
  type = string
  description = "tenant id"
}
variable "resource_group_name" {
  description = "The name of the datalake resource group"
  type        = string
}

variable "datalake_storage_account_id" {
  description = "The ID of the datalake storage account"
  type        = string
}

variable public_subnet_name {
  description = "The ID of the subnet where resources will be deployed"
  type        = string
  default     = "public-subnet"
}

variable private_subnet_name {
  description = "The ID of the subnet where resources will be deployed"
  type        = string
  default     = "private-subnet"
}
variable vnet_name {
  description = "The name of the virtual network"
  type        = string
  default     = "workers-vnet"
}
