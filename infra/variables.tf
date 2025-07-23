variable "consul_initial_management_token" {
  type        = string
  description = "Consul ACL initial management token value"
}

variable "ec2_ip_allowlist" {
  type        = list(string)
  description = "List of IPv4 addresses to allow access to Consul and TFE agents"
}

variable "tfc_agent_token" {
  type        = string
  description = "TFC agent pool token"
}