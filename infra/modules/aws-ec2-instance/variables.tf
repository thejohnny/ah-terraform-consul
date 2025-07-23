variable "resource_prefix" {
  type        = string
  description = "Prefix to prepend to new resources created by this module"
}

variable "ec2_aws_key_pair_name" {
  type        = string
  description = "AWS key pair name for SSH"
}

variable "ec2_instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t3a.small"
}

variable "ec2_node_count" {
  type    = number
  default = 1
}

variable "ec2_user_data_base64" {
  type        = string
  description = "Base64-encoded user data to run on instance launch"
  default     = null
}

variable "ec2_ip_allowlist" {
  type = list(string)
  description = "List of source IP addresses to access server APIs and client services"
}