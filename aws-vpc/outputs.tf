output "vpc_arn" {
  value = aws_vpc.this.arn
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "vpc_default_security_group_id" {
  value = aws_vpc.this.default_security_group_id 
}

output "vpc_default_route_table_id" {
  value = aws_vpc.this.default_route_table_id 
}