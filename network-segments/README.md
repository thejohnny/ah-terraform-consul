# Consul Network Segments

These files were used to demonstrate network segments using a Consul dev server conifgured with a pair of network segments. There are two Consul client agent configurations which can only participate in there designate segments.

You will need to provide a Consul Enterprise license to run the demo locally. During the demo, the CONSUL_LICENSE environment variable was set with the license string as the value.

## Start the server

`consul agent -dev -config-file=server-segments.hcl`

## Start alpha client

`consul agent -config=client-alpha`

## Start alpha client

`consul agent -config=client-beta`

## Check membership

Running `consul members` should produce something similar to the following:

```
consul members
Node               Address          Status  Type    Build       Protocol  DC   Partition  Segment
johnny-DHQDJ6WQ7V  127.0.10.1:8301  alive   server  1.20.6+ent  2         dc1  default    <all>
client-a           127.0.10.2:8301  alive   client  1.20.6+ent  2         dc1  default    alpha
client-b           127.0.10.3:8301  alive   client  1.20.6+ent  2         dc1  default    beta

```