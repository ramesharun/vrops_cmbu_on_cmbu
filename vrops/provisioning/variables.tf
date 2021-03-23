variable "env" {                      
  type = string
  default="dev"
}
variable "ami_id" {                   
  type = string
  default="ami-0d519fd2bc20076b8"
}
variable "cluster_size" {              
  type = string
  default="extrasmall"
}
variable "pod_fqdn_name" {              
  type = string
}
variable "ha_enabled" {            
  default = false                  
}
variable "ca_enabled" {            
  default = false                
}
variable "pendo_enabled" {            
  default = false                
}
variable "node_count" {             
  type    = number
  default = 1                   
}
variable "sc_environment" {            
  type    = string
  default = "sc_env"

}
variable "pool_instance_id" {             
  type    = string
  default = "sc_env"

}
variable "resource_id" {             
  type    = string
  default = "sc_env"

}
variable "admin_password" {             
  type    = string
  default = "Admin@123"

}
variable "availability_zones" {            
  type    = string
  default = "us-west-2a"

}
variable "witness_availability_zone" {            
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
variable "internet_allowed_port" {
  description = "enable traffic to 0.0.0.0/0"
  type        = number
  default     = 443
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
variable "dns_ttl" {
  type = string
  default = "30"
}
variable "hosted_zone" {
  default = "vrops-ops.com"
}
variable "ssmagenturl" {
  default = "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm"
}
variable "ssmfilepath" {
  default = "/tmp/amazon-ssm-agent.rpm"
}
variable "owner_id"{
  default = "993194883101"
}
variable "cp_bucket_base_url"{
  default = "https://s3-us-west-2.amazonaws.com/vrops-cloud-proxy-dev"
}
variable "csp_ref_link"{
  default = "/csp/gateway/slc/api/definitions/external/9c6ff0bd-7b55-46d8-95f9-18465a2c0661"
}
variable "sre_org_id"{
  default = "2bcf5fea-ae0d-4602-ba2f-8d2ed8d55b59"
}
variable "base_url" {
  default = "https://www.staging.symphony-dev.com/vrops-dev"
}
variable "marketplace" {
  default = "[{\"bucket_name\": \"vrops-cloud-marketplace-dev\", \"bucket_region\": \"us-west-2\", \"visibility\": \"0\"}]"
}
variable "vra_license_key"{
  default = "FN3A6-J8G10-R8CEQ-0WN0V-XH3W1"
}
variable "seshost"{
  default = "email-smtp.us-west-2.amazonaws.com"
}
variable "vrli_hostname"{
  default = "vrops-dmz.licf.vmware.com"
}
variable "csp_url"{
  default = "https://console-stg.cloud.vmware.com/"
}
variable "srehub_refreshtoken"{
  default = "HamHt6tI5x1aoVRspA77FQ67fOfV7d4E1eOjqG7kUCXmxYuOmJ0yXxsckIgdoath"
}
variable "sc_customer_url"{
  default = "https://api.staging.symphony-dev.com/vrops-dev/saas-controller/internal/tenants/customer-info/"
}
