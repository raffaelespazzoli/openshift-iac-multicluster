output "cluster_id" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.id
}

output "oidc_thumbprint" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.sts.thumbprint
}

output "oidc_endpoint_url" {
  value = rhcs_cluster_rosa_classic.rosa_sts_cluster.sts.oidc_endpoint_url
}