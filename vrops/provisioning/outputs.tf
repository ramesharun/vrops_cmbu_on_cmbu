# Security Group Outputs 

output "sg_id" {
  description = "sg_id"
  value   = aws_security_group.vrops-sg.id
 }

output "sg_arn" {
  description = "sg_arn"
  value   = aws_security_group.vrops-sg.arn
 }

output "sg_name" {
  description = "sg_name"
  value   = aws_security_group.vrops-sg.name
 }

output "sg_vpc_id" {
  description = "sg_vpc_id"
  value   = aws_security_group.vrops-sg.vpc_id
}

output "sg_owner_id" {
  description = "sg_owner_id"
  value   = aws_security_group.vrops-sg.owner_id
}

output "sg_description" {
  description = "sg_description"
  value   = aws_security_group.vrops-sg.description
}

output "sg_revoke_rules_on_delete" {
  description = "sg_revoke_rules_on_delete"
  value   = aws_security_group.vrops-sg.revoke_rules_on_delete
}

 output "aws_instances_id" {
   description = "AWS instance ids provisioned"
   value   = tolist(aws_instance.vrops-node.*.id)
 }

output "aws_az_subnet_id" {
   value = element(tolist(data.aws_subnet_ids.az_subnets.ids),0)
 }

 output "aws_all_subnet_id" {
   value = tolist(data.aws_subnet_ids.all_subnets.ids)
 }

 output "elb_dns_name" {
   value = aws_elb.vrops_elb.dns_name
 }

 output "elb_zone_id" {
   value = aws_elb.vrops_elb.zone_id
 }
