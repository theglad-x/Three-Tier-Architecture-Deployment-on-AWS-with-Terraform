output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "web_public_subnets" {
  value = aws_subnet.web_public_subnets.*.id
}

output "app_private_subnets" {
  value = aws_subnet.app_private_subnets.*.id
}

output "db_private_subnets" {
  value = aws_subnet.db_private_subnets.*.id
}

output "db_subnet_group" {
  value = aws_db_subnet_group.db_subnet_group.*.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_subnet_group.*.name
}