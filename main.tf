terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///Users/mikerudat/.orbstack/run/docker.sock"
}

# create networks
resource "docker_network" "terraform_deploy_fusionauth_db_net" {
  name   = "terraform_deploy_fusionauth_db_net"
  driver = "bridge"
}

# create volumes
resource "docker_volume" "terraform_deploy_fusionauth_db_data" {
  name = "terraform_deploy_fusionauth_db_data"
}
resource "docker_volume" "terraform_deploy_fusionauth_fusionauth_config" {
  name = "terraform_deploy_fusionauth_fusionauth_config"
}

# find the postgres image
resource "docker_image" "db" {
  name         = "postgres:16.0-bookworm"
  keep_locally = true
}

# find the fusionauth image
resource "docker_image" "fusionauth" {
  name         = "fusionauth/fusionauth-app:latest"
  keep_locally = true
}

# start postgres container
resource "docker_container" "db" {
  image = docker_image.db.image_id
  name  = "db"
  env = [
    "PGDATA=${var.pgdata}",
    "POSTGRES_USER=${var.postgres_user}",
    "POSTGRES_PASSWORD=${var.postgres_password}"
  ]
  healthcheck {
    test     = ["CMD-SHELL", "pg_isready -U postgres"]
    interval = "5s"
    timeout  = "5s"
    retries  = 5
  }
  networks_advanced {
    name = docker_network.terraform_deploy_fusionauth_db_net.name
  }
  restart = "unless-stopped"
  volumes {
    volume_name    = docker_volume.terraform_deploy_fusionauth_db_data.name
    container_path = var.pgdata
  }
  ports {
    internal = 5432
    external = 5432
  }
  wait = true
}

# start fusionauth container
resource "docker_container" "fusionauth" {
  image      = docker_image.fusionauth.image_id
  name       = "fusionauth"
  depends_on = [docker_container.db]
  env = [
    "DATABASE_URL=jdbc:postgresql://db:5432/fusionauth",
    "DATABASE_ROOT_USERNAME=${var.postgres_user}",
    "DATABASE_ROOT_PASSWORD=${var.postgres_password}",
    "DATABASE_USERNAME=${var.fusionauth_database_username}",
    "DATABASE_PASSWORD=${var.fusionauth_database_password}",
    "FUSIONAUTH_APP_MEMORY=${var.fusionauth_app_memory}",
    "FUSIONAUTH_APP_RUNTIME_MODE=${var.fusionauth_app_runtime_mode}",
    "FUSIONAUTH_APP_URL=http://fusionauth:9011",
    "SEARCH_TYPE=database"
  ]
  networks_advanced {
    name = docker_network.terraform_deploy_fusionauth_db_net.name
  }
  restart = "unless-stopped"
  volumes {
    volume_name    = docker_volume.terraform_deploy_fusionauth_db_data.name
    container_path = var.pgdata
  }
  ports {
    internal = 9011
    external = 9011
  }
  ports {
    internal = 9013
    external = 9013
  }
}