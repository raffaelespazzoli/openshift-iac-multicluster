variable "name" {
  type = string
}

variable "location" {
  type = string
}


variable domain {
  type = string
  default = ""
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
  default = ""
  sensitive = true
}

variable pod_cidr {
  type = string
  default = ""
}

variable service_cidr {
  type = string
  default = ""
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
  default = ""
}

variable master_subnet_id {
  type = string
}

variable api_server_visibility {
  type = string
  default = "Public"
}

variable ingress_profile_name {
  type =string
}

variable ingress_visibility {
  type = string
  default = "Public"
}

variable master_encryption_at_host {
  type = bool
  default = false
}

variable worker_profile_name {
  type = string
  default = ""
}

variable worker_node_vm_size {
  type = string
  default = ""
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
  default = "Public"
}

variable ingress_profile_name {
  type =string
}

variable ingress_visibility {
  type = string
  default = "Public"
}

