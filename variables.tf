variable tenant_id {
  description = "The Azure AD tenant ID"
  type        = string
  default = "25d63387-d8f7-44d2-94ee-f84273e298e2"
}

variable environment {
  description = "The environment for the resources (e.g., dev, sit, prod)"
  type        = string
  default     = "dev"
}

variable azure_owner_object_id {
  description = "The object ID of the Azure AD user or service principal to be assigned as owner"
  type        = string
  default     = "fc7625b1-ef33-4620-bc88-595adcaebc32"  # Replace with actual object ID
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

variable SUNSYNC_USER {
  type = string
  description = "usrr"

}
variable SUNSYNC_PASSWORD {
  type = string
  description = "usrr"

}
variable MEL_USER {
  type = string
  description = "usrr"

}
variable MEL_PASSWORD {
  type = string
  description = "usrr"

}
variable WEATHER_API_URL {
  type = string
  description = "usrr"

}
variable AZURE_STORAGE_KEY {
  type = string
  description = "usrr"

}
