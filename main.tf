# TODO: firewall

resource "hcloud_network" "private_network" {
  name     = "${var.name}-network"
  ip_range = var.ip_range
}

resource "hcloud_network_subnet" "network" {
  network_id   = hcloud_network.private_network.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = var.ip_range
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "nomad" {
  name       = "nomad-hcloud-key-pair"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "nomad_key" {
  content         = tls_private_key.pk.private_key_pem
  filename        = "./nomad-hcloud-key-pair.pem"
  file_permission = "0400"
}

resource "random_uuid" "nomad_id" {
}

resource "random_uuid" "nomad_token" {
}

resource "hcloud_server" "server" {
  count       = var.server_count
  name        = "${var.name}-server-${count.index}"
  server_type = var.server_instance_type
  location    = var.region
  image       = var.snapshot_image
  ssh_keys    = [hcloud_ssh_key.nomad.id]
  depends_on  = [hcloud_network_subnet.network]

  network {
    network_id = hcloud_network.private_network.id
    ip         = "10.0.0.${10 + (count.index + 1)}"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  user_data = templatefile("${path.module}/shared/data-scripts/user-data-server.sh", {
    server_count              = var.server_count
    region                    = var.region
    cloud_env                 = "hcloud"
    retry_join                = jsonencode(var.retry_join)
    nomad_binary              = var.nomad_binary
    nomad_consul_token_id     = random_uuid.nomad_id.result
    nomad_consul_token_secret = random_uuid.nomad_token.result
  })
}

resource "hcloud_server" "client" {
  count       = var.client_count
  name        = "${var.name}-client-${count.index}"
  server_type = var.client_instance_type
  location    = var.region
  image       = var.snapshot_image
  ssh_keys    = [hcloud_ssh_key.nomad.id]
  depends_on  = [hcloud_network_subnet.network]

  network {
    network_id = hcloud_network.private_network.id
    ip         = "10.0.0.${10 + var.server_count + (count.index + 1)}"
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  user_data = templatefile("${path.module}/shared/data-scripts/user-data-client.sh", {
    region                    = var.region
    cloud_env                 = "hcloud"
    retry_join                = jsonencode(var.retry_join)
    nomad_binary              = var.nomad_binary
    nomad_consul_token_id     = random_uuid.nomad_id.result
    nomad_consul_token_secret = random_uuid.nomad_token.result
  })
}
