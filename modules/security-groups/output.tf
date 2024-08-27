output "websg_sec_id" {
  value = aws_security_group.web_sg.id
}

output "weblbsg_sec_id" {
  value = aws_security_group.web_lb_sg.id
}

output "appsg_sec_id" {
  value = aws_security_group.app_sg.id
}

output "applbsg_sec_id" {
  value = aws_security_group.app_lb_sg.id
}

output "db_sec_id" {
  value = aws_security_group.db_sg.id
}