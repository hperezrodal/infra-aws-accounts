aws_region     = "us-east-1"
aws_account_id = "<complete>"
project_name   = "mycompany"
vpc_cidr       = "10.1.0.0/16"
private_subnet_cidrs = [
  "10.1.1.0/20",
  "10.1.16.0/20",
  "10.1.32.0/20"
]
public_subnet_cidrs = [
  "10.101.48.0/20",
  "10.101.64.0/20",
  "10.101.80.0/20"
]
availability_zones = ["us-east-1a", "us-east-1b"]

eks_min_size       = 2
eks_max_size       = 5
eks_desired_size   = 2
eks_instance_types = ["t3.medium"]

tags = {
  Environment = "qa"
  ManagedBy   = "terraform"
}

hosted_zone_id = "<complete>"
domain_name    = "mycompany.link"

source_account_id="<complete>"