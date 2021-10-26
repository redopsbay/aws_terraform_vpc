
/* Vars Here! */

variable "region" {
  type = string
  description = "Prepared AWS Region."
}

variable "environment" {
  type = string
  description = "i.e, dev, staging, prod."
  default = "dev"
}

variable "privatekey_name" {
  type = string
  description = "AWS SSH Key Pair."
  default = "ops"
}

variable "vpc_cidr" {
  type = string
  description = "CIDR of my VPC."
}

variable "public_subnets" {
  type = list(string)
  default     = []
  description = "Public Subnets To Populate."
}

variable "private_subnets" {
  type = list(string)
  default     = []
  description = "List Of Private Subnets."
}

variable "ami" {
  type = map(string)
  default = {
    "ap-southeast-1" = "ami-0fed77069cd5a6d6c"
    "ap-south-1" = "ami-0567e0d2b4b2169ae"
    "ap-southeast-2" = "ami-02389157cb8d3e3b5"
  }

  description = "AMIs for Nearest PH Regions."
}

variable "instance_type" {
  type = string
  default     = "t2.micro"
  description = "Prepared Instance Type."
}

variable "bastion_instance_type" {
  type = string
  default     = "t2.micro"
  description = "Bastion host instance type."
}

variable "bastion_ami" {
  type = map(string)
  default = {
    "ap-southeast-1" = "ami-0fed77069cd5a6d6c"
    "ap-south-1" = "ami-0567e0d2b4b2169ae"
    "ap-southeast-2" = "ami-02389157cb8d3e3b5"
  }

  description = "The bastion host AMIs."
}

variable "enable_dns_hostnames" {
  type = bool
  description = "True, If private DNS should be enabled on VPC"
  default     = true
}

variable "enable_dns_support" {
  type = bool
  description = "True, If private DNS should be enabled on VPC"
  default     = true
}

variable "map_public_ip_on_launch" {
  type = bool
  description = "False, When Public IP Should not be assigned automatically."
  default     = true
}

/* Outputs Here! */

output "vpc_id" {
  value = aws_vpc.environment.id
}

output "vpc_cidr" {
  value = aws_vpc.environment.cidr_block
}

output "bastion_host_dns" {
  value = aws_instance.bastion.public_dns
}

output "bastion_host_ip" {
  value = aws_instance.bastion.public_ip
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  value = aws_route_table.private[*].id
}

output "default_security_group_id" {
  value = aws_vpc.environment.default_security_group_id
}

