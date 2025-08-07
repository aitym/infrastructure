output "landing_server_public_ips" {
  value = hcloud_server.landing_server[*].ipv4_address
}

output "landing_server_names" {
  value = hcloud_server.landing_server[*].name
}
