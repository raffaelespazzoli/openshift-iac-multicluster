
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

variable "availability_zone" {
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

variable "aws_subnet_id" {
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