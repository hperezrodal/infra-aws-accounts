aws_region     = "us-east-1"
aws_account_id = "<complete>"
project_name   = "mycompany"
vpc_cidr       = "10.2.0.0/16"
private_subnet_cidrs = [
  "10.2.1.0/20",
  "10.2.16.0/20",
  "10.2.32.0/20"
]
public_subnet_cidrs = [
  "10.2.48.0/20",
  "10.2.64.0/20",
  "10.2.80.0/20"
]
availability_zones = ["us-east-1a", "us-east-1b"]

eks_min_size       = 2
eks_max_size       = 5
eks_desired_size   = 2
eks_instance_types = ["t3.medium"]

hosted_zone_id = "Z02168321ANVO1Q6JG3VZ"
domain_name    = "mycompany.link"

source_account_id="<complete>"
