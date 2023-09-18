variable "name" {
  type = string
}


variable "location" {
  type = string
}

variable resource_group_name {
  type = string
}

variable "tags" {
  type = map(string)
  default = null
}

variable "resource_prefix" {
  type = string
  default = ""
}


variable domain {
  type = string
  nullable = true
  default = ""
}

variable fips_validated_modules {
  type = bool
  default = false
}

variable pull_secret {
  type = string
  sensitive = true
  nullable = true
  default = null 
}



variable pod_cidr {
  type = string
  default = "10.128.0.0/14"
}

variable service_cidr {
  type = string
  default = "172.30.0.0/16"
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
  default = "Standard_D8s_v3"
}

variable master_subnet_id {
  type = string
}

variable master_encryption_at_host {
  type = string
  default = "Disabled"
}



variable worker_profile_name {
  type = string
  default = "worker"
}

variable worker_node_vm_size {
  type = string
  default = "Standard_D4s_v3"
}


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

variable "worker_node_count" {
  type = number
  default = 3
}



variable api_server_visibility {
  type = string
  default = "Private"
}



variable ingress_profile_name {
  type =string
  default = "default"
}

variable ingress_visibility {
  type = string
  default = "Private"
}

