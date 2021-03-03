

locals {

  port_ranges = {
    from_range_1 = 10002
    from_range_2 = 20002
    to_range_1 = 10010
    to_range_2 = 20010  
  }
}

data "aws_security_groups" "vrops-sc-sg" {
  filter {
    name   = "group-name"
    values = ["vrops-sc-sg"]
  }

  filter {
    name   = "vpc-id"
    values = [lookup(var.vpc_id,var.env)]
  }
}

data "aws_security_groups" "vrops-gw-sg" {
  filter {
    name   = "group-name"
    values = ["vrops-gw-sg"]
  }

  filter {
    name   = "vpc-id"
    values = [lookup(var.vpc_id,var.env)  ]
  }
}

data "aws_security_groups" "vrops-oc-sg" {
  filter {
    name   = "group-name"
    values = ["vrops-oc-sg"]
  }

  filter {
    name   = "vpc-id"
    values = [lookup(var.vpc_id,var.env)  ]
  }
}


data "aws_security_groups" "ssmagent-worker-sg" {
  filter {
    name   = "group-name"
    values = ["ssmagent-worker-sg"]
  }

  filter {
    name   = "vpc-id"
    values = [lookup(var.vpc_id,var.env)  ]
  }
}

data "aws_security_groups" "xcenter-ec2-sg" {
  filter {
    name   = "group-name"
    values = ["xcenter-ec2-sg"]
  }

  filter {
    name   = "vpc-id"
    values = [lookup(var.vpc_id,var.env)  ]
  }
}

data "aws_security_groups" "vrops-sre-sg" {
  filter {
    name   = "group-name"
    values = ["vrops-sre-sg"]
  }

  filter {
    name   = "vpc-id"
    values = [lookup(var.vpc_id,var.env)  ]
  }
}

data "aws_security_groups" "eso-ovpn-pub" {
  filter {
    name   = "group-name"
    values = ["eso-ovpn-pub"]
  }
}

resource "aws_security_group" "vrops-sg" {
  name        = "vrops-SG-${var.pod_fqdn_name}"                                        
  vpc_id      = lookup(var.vpc_id,var.env)                                                             
  description = "vrops security group"

  tags = {                                                                               
    service_name  = "VROPS",
    product = "vrops",
    cluster = "vrops-saas",
    Name = "vrops-SG-${var.pod_fqdn_name}"
  }
  
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group_rule" "ingress_rules_tcp_self" {  
      count = length(var.tcp_ports)
      from_port = var.tcp_ports[count.index]
      to_port = var.tcp_ports[count.index] 
      protocol = "tcp"
      type = "ingress"
      description = "Allow inbound traffic to ${var.tcp_ports[count.index]} port"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = aws_security_group.vrops-sg.id                           
}

resource "aws_security_group_rule" "ingress_rules_tcp_self_range_1" {  
      from_port = local.port_ranges.from_range_1
      to_port =  local.port_ranges.to_range_1 
      protocol = "tcp"
      type = "ingress"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = aws_security_group.vrops-sg.id                     
}

resource "aws_security_group_rule" "ingress_rules_tcp_self_range_2" {  
      from_port = local.port_ranges.from_range_2
      to_port =  local.port_ranges.to_range_2 
      protocol = "tcp"
      type = "ingress"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = aws_security_group.vrops-sg.id                     
}

resource "aws_security_group_rule" "ingress_rules_udp_self" {  
      count = length(var.udp_ports)
      from_port = var.udp_ports[count.index]
      to_port = var.udp_ports[count.index] 
      protocol = "udp"
      type = "ingress"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = aws_security_group.vrops-sg.id                           
}

resource "aws_security_group_rule" "ingress_rules_udp_self_range_1" {  
      from_port = local.port_ranges.from_range_1
      to_port =  local.port_ranges.to_range_1 
      protocol = "udp"
      type = "ingress"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = aws_security_group.vrops-sg.id                     
}

resource "aws_security_group_rule" "ingress_rules_udp_self_range_2" {  
      from_port = local.port_ranges.from_range_2
      to_port =  local.port_ranges.to_range_2 
      protocol = "udp"
      type = "ingress"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = aws_security_group.vrops-sg.id                     
}

resource "aws_security_group_rule" "ingress_rules_gw" {  
      count = length(var.gw_tcp_ports)
      from_port = var.gw_tcp_ports[count.index]
      to_port = var.gw_tcp_ports[count.index] 
      protocol = "tcp"
      type = "ingress"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = data.aws_security_groups.vrops-gw-sg.ids[0]
}

resource "aws_security_group_rule" "ingress_rules_sc" {  
      count = length(var.sc_tcp_ports)
      from_port = var.sc_tcp_ports[count.index]
      to_port = var.sc_tcp_ports[count.index] 
      protocol = "tcp"
      type = "ingress"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = data.aws_security_groups.vrops-sc-sg.ids[0]
}

resource "aws_security_group_rule" "ingress_rules_oc" {  
      count = length(var.oc_tcp_ports)
      from_port = var.oc_tcp_ports[count.index]
      to_port = var.oc_tcp_ports[count.index] 
      protocol = "tcp"
      type = "ingress"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = data.aws_security_groups.vrops-oc-sg.ids[0]
}

resource "aws_security_group_rule" "ingress_rules_tcp_jenkins_ssm" {  
      count = length(var.jenkins_ssm_ports)
      from_port = var.jenkins_ssm_ports[count.index]
      to_port = var.jenkins_ssm_ports[count.index] 
      protocol = "tcp"
      type = "ingress"
      description = "Allow inbound traffic to ${var.jenkins_ssm_ports[count.index]} port"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = data.aws_security_groups.ssmagent-worker-sg.ids[0]                          
}

resource "aws_security_group_rule" "ingress_rules_tcp_xcenter" {  
      count = length(var.xcenter_ports)
      from_port = var.xcenter_ports[count.index]
      to_port = var.xcenter_ports[count.index] 
      protocol = "tcp"
      type = "ingress"
      description = "Allow inbound traffic to ${var.xcenter_ports[count.index]} port"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = data.aws_security_groups.xcenter-ec2-sg.ids[0]                          
}

resource "aws_security_group_rule" "ingress_rules_tcp_ovpn" {  
      count = length(var.ovpn_ports)
      from_port = var.ovpn_ports[count.index]
      to_port = var.ovpn_ports[count.index] 
      protocol = "tcp"
      type = "ingress"
      description = "Allow inbound traffic to ${var.ovpn_ports[count.index]} port"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = data.aws_security_groups.eso-ovpn-pub.ids[0]                          
}

resource "aws_security_group_rule" "ingress_rules_tcp_vrops_sre" {  
      count = length(var.vrops_sre_org_ports)
      from_port = var.vrops_sre_org_ports[count.index]
      to_port = var.vrops_sre_org_ports[count.index] 
      protocol = "tcp"
      type = "ingress"
      description = "Allow inbound traffic to ${var.vrops_sre_org_ports[count.index]} port"
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = data.aws_security_groups.vrops-sre-sg.ids[0]                          
}


