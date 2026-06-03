resource "azuread_group" "security_group" {
  display_name     = var.group_name
  description      = var.group_description
  security_enabled = true
  mail_enabled     = false
}

