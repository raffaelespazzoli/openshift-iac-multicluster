
variable "operator_role_prefix" {
  type = string
}

variable "account_role_prefix" {
  type = string
}

variable "cluster_name" {
  type    = string
  default = "my-cluster"
}

variable "cloud_region" {
  type    = string
  default = "us-east-2"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-2a"]
}

variable "tags" {
  description = "List of AWS resource tags to apply."
  type        = map(string)
  default     = null
}

variable "aws_subnet_id" {
  type    = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}