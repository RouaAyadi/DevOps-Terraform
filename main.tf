terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = ">= 2.0.0"
    }
  }
}

provider "docker" {}

# -------------------------
# PostgreSQL Image
# -------------------------
resource "docker_image" "postgres" {
  name = "postgres:latest"
}

# -------------------------
# PostgreSQL Container
# -------------------------
resource "docker_container" "postgres" {
  name  = "postgres_container"
  image = docker_image.postgres.image_id

  ports {
    internal = 5432
    external = var.db_port
  }

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]
}

# -------------------------
# Application Image
# -------------------------
resource "docker_image" "app" {
  name = "nginx_app_image"

  build {
    context    = "."
    dockerfile = "Dockerfile_app"
  }
}

# -------------------------
# Application Container
# -------------------------
resource "docker_container" "app" {
  name  = "app_container"
  image = docker_image.app.image_id

  ports {
    internal = 80
    external = var.app_port
  }

  depends_on = [docker_container.postgres]
}