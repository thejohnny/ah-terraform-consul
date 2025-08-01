resource "tfe_project" "consul_mgmt" {
  name         = "ah-consul-mgmt"
  organization = data.tfe_organization.is.name
}

resource "tfe_workspace" "nva1_dev_management" {
  name         = "nva1-dev-management"
  organization = data.tfe_organization.is.name
  project_id   = tfe_project.consul_mgmt.id

  working_directory             = "management"
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

resource "tfe_workspace_settings" "exec_mode" {
  workspace_id   = tfe_workspace.nva1_dev_management.id
  execution_mode = "agent"
  agent_pool_id  = tfe_agent_pool.ah_consul.id
}

resource "tfe_variable" "consul_http_addr" {
  workspace_id = tfe_workspace.nva1_dev_management.id

  key      = "CONSUL_HTTP_ADDR"
  value    = "http://172.31.8.154:8500"
  category = "env"

  description = "Set Consul provider's API address"
}

resource "tfe_variable" "consul_http_token" {
  workspace_id = tfe_workspace.nva1_dev_management.id

  key      = "CONSUL_HTTP_TOKEN"
  value    = var.consul_initial_management_token
  category = "env"

  description = "Set Consul provider's API token"
}
