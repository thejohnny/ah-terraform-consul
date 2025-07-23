data "cloudinit_config" "consul_server" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "init-cloud-config"
    content_type = "text/cloud-config"
    content      = templatefile(
      "${path.module}/templates/cloud-init.yml.tmpl", {}
    )
  }

  part {
    filename     = "init-shellscript"
    content_type = "text/x-shellscript"
    content      = templatefile(
      "${path.module}/templates/config-consul.sh.tmpl",
      {
        initial_management_token = var.consul_initial_management_token
      }
    )
  }
}

module "consul_server" {
  source = "./modules/aws-ec2-instance"

  resource_prefix       = "${random_pet.main.id}-consul"
  ec2_node_count        = 1
  ec2_aws_key_pair_name = aws_key_pair.main.key_name
  ec2_ip_allowlist      = var.ec2_ip_allowlist
  ec2_user_data_base64  = data.cloudinit_config.consul_server.rendered
}

output "consul_http_addr" {
  value = "http://${module.consul_server.aws_instance[0].private_ip}:8500"
}