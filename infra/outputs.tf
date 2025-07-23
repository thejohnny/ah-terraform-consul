output "consul_http_addr" {
  value = "http://${module.consul_server.aws_instance[0].private_ip}:8500"
}

# Not secure practice
output "private_key_pem" {
  value = nonsensitive(tls_private_key.main.private_key_pem)
}