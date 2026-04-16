output "app_url" {
  value = "http://localhost:${var.app_port}"
}

output "db_info" {
  value = "PostgreSQL running on port ${var.db_port}"
}