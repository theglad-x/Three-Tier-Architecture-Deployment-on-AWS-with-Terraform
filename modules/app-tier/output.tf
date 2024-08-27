output "app_asg" {
  value = aws_autoscaling_group.app_asg
}

output "lb_dns" {
  value = aws_lb.app_lb.dns_name
}

output "lb_endpoint" {
  value = aws_lb.app_lb.dns_name
}

output "lb_target_group_name" {
  value = aws_lb_target_group.app_lbtg.name
}

output "app_sns_name" {
    value = aws_sns_topic.app_sns.name
}

output "lb_tg" {
  value = aws_lb_target_group.app_lbtg.arn
}