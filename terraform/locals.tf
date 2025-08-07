locals {
  timestamp_suffix         = formatdate("YYYYMMDDhhmmss", timestamp())
  public_ssh_key_location  = "secrets/id_rsa.pub"
  private_ssh_key_location = "secrets/id_rsa"
}
