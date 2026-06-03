variable "group_name" {
  description = "Display name of the security group to create"
  type        = string
  default     = "Test-Group-Terraform1"
}

variable "group_description" {
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
