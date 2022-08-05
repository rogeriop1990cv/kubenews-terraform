terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

provider "digitalocean" {
  token =var.do_token
  # "dop_v1_fadcf3613466903dc2887d57bd0cfe4906aed4049706c0587451b4036cad0400"
}

resource "digitalocean_kubernetes_cluster" "k8s_aula" {
  name = var.k8s_name
  # "k8s-aula"
  region = var.region
  # "nyc1"
  version = "1.23.9-do.0"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-4gb"
    node_count = 3
  }
}

variable "do_token" {}
variable "k8s_name" {}
variable "region" {}

output "kube_endpoint" {
  value = digitalocean_kubernetes_cluster.k8s_aula.endpoint
}

resource "local_file" "kube_config" {
    content  = digitalocean_kubernetes_cluster.k8s_aula.kube_config.0.raw_config
    filename = "kube_config.yaml"
}
