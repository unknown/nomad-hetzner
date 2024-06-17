variable "region" {
  description = "The Hetzner location to deploy to."
}

variable "network_zone" {
  description = "The Hetzner network zone to create a subnet in."
}


variable "snapshot_image" {
  description = "The snapshot image to use for the server and client machines. Output from the Packer build process."
}

variable "name" {
  description = "Prefix used to name various infrastructure components. Alphanumeric characters only."
  default     = "nomad"
}

variable "ip_range" {
  description = "Range to allocate IPs from for Hetzner private network."
  default     = "10.0.0.0/24"
}

variable "retry_join" {
  description = "Used by Consul to automatically form a cluster."
  default     = ["10.0.0.11", "10.0.0.12", "10.0.0.13"]
  type        = list(string)
}

variable "allowlist_ip" {
  description = "IP to allow access for the security groups (set 0.0.0.0/0 for world)"
  default     = "0.0.0.0/0"
}

variable "server_instance_type" {
  description = "The Hetzner instance type to use for servers."
  default     = "cpx11"
}

variable "client_instance_type" {
  description = "The Hetzner instance type to use for clients."
  default     = "cpx11"
}

variable "server_count" {
  description = "The number of servers to provision."
  default     = "3"
}

variable "client_count" {
  description = "The number of clients to provision."
  default     = "3"
}

variable "nomad_binary" {
  description = "URL of a zip file containing a nomad executable to replace the Nomad binaries in the AMI with. Example: https://releases.hashicorp.com/nomad/0.10.0/nomad_0.10.0_linux_amd64.zip"
  default     = ""
}
