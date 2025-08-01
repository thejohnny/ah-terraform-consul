node_name   = "client-b"
datacenter  = "dc1"
data_dir    = "./client-beta/data"
bind_addr   = "127.0.10.3"
client_addr = "127.0.10.3"
server      = false

retry_join = ["127.0.20.1:8304"]
segment    = "beta"
