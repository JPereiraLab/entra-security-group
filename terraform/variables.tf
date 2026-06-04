variable "group_name-first" {
  description = "Display name of the security group to create"
  type        = string
  default     = "Test-Group-Terraform-1"
}

variable "group_description-first" {
  description = "Description of the security group"
  type        = string
  default     = "Created via Terraform"
}

variable "group_name-second" {
  description = "Display name of the security group to create"
  type        = string
  default     = "Test-Group-Terraform-2"
}

variable "group_description-second" {
  description = "Description of the security group"
  type        = string
  default     = "Created via Terraform"
}

variable "entra_client_id" {
  description = "Client ID of the Entra app registration in the joaolab tenant (for managing Entra resources)"
  type        = string
}

variable "entra_tenant_id" {
  description = "Tenant ID of the joaolab tenant"
  type        = string
}
