# Nomad Hetzner

Set up a Nomad cluster on Hetzner. This repo is based off of HashiCorp's [Cluster Setup](https://developer.hashicorp.com/nomad/tutorials/cluster-setup) tutorials but adapted for Hetzner.

## Getting started

These instructions are adapted from HashiCorp's [aforementioned tutorials](https://developer.hashicorp.com/nomad/tutorials/cluster-setup), which contain more detailed instructions explanations.

1. `mv variables.hcl.example variables.hcl`
2. Update the `region` variable in `variables.hcl`
3. `packer init image.pkr.hcl`
4. `packer build image.pkr.hcl -var-file=variables.hcl`
5. Update the `snapshot_image` and `network_zone` variables (`snapshot_image` should be the output of the Packer build)
6. `terraform init`
7. `terraform apply -var-file=variables.hcl`
8. `./post-setup.sh`
9. `export NOMAD_ADDR=$(terraform output -raw lb_address_consul_nomad):4646 && export NOMAD_TOKEN=$(cat nomad.token)`
