# aws_terraform_vpc
![AWS](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/AWS_Simple_Icons_Virtual_Private_Cloud.svg/40px-AWS_Simple_Icons_Virtual_Private_Cloud.svg.png)


A terraform AWS VPC Terraform module.

## Usage

```
module "vpc" {
  source = "github.com/redopsbay/aws_terraform_vpc"

  environment = "development"
  key_name = "default_key"
  private_subnets = ["10.0.10.0/24"]
  public_subnets = ["10.0.20.0/24"]
  vpc_cidr = "10.0.0.0/16"
}
```

Check [interfaces.tf](https://github.com/redopsbay/aws_terraform_vpc/blob/master/interface.tf) to manipulate declared variables.







