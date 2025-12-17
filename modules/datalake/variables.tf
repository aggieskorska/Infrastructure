variable containers {
  type       = list(string)
  description = "List of Data Lake containers to create"
}
variable "environment" {
  description = "The environment for the resources (e.g., dev, sit, prod)"
  type        = string
}

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}
variable "resource_group_name" {
  description = "The name of the datalake resource group"
  type        = string
}

variable "location" {
  description = "The location for the resources"
  type        = string
} 