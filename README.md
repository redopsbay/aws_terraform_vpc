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

module "vpc" {
  source = "github.com/redopsbay/aws_terraform_vpc"

  environment = "development"
  key_name = "default_key"
  private_subnets = ["10.10.10.0/24"]
  public_subnets = ["10.10.20.0/24"]
  vpc_cidr = "10.10.0.0/16"
}

resource "aws_security_group" "web_application" {
  vpc_id      = aws_vpc.environment.id
  name        = "${var.environment}-webapp1-asia"
  description = "Allow SSH from bastion host"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.bastion.ipv4_address}"]
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
    cidr_blocks = ["${aws_instance.bastion.ipv4_address}"]
  }

  tags = {
    Name = "${var.environment}-webapp-asia"
  }
}

resource "aws_instance" "webapp-1" {
  ami                         = var.bastion_ami[var.region]
  instance_type               = var.bastion_instance_type
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
region = "ap-southeast-1"
environment = "dev"
privatekey_name = "devops_key"
```

Check [interface.tf](https://github.com/redopsbay/aws_terraform_vpc/blob/master/interface.tf) to manipulate declared variables.