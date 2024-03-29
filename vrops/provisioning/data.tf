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
data "aws_route53_zone" "vrops" {
  name         = var.hosted_zone
}
data "aws_security_groups" "eso-ovpn-pub" {
  filter {
    name   = "group-name"
    values = ["eso-ovpn-pub"]
  }
}
data "aws_subnet_ids" "all_subnets" {
  vpc_id = lookup(var.vpc_id,var.env)
  tags = {
    Name ="*trusted-platform-*"
  }
}
data "aws_subnet" subnet {
  for_each = data.aws_subnet_ids.az_subnets.ids
  id = each.value
}
data "aws_subnet_ids" "az_subnets" {
  vpc_id = lookup(var.vpc_id,var.env)
  tags = {
    Name ="*trusted-platform-${var.availability_zones}"
  }
}
data "aws_ami" "vrops_ami"{
  owners = [var.owner_id]
  filter {
    name = "image-id"
    values = [var.ami_id]
  }
}
data "aws_secretsmanager_secret" "pendo_key" {
  name = "/vrops/shared/pendoApiKey"
}
data "aws_secretsmanager_secret_version" "pendo_value" {
  secret_id = data.aws_secretsmanager_secret.pendo_key.id
}
data "aws_secretsmanager_secret" "ses_creds" {
  name = "/vrops/shared/ses/vropshostedplugin"
}
data "aws_secretsmanager_secret_version" "ses_username" {
  secret_id = data.aws_secretsmanager_secret.ses_creds.id
}
