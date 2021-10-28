# aws_terraform_vpc
![AWS](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/AWS_Simple_Icons_Virtual_Private_Cloud.svg/40px-AWS_Simple_Icons_Virtual_Private_Cloud.svg.png)


A terraform AWS VPC Terraform module.

## Usage

Terraform `base.tf`

```
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "${var.default_region}"
}

module "vpc" {
  source = "github.com/redopsbay/aws_terraform_vpc"

  environment     = "dev"
  private_subnets = ["10.10.10.0/24"]
  public_subnets  = ["10.10.20.0/24"]
  vpc_cidr        = "10.10.0.0/16"
}

resource "aws_security_group" "web_application" {
  vpc_id      = module.vpc.aws_vpc.vpc_id
  name        = "${var.environment}-webapp1-asia"
  description = "Allow SSH from bastion host and web app access to public"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${module.vpc.vpc_cidr}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "https"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["${module.vpc.vpc_cidr}"]
  }

  tags = {
    Name = "${var.environment}-webapp-asia"
  }
}

resource "aws_security_group" "bastion" {
  vpc_id      = module.vpc.vpc_id
  name        = "${var.environment}-bastion-host"
  description = "Allow SSH to bastion host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-bastion-sg"
  }
}

resource "aws_instance" "bastion" {
  ami                         = "ap-southeast-1"
  instance_type               = "t2.micro""
  key_name                    = var.privatekey_name
  monitoring                  = true
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true
  tags = {
    Name = "${var.environment}-bastion"
  }
}



resource "aws_instance" "webapp-1" {
  ami                         = "ap-southeast-1"
  instance_type               = "t2.micro"
  key_name                    = var.privatekey_name
  vpc_security_group_ids      = ["${aws_security_group.web_application.id}"]
  subnet_id                   = aws_subnet.public[0].id
  associate_public_ip_address = true

  tags = {
    Name = "${var.environment}-webapp-asia"
  }

  /* Valid values: prod, dev, staging */

  count = "${var.environment == "prod" ? 4 : 2}"
}

```

## Variables

Terraform `base.tfvars`
```
default_region = "ap-southeast-1"
environment = "dev"
privatekey_name = "devops_key"
```

Terraform Variable declaration `vars.tf`
```
variable "region" {
  type        = string
  description = "AWS Region"
  default     = "ap-southeast-1"
}

variable "environment" {
  type        = string
  description = "Infrastructure Environment"
  default     = "dev"
}

variable "privatekey_name" {
  type        = string
  description = "SSH Key that are available in you're AWS account."
  default     = "devops_key"
}


variable "ami" {
  type = map(string)
  default = {
    "ap-southeast-1" = "ami-0fed77069cd5a6d6c"
    "ap-south-1"     = "ami-0567e0d2b4b2169ae"
    "ap-southeast-2" = "ami-02389157cb8d3e3b5"
  }

  description = "AMIs for Nearest PH Regions."
}
```

Check [interface.tf](https://github.com/redopsbay/aws_terraform_vpc/blob/master/interface.tf) to manipulate declared variables.