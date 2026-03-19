output "resource_group_name" {
  description = "Resource group containing the Docker deployment infrastructure."
  value       = azurerm_resource_group.main.name
}

output "virtual_machine_name" {
  description = "Provisioned Linux VM name."
  value       = azurerm_linux_virtual_machine.web.name
}

output "public_ip_address" {
  description = "Public IP assigned to the Linux VM."
  value       = azurerm_public_ip.web.ip_address
}

output "site_port" {
  description = "HTTP port exposed for the application."
  value       = var.site_port
}

output "site_url" {
  description = "Application URL."
  value       = "http://${azurerm_public_ip.web.ip_address}:${var.site_port}"
}
