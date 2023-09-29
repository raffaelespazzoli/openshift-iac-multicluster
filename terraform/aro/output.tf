output "apiURL" {
  value = jsondecode(azapi_resource.aro_cluster.body).apiserverProfile.url
  sensitive = true
}

output "consoleURL" {
  value = jsondecode(azapi_resource.aro_cluster.body).consoleProfile.url
  sensitive = true
}

output "kubeconfig" {
  value = base64decode(jsondecode(azapi_resource_action.kubeconfig.output).kubeconfig)
  sensitive = true
}

output "adminUsername" {
  value = jsondecode(azapi_resource_action.admin_credentials.output).kubeadminUsername
  sensitive = true
}

output "adminPassword" {
  value = jsondecode(azapi_resource_action.admin_credentials.output).kubeadminPassword
  sensitive = true
}