terraform {
  required_version = "~> 1.0.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.57.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.57.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.2.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.11.2"
    }
    tfe = {
      version = "~> 0.25.0"
    }
  }
}

provider "google" {
  credentials = base64decode(var.credentials_file)

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

provider "google-beta" {
  credentials = base64decode(var.credentials_file)

  project = var.project_id
  region  = var.region
  zone    = var.zone
}

data "google_client_config" "provider" {}

provider "helm" {
  kubernetes {
    host  = "https://${module.gke_cluster.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      module.gke_cluster.cluster_ca_certificate,
    )
  }
}
  
provider "kubernetes" {
  host  = "https://${module.gke_cluster.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    module.gke_cluster.cluster_ca_certificate,
  )
}

provider "kubectl" {
  host = "https://${module.gke_cluster.endpoint}"
  cluster_ca_certificate = base64decode(
    module.gke_cluster.cluster_ca_certificate,
  )
  token            = data.google_client_config.provider.access_token
  load_config_file = false
}

provider "tfe" {
  token = var.tfe_token
}
