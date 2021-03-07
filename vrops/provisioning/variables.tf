variable "env" {                      # POD FQDN Group Name
  type = string
  default="dev"
}

variable "ami_id" {                   # AMI ID
  type = string
  default="ami-0a36eb8fadc976275"
}

variable "cluster_size" {              # Flavor T-shirt compute size
  type = string
  default="extrasmall"
}

variable "pod_fqdn_name" {              # POD FQDN Group Name
  type = string
}

variable "ha_enabled" {            # HA Enabled Flag
  default = false                  # 
}

variable "ca_enabled" {            # CA Enabled Flag
  default = false                # 
}

variable "pendo_enabled" {            # Pendo Enabled Flag
  default = false                # 
}

variable "node_count" {            # Node Count
  type    = number
  default = 1                   # 
}

variable "sc_environment" {            # SC_Environment
  type    = string
  default = "sc_env"

}

variable "pool_instance_id" {            # Pool Instance Id
  type    = string
  default = "sc_env"

}

variable "resource_id" {            # Resource Id 
  type    = string
  default = "sc_env"

}

variable "admin_password" {            # Admin Password
  type    = string
  default = "sc_env"

}

variable "availability_zones" {            # Availability zone
  type    = string
  default = "us-west-2a"

}

variable "witness_availability_zone" {            # Witness Availability zone 
  type    = string
  default = "sc_env"
}

variable "vpc_id" {
  type = map 
  default = {
    "dev" = "vpc-02608d56dec071559"
    "stage" = ""
    "prod" = ""
  }
}

variable "instance_size" {
  type = map 
  default = {
    "extrasmall" = "m5.large"
    "small" = "m5.xlarge"
    "medium" = "m5.2xlarge"
    "large" = "m5.4xlarge"
    "extralarge" = "m5.8xlarge"
  }
}

variable "disk_size" {
  type = map 
  default = {
    "extrasmall" = 250
    "small" = 300
    "medium" = 600
    "large" = 1200
    "extralarge" = 1200
  }
}

variable "tcp_ports" {
  description = "tcp ports for security group"
  type        = list(number)
  default     = [ 22, 80, 5432, 8080, 7001, 6061, 8888, 10000, 9042, 5433 ,443, 12016]
}

variable "udp_ports" {
  description = "udp ports for security group"
  type        = list(number)
  default     = [8888]
}

variable "gw_tcp_ports" {
  description = "gw_tcp_ports for security group"
  type        = list(number)
  default     = [80, 8080, 443]
}

variable "sc_tcp_ports" {
  description = "sc_tcp_ports for security group"
  type        = list(number)
  default     = [80, 8080, 443]
}

variable "oc_tcp_ports" {
  description = "oc_tcp_ports for security group"
  type        = list(number)
  default     = ["22","80", "8080", "443"]
}

variable "jenkins_ssm_ports" {
  description = "jenkins_ssm_ports for security group"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "xcenter_ports" {
  description = "xcenter_ports for security group"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "ovpn_ports" {
  description = "ovpn_ports for security group"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "vrops_sre_org_ports" {
  description = "vrops_sre_org_ports for security group"
  type        = list(number)
  default     = [80, 443]
}

variable "range_from_tcp_ports" {
  description = "tcp ports for security group"
  type        = list(number)
  default     = [10002,20002]
}

variable "range_to_tcp_ports" {
  description = "tcp ports for security group"
  type        = list(number)
  default     = [10010,20010]
}

variable "ssh_key_name" {
  description = "ssh key pair"
  type = string
  default = "vropskey"
}


variable "ssh_arn" {
  description = "ssh arn"
  type = string
  default = "arn:aws:acm:us-west-2:000954396075:certificate/7a6ae625-841e-4a6c-b3b1-8fde058e8439"
}

variable "dns_record_type" {
  description = "dns record type"
  type = string
  default = "A"
}
