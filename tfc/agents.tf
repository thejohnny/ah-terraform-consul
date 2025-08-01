resource "tfe_agent_pool" "ah_consul" {
  name                = "ah-consul"
  organization        = data.tfe_organization.is.name
  organization_scoped = true
}

resource "tfe_agent_token" "ah_consul" {
  agent_pool_id = tfe_agent_pool.ah_consul.id
  description   = "ah-consul-infra"
}