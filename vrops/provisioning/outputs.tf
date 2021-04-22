output "sg_name" {
  description = "sg_name"
  value   = aws_security_group.vrops-sg.name
}
output "aws_instances_id" {
   description = "AWS instance ids provisioned"
   value   = tolist(aws_instance.vrops-node.*.id)
}
output "aws_instances_private_ips" {
   description = "AWS instance ids provisioned"
   value   = tolist(aws_instance.vrops-node.*.private_ip)
}

output "elb_dns_name" {
    value = aws_elb.vrops_elb.dns_name
}

output "elb_zone_id" {
   value = aws_elb.vrops_elb.zone_id
}
