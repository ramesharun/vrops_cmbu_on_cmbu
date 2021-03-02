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

variable "podFQDNName" {              # POD FQDN Group Name
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
  type    = string
  default = "1"                    # 
}

variable "sc_environment" {            # SC_Environment
  type    = string

}

variable "pool_instance_id" {            # Pool Instance Id
  type    = string

}

variable "resource_id" {            # Resource Id 
  type    = string

}

variable "admin_password" {            # Admin Password
  type    = string

}

variable "availability_zones" {            # Availability zone
  type    = string

}

variable "witness_availability_zone" {            # Witness Availability zone 
  type    = string

