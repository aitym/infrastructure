resource "local_file" "ansible_inventory" {
  depends_on = [hcloud_server.landing_server]
  content    = join("\n", hcloud_server.landing_server[*].ipv4_address)
  filename   = "${path.module}/../ansible/inventory/${var.environment}/hosts.ini"
}
