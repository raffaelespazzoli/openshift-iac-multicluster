output "apiURL" {
  value = azapi_resource.aro_cluster.body
  sensitive = true
}

output "consoleURL" {
  value = azapi_resource.aro_cluster.response_export_values
  sensitive = true
}

output "adminUsername" {
  value = "username"
  sensitive = true
}

output "adminPassword" {
  value = "password"
  sensitive = true
}