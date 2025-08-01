resource "tfe_oauth_client" "thejohnny_ah_consul" {
  name                = "thejohnny-ah-consul-client"
  organization        = data.tfe_organization.is.name
  api_url             = "https://api.github.com"
  http_url            = "https://github.com"
  oauth_token         = var.github_oauth_token
  service_provider    = "github"
  organization_scoped = true
}

resource "tfe_project" "consul_infra" {
  name         = "ah-consul-infra"
  organization = data.tfe_organization.is.name
}

resource "tfe_workspace" "nva1_dev" {
  name         = "nva1-dev"
  organization = data.tfe_organization.is.name
  project_id   = tfe_project.consul_infra.id

  working_directory             = "infra"
  file_triggers_enabled         = false
  queue_all_runs                = false
  speculative_enabled           = false
  structured_run_output_enabled = false

  vcs_repo {
    identifier         = "thejohnny/ah-terraform-consul"
    ingress_submodules = false
    oauth_token_id     = tfe_oauth_client.thejohnny_ah_consul.oauth_token_id
  }

  tags = {
    environment = "dev"
  }
}

resource "tfe_variable" "enable_aws_provider_auth" {
  workspace_id = tfe_workspace.nva1_dev.id

  key      = "TFC_AWS_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for AWS."
}

resource "tfe_variable" "tfc_aws_role_arn" {
  workspace_id = tfe_workspace.nva1_dev.id

  key      = "TFC_AWS_RUN_ROLE_ARN"
  value    = aws_iam_role.tfc_role.arn
  category = "env"

  description = "The AWS role arn runs will use to authenticate."
}

resource "tfe_variable" "aws_default_region" {
  workspace_id = tfe_workspace.nva1_dev.id

  key      = "AWS_DEFAULT_REGION"
  value    = "us-east-2"
  category = "env"

  description = "Set the default AWS region to us-east-2"
}

resource "tfe_variable" "consul_initial_management_token" {
  workspace_id = tfe_workspace.nva1_dev.id

  key      = "consul_initial_management_token"
  value    = var.consul_initial_management_token
  category = "terraform"

  description = "Consul ACL initial management token value"
}

resource "tfe_variable" "ec2_ip_allowlist" {
  workspace_id = tfe_workspace.nva1_dev.id

  key      = "ec2_ip_allowlist"
  value    = jsonencode(var.ec2_ip_allowlist)
  category = "terraform"
  hcl      = true

  description = "List of IPv4 CIDR blocks to allow access to services"
}

resource "tfe_variable" "tfc_agent_token" {
  workspace_id = tfe_workspace.nva1_dev.id

  key       = "tfc_agent_token"
  value     = tfe_agent_token.ah_consul.token
  category  = "terraform"
  sensitive = true

  description = "TFC agent pool token"
}
