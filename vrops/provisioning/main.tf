
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
      security_group_id = aws_security_group.vrops-sg.id
      source_security_group_id = aws_security_group.vrops-sg.id                           
}




