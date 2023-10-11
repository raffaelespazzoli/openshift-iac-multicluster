output "cluster_id" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.id
}

output "oidc_thumbprint" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.sts.thumbprint
}

output "oidc_endpoint_url" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.sts.oidc_endpoint_url
}

output "api_url" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.api_url
}

output "console_url" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.console_url
}

output "domain" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.domain
}

output "username" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.admin_credentials.username
  sensitive = true
}

output "password" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.admin_credentials.password
  sensitive = true
}