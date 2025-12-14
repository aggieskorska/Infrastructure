variable "environment" {
  description = "The environment for the resources (e.g., dev, sit, prod)"
  type        = string
  default     = "dev"
  
}

variable "location" {
  description = "The location for the resources"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the datalake resource group"
  type        = string
}

variable "datalake_storage_account_id" {
  description = "The ID of the datalake storage account"
  type        = string
}

variable sunsynk_user {
  type = string
  description = "usrr"
  
}
variable sunsynk_password {
  type = string
  description = "usrr"
  
}
variable mel_user {
  type = string
  description = "usrr"
  
}
variable mel_password {
  type = string
  description = "usrr"
  
}
variable weather_api_url {
  type = string
  description = "usrr"
  
}
variable azure_storage_key {
  type = string
  description = "usrr"
  
}
