
variable "operator_role_prefix" {
  type = string
}

variable "account_role_prefix" {
  type = string
}

variable "cluster_name" {
  type    = string
}

variable "cloud_region" {
  type    = string
}

variable "availability_zone_a" {
  type    = string
}

variable "availability_zone_b" {
  type    = string
}

variable "availability_zone_c" {
  type    = string
}

variable "tags" {
  description = "List of AWS resource tags to apply."
  type        = map(string)
  default     = null
}

variable "path" {
  description = "(Optional) The arn path for the account/operator roles as well as their policies."
  type        = string
  default     = null
}

variable "aws_subnet_id_a1" {
  type    = string
}

variable "aws_subnet_id_a2" {
  type    = string
}

variable "aws_subnet_id_b1" {
  type    = string
}

variable "aws_subnet_id_b2" {
  type    = string
}

variable "aws_subnet_id_c1" {
  type    = string
}

variable "aws_subnet_id_c2" {
  type    = string
}

variable "admin_username" {
  type = string
  sensitive = true
}

variable "admin_password" {
  type = string
  sensitive = true
}

variable "ocm_environment" {
  type    = string
  default = "production"
}

variable "openshift_version" {
  type = string
  default = ""
}