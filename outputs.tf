# outputs.tf

output "alb_hostname" {
  value = aws_alb.main.dns_name
}

# output "subnet_id" {
#    value = aws_subnet.private[0].id
# }

# output "security_group_ids" {
#    value = "${aws_security_group.alb.id},${aws_security_group.ecs.id},${aws_security_group.rds.id}"
# }
