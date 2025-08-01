node_name   = "client-a"
datacenter  = "dc1"
data_dir    = "./client-alpha/data"
bind_addr   = "127.0.10.2"
client_addr = "127.0.10.2"
server      = false

retry_join = ["127.0.10.1:8303"]
segment    = "alpha"
