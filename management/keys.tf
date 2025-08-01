resource "consul_keys" "app" {
  key {
    path  = "hello"
    value = "World!"
  }
}