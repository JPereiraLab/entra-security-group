resource "azuread_group" "security_group" {
  display_name     = var.group_name_first
  description      = var.group_description_first
  security_enabled = true
  mail_enabled     = false
}

resource "azuread_group" "second_group" {
  display_name     = var.group_name_second
  description      = var.group_description_second
  security_enabled = true
  mail_enabled     = false
}

