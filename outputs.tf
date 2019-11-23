# outputs.tf

output "alb_hostname" {
  value = aws_alb.main.dns_name
}

# output "ElasticSearch_Endpoint" {
#   value = aws_elasticsearch_domain.default.endpoint
# }

# output "ElasticSearch_Kibana_Endpoint" {
#   value = aws_elasticsearch_domain.default.kibana_endpoint
# }

# output "subnet_id" {
#    value = aws_subnet.private[0].id
# }

# output "security_group_ids" {
#    value = "${aws_security_group.alb.id},${aws_security_group.ecs.id},${aws_security_group.rds.id}"
# }
