variable "environment" {
  description = "The environment for the resources (e.g., dev, sit, prod)"
  type        = string
  default     = "dev"
}  

variable "tenant_id" {
  description = "The Azure AD tenant ID"
  type        = string
}