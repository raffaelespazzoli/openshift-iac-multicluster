# header

variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable resource_group_name {
  type = string
}

#clusterProfile

variable domain {
  type = string
  nullable = true
}

variable fips_validated_modules {
  type = bool
  default = false
}

variable pull_secret {
  type = string
  sensitive = true
  nullable = true  
}

# networkProfile

variable pod_cidr {
  type = string
  default = "10.128.0.0/14"
}

variable service_cidr {
  type = string
  default = "172.30.0.0/16"
}

# servicePrincipalProfile

variable clientId {
  type = string
  sensitive = true
}

variable clientSecret {
  type = string
  sensitive = true
}

#masterProfile

variable master_node_vm_size {
  type = string
  default = "Standard_D8s_v3"
}

variable master_subnet_id {
  type = string
}

variable master_encryption_at_host {
  type = string
  default = "Disabled"
}

#workerProfile

variable worker_profile_name {
  type = string
  default = "worker"
}

variable worker_node_vm_size {
  type = string
  default = "Standard_D4s_v3"
}

# size in GB
variable worker_node_vm_disk_size {
  type = number
  default = 128
}

variable worker_subnet_id {
  type = string
}

variable worker_encryption_at_host {
  type = string
  default = "Disabled"
}

#apiServerProfile

variable api_server_visibility {
  type = string
  default = "Private"
}

#ingressProfile

variable ingress_profile_name {
  type =string
  default = "default"
}

variable ingress_visibility {
  type = string
  default = "Private"
}

