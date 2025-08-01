resource "hcloud_ssh_key" "main_ssh_key" {
  name       = "main-ssh-key"
  public_key = file(local.public_ssh_key_location)
  labels = {
    "environment" : var.environment
    "provider" : "hcloud"
    "resource" : "hcloud_ssh_key"
  }
}

resource "hcloud_firewall" "ssh_access_firewall" {
  count = 0
  name = "ssh-access-firewall"
  labels = {
    "environment" : var.environment
    "provider" : "hcloud"
    "resource" : "hcloud_firewall"
    "firewall" : "ssh_access"
  }
  dynamic "rule" {
    for_each = ["22", "80", "443"]
    content {
      direction  = "in"
      protocol   = "tcp"
      port       = rule.value
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  }
  rule {
    direction       = "out"
    protocol        = "tcp"
    port            = "any"
    destination_ips = ["0.0.0.0/0", "::/0"]
  }
  apply_to {
    label_selector = "environment=${var.environment},provider=hcloud,firewall=ssh_access"
  }
}
