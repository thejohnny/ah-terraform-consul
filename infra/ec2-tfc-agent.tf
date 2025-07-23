data "cloudinit_config" "tfe_agent" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init-cloud-config"
    content_type = "text/cloud-config"
    content      = templatefile("${path.module}/templates/cloud-init.yml.tmpl", {})
  }

  part {
    filename     = "init-shellscript"
    content_type = "text/x-shellscript"
    content = templatefile(
      "${path.module}/templates/install-tfc-agent.sh.tmpl",
      {
        tfc_agent_version = "1.23.0",
        tfc_agent_token   = var.tfc_agent_token,
        number_of_agents  = 1
      }
    )
  }
}

module "tfe_agent" {
  source = "./modules/aws-ec2-instance"

  resource_prefix       = "${random_pet.main.id}-tfc-agent"
  ec2_node_count        = 1
  ec2_aws_key_pair_name = aws_key_pair.main.key_name
  ec2_ip_allowlist      = var.ec2_ip_allowlist
  ec2_user_data_base64  = data.cloudinit_config.tfe_agent.rendered
}
