resource "hcloud_network" "private_network" {
  ip_range = "10.0.0.0/16"
  name     = "main-network"
  labels = {
    "environment" : var.environment
    "provider" : "hcloud"
    "resource" : "hcloud_network"
  }
}

resource "hcloud_network_subnet" "private_subnet" {
  network_id   = hcloud_network.private_network.id
  type         = "cloud"
  ip_range     = "10.0.0.0/24"
  network_zone = "eu-central"
}
