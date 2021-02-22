provider "aws" {
    version = "2.69.0"
    region="us-west-2"
}

variable "instance_type" {
  description = "AWS instance type"
  default     = "t2.micro"
}

variable "myTag" {
  description = "cmbu_on_cmbu_vrops_provisioning"
  default = "cmbu_on_cmbu_vrops_provisioning"
}

variable "nodes" {
  default = "1"
}


variable "ami" {
  default = "ami-0a36eb8fadc976275"
}

resource "aws_instance" "machine1" {
    count         = "${var.nodes}"
    ami           = "${var.ami}"
    instance_type = "${var.instance_type}"
    availability_zone = "us-west-2a"
    tags = {
      "type" = var.myTag
    }
}
