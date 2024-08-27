output "web_lb_endpoint" {
  value = module.web-tier.lb_endpoint
}

output "app_lb_endpoint" {
  value = module.app-tier.lb_endpoint
}

output "database_endpoint" {
  value = module.db-tier.db_endpoint
}