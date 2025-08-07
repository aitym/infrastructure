resource "hcloud_placement_group" "spread_placement_group" {
  name = "spread-placement-group"
  type = "spread"
  labels = {
    "environment" : var.environment
    "provider" : "hcloud"
    "resource" : "hcloud_placement_group"
  }
}

resource "hcloud_server" "landing_server" {
  count       = var.servers_count
  name        = "landing-server-${count.index}-${local.timestamp_suffix}"
  server_type = "cpx21"
  image       = "alma-10"
  location    = var.location
  user_data   = templatefile("templates/user_data.yml.tpl", { ansible_user_name : var.ansible_user_name, public_key : file(local.public_ssh_key_location) })
  ssh_keys    = [hcloud_ssh_key.main_ssh_key.id]
  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
  labels = {
    "environment" : var.environment
    "provider" : "hcloud"
    "resource" : "hcloud_server"
    "firewall" : "ssh_access"
  }
  # firewall_ids = [hcloud_firewall.ssh_access_firewall.id]
  firewall_ids = []
  network {
    network_id = hcloud_network.private_network.id
    alias_ips  = []
  }
  placement_group_id = hcloud_placement_group.spread_placement_group.id
  depends_on = [
    hcloud_network_subnet.private_subnet,
  ]
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]
    connection {
      type        = "ssh"
      user        = var.ansible_user_name
      private_key = file(local.private_ssh_key_location)
      host        = self.ipv4_address
    }
  }
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ${var.ansible_user_name} -i ${self.ipv4_address}, --private-key ${local.private_ssh_key_location} ../ansible/playbook/landing.yml"
  }
  lifecycle {
    create_before_destroy = true
  }
}
