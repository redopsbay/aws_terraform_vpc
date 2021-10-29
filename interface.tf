
/* Vars Here! */

variable "region" {
  type        = string
  description = "Prepared AWS Region."
  default     = "ap-southeast-1"
}

variable "environment" {
  type        = string
  description = "i.e, dev, prod."
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR of my VPC."
}

variable "public_subnets" {
  type        = list(string)
  default     = []
  description = "Public Subnets To Populate."
}

variable "private_subnets" {
  type        = list(string)
  default     = []
  description = "List Of Private Subnets."
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "True, If private DNS should be enabled on VPC"
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "True, If private DNS should be enabled on VPC"
  default     = true
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "False, When Public IP Should not be assigned automatically."
  default     = true
}

/* API Outputs Here! */

output "vpc_id" {
  value = aws_vpc.environment.id
}

output "vpc_cidr" {
  value = aws_vpc.environment.cidr_block
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

