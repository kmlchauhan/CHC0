provider "aws" {
  region = "us-west-2"
  profile = "697867080916"
}

terraform {
  backend "s3" {
    encrypt        = "true"
    dynamodb_table = "tf-state-lock"
    bucket         = "g4-terraform-remote-states"
    key            = "tf/aws/vpcs/qa3/smfws"
    region         = "us-west-1"
    profile        = "697867080916"
  }
}

# SMFWS HOST IN AWS (EC2)
module "smfws_aws_11" {
  source              = "../../../../tf_base/aws/aws_smfws"
  host_env_name       = "qa3"
  host_ami            = "ami-84fcddfc"
  host_num            = "11"
  host_ec2_schedule   = "running"
  host_jira           = "DEVOPS-5416"
  host_vpc            = "vpc-0e14b106124151294"
  host_vpc_subnet     = "subnet-064dac583851269cc"
  host_avail_zone     = "us-west-2a"
  host_aws_key        = "devops_ppl10_us_west_2"
}