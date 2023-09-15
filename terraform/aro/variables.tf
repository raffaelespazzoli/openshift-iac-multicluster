variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable domain {
  type = string
}

variable resource_group_id {
  type = string
}

variable fips_validated_modules {
  type = bool
  default = false
}

variable pull_secret {
  type = string
  sensitive = true
}

variable pod_cidr {
  type = string
}

variable service_cidr {
  type = string
}

variable clientId {
  type = string
  sensitive = true
}

variable clientSecret {
  type = string
  sensitive = true
}

variable master_node_vm_size {
  type = string
}

variable master_subnet_id {
  type = string
}

variable master_encryption_at_host {
  type = bool
  default = false
}

variable worker_profile_name {
  type = string
}

variable worker_node_vm_size {
  type = string
}

# size in GB
variable worker_node_vm_disk_size {
  type = number
}

variable worker_subnet_id {
  type = string
}

variable worker_encryption_at_host {
  type = bool
  default = false
}

variable api_server_visibility {
  type = string
}

variable ingress_profile_name {
  type =string
}

variable ingress_visibility {
  type = string
}

