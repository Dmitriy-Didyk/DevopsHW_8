# Публичный IP-адрес для VM1
output "vm1_public_ip" {
  value       = azurerm_public_ip.vm1_public_ip.ip_address
  description = "Public IP address of VM1"
}

# Публичный IP-адрес для VM2
output "vm2_public_ip" {
  value       = azurerm_public_ip.vm2_public_ip.ip_address
  description = "Public IP address of VM2"
}
