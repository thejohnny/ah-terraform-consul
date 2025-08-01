bind_addr          = "127.0.10.1"
advertise_addr     = "127.0.10.1"

segments = [
   {
      name      = "alpha"
      bind      = "127.0.10.1"
      advertise = "127.0.10.1"
      port      = 8303
   },
   {
      name      = "beta"
      bind      = "127.0.20.1"
      advertise = "127.0.10.1"
      port      = 8304
   }
]