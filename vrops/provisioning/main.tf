
locals {

  port_ranges = {
    from_range_1 = 10002
    from_range_2 = 20002
    to_range_1 = 10010
    to_range_2 = 20010  
  }

}
locals {
  timestamp = timestamp()
  elb_postfix = replace(local.timestamp, "/[- TZ:]/", "")
  elb_prefix = "vrops"
  elb_middle = element(split(".",var.pod_fqdn_name),0)
  elb_name = join("-",[local.elb_prefix,local.elb_middle,local.elb_postfix])
}
locals {

    sleeptime = "1800s"

}
resource "aws_security_group" "vrops-sg" {
  name        = "vrops-SG-${var.pod_fqdn_name}"                                        
  vpc_id      = lookup(var.vpc_id,var.env)                                                             
  description = "vrops security group"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {                                                                               
    service_name  = "VROPS",
    product = "vrops",
    cluster = "vrops-saas",
    Name = "vrops-SG-${var.pod_fqdn_name}"
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
resource "random_password" "AdminPassword" {
  length            = 10
  special           = true
  min_special       = 1
  min_numeric       = 3
  min_upper         = 2
  override_special  = "@"
}
resource "random_password" "RootPassword" {
  length           = 10
  special          = true
  min_special       = 1
  min_numeric       = 2
  min_upper         = 2
  override_special = "_%@"
}

resource "aws_secretsmanager_secret" "admin-pass" {
  name = join("/",["/vrops",var.sc_environment,"vropsAdminCred",var.pod_fqdn_name])
}

resource "aws_secretsmanager_secret_version" "admin-pass-val" {
  secret_id     = aws_secretsmanager_secret.admin-pass.id
  secret_string = random_password.AdminPassword.result
}
resource "aws_secretsmanager_secret" "root-pass" {
  name = join("/",["/vrops",var.sc_environment,"vropsRootCred",var.pod_fqdn_name])
}

resource "aws_secretsmanager_secret_version" "root-pass-val" {
  secret_id     = aws_secretsmanager_secret.root-pass.id
  secret_string = random_password.RootPassword.result
}
resource "aws_instance" "vrops-node" {
      count                   = var.node_count
      ami                     = var.ami_id
      instance_type           = lookup(var.instance_size,var.cluster_size) 
      subnet_id               = element(tolist(data.aws_subnet_ids.az_subnets.ids),0)
      vpc_security_group_ids  = [aws_security_group.vrops-sg.id]
      iam_instance_profile    = "vrops.app.profile"
      key_name                = var.ssh_key_name
      user_data               = templatefile("${path.module}/scripts/cloudInit.sh", {root_password=random_password.RootPassword.result,admin_password=random_password.AdminPassword.result,url=var.ssmagenturl,file_path=var.ssmfilepath,ami_buildtype=data.aws_ami.vrops_ami.tags.BuildType,ami_changelist=data.aws_ami.vrops_ami.tags.Changelist,cp_bucket_base_url=var.cp_bucket_base_url,csp_ref_link=var.csp_ref_link,sre_org_id=var.sre_org_id,base_url=var.base_url,pendo_key=data.aws_secretsmanager_secret_version.pendo_value.secret_string,license_key=var.vra_license_key,seshost=var.seshost,sesusername=jsondecode(data.aws_secretsmanager_secret_version.ses_username.secret_string).username,sespassword=jsondecode(data.aws_secretsmanager_secret_version.ses_username.secret_string).password,vrli_hostname=var.vrli_hostname,aws_env=var.env,node_type=var.cluster_size,csp_url=var.csp_url,srehub_refreshtoken=var.srehub_refreshtoken,orgId=var.sre_org_id,scurl=var.sc_customer_url})

      ebs_block_device {
        device_name = "/dev/sdb"
        volume_size = lookup(var.disk_size,var.cluster_size) 
        volume_type = "gp2"
        delete_on_termination = true
      }
      ebs_block_device {
        device_name = "/dev/sdc"
        volume_size = 8
        volume_type = "gp2"
        delete_on_termination = true
       }
      ebs_optimized = true
      metadata_options {
        http_endpoint = "enabled"
        http_tokens   = "required"

      }
      tags = {
          product = "vrops"
          role = "app"
          Name = "VROPS from ami ${var.ami_id}"
      }
     
}
resource "aws_elb" "vrops_elb" {
    name               = length(local.elb_name) > 32 ? substr(local.elb_name,0,31) : local.elb_name
    subnets = tolist(data.aws_subnet_ids.all_subnets.ids)

    listener {
      instance_port     = 80
      instance_protocol = "http"
      lb_port           = 80
      lb_protocol       = "http"
    }

    listener {
      instance_port      = 443
      instance_protocol  = "https"
      lb_port            = 443
      lb_protocol        = "https"
      ssl_certificate_id = var.ssh_arn
    }

    health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 3
      target              = "HTTPS:443/suite-api/api/deployment/node/status?services=api&services=adminui&services=ui"
      interval            = 30
    }

    instances             = tolist(aws_instance.vrops-node.*.id)
    idle_timeout          = 410
    security_groups       = [aws_security_group.vrops-sg.id]
    internal              = true

    tags = {
      product = "vrops"
        role = "app"
        sc_environment = var.sc_environment
    }
}
resource "aws_app_cookie_stickiness_policy" "appcookiepolicy" {
  name          = "vrops-app-cookie-policy"
  load_balancer = aws_elb.vrops_elb.name
  lb_port       = 80
  cookie_name   = "JSESSIONID"
}
resource "aws_load_balancer_listener_policy" "vrops-elb-listener-policies-443" {
  load_balancer_name = aws_elb.vrops_elb.name
  load_balancer_port = 443

  policy_names = [
   aws_app_cookie_stickiness_policy.appcookiepolicy.name,
  ]
}
resource "aws_load_balancer_listener_policy" "vrops-elb-listener-policies-80" {
  load_balancer_name = aws_elb.vrops_elb.name
  load_balancer_port = 80

  policy_names = [
    aws_app_cookie_stickiness_policy.appcookiepolicy.name,
  ]
}
resource "aws_route53_record" "dnsrecord" {
  zone_id = data.aws_route53_zone.vrops.id
  name    = var.pod_fqdn_name
  type    = var.dns_record_type
  alias {
    name                   = aws_elb.vrops_elb.dns_name
    zone_id                = aws_elb.vrops_elb.zone_id
    evaluate_target_health = true
    }   
}
resource "null_resource" "vrops_cluster_config"{
    provisioner "local-exec" {
       command = "sleep 2100" 
    }  
}
