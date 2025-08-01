variable "github_oauth_token" {
  type        = string
  description = "GitHub oauth token (sensitive)"
}

variable "tfc_aws_audience" {
  type        = string
  default     = "aws.workload.identity"
  description = "The audience value to use in run identity tokens"
}

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with AWS"
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
}

variable "tfc_project_name" {
  type        = string
  default     = "Default Project"
  description = "The project under which a workspace will be created"
}

variable "tfc_workspace_name" {
  type        = string
  description = "The name of the workspace that you'd like to create and connect to AWS"
}

variable "consul_initial_management_token" {
  type        = string
  description = "Consul ACL initial management token value"
}

variable "ec2_ip_allowlist" {
  type        = list(string)
  description = "List of IPv4 addresses to allow access to Consul and TFE agents"
}
