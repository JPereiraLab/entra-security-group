output "group_id" {
  description = "Object ID of the created group"
  value       = azuread_group.security_group.id
}

output "group_display_name" {
  description = "Display name of the created group"
  value       = azuread_group.security_group.display_name
}

output "second_group_id" {
  description = "Object ID of the second group"
  value       = azuread_group.second_group.id
}

output "second_group_display_name" {
  description = "Display name of the second group"
  value       = azuread_group.second_group.display_name
}
