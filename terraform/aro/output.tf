output "apiURL" {
  value = azapi_resource.aro_cluster.body
  sensitive = false
}

output "consoleURL" {
  value = azapi_resource.aro_cluster.response_export_values
  sensitive = false
}

output "adminUsername" {
  value = "username"
  sensitive = true
}

output "adminPassword" {
  value = "password"
  sensitive = true
}