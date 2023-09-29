output "apiURL" {
  value = jsondecode(azapi_resource.aro_cluster.body).apiserverProfile.url
  sensitive = true
}

output "consoleURL" {
  value = jsondecode(azapi_resource.aro_cluster.body).consoleProfile.url
  sensitive = true
}

output "kubeconfig" {
  value = base64decode(jsondecode(azapi_resource_action.admin_secret.output).kubeconfig)
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