variable "group_name" {
  description = "Display name of the security group to create"
  type        = string
  default     = "Test-Group-Terraform"
}

variable "group_description" {
  description = "Description of the security group"
  type        = string
  default     = "Created via Terraform"
}
