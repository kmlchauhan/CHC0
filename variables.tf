variable "host_env_name" {
  type        = "string"
  description = "The name of the host's environment."
}

variable "host_ami" {
  type        = "string"
  description = "The name of the host's ami."
}

variable "host_num" {
  type        = "string"
  description = "The number for the host name."
  default     = "11"
}

variable "host_domain_name" {
  type        = "string"
  description = "The name of the domain."
  default     = "aws.allegiantair.com"
}

variable "host_vpc" {
  type        = "string"
  description = "The vpc id where the host will be created."
  default     = "vpc-0e14b106124151294"
}

variable "host_vpc_subnet" {
  type        = "string"
  description = "The id of the vpc subnet for the host."
  default     = "subnet-064dac583851269cc"    # us-west-2a
}

variable "host_avail_zone" {
  type        = "string"
  description = "The name of the availability zone for the pod."
  default     = "us-west-2a"
}

variable "host_location" {
  type        = "string"
  description = "The name of the availability zone for the pod."
  default     = "us-west-2"
}

variable "host_ec2_schedule" {
  type        = "string"
  description = "Schedule to define the machine running hours"
  default     = "las-vegas-office-hours"
}

variable "host_owner" {
  type        = "string"
  description = "owner of the machine"
  default     = "itdevops@allegiantair.com"
}

variable "host_working_environment" {
  type        = "string"
  description = "working_environment of the machine"
  default     = "awsqa3"
}

variable "host_project" {
  type        = "string"
  description = "Identifies project that justifies resource."
  default     = "AWS-QA3"
}

variable "host_aws_key" {
  type        = "string"
  description = "key of the machine"
  default     = "aws_devops_master_us-west-2"
}

variable "host_terraform_repo" {
  type        = "string"
  description = "https to git repo + path were this resource is managed"
  default     = "ssh://git@git.allegiantair.com:7999/devops/terraform.git"
}

variable "host_login_name" {
  type        = "string"
  description = "Defines default shell user."
  default     = "ec2-user"
}

variable "host_exp_date" {
  type        = "string"
  description = "set to identify expiration date of resource. Set year to 9999 for instances that do not expire?"
  default     = "31 Dec, 9999"
}

variable "host_jira" {
  type        = "string"
  description = "JIRA info"
  default     = ""
}

variable "host_prod" {
  type        = "string"
  description = "Production flag"
  default     = "False"
}

variable "host_dom_is_zone" {
  type        = "string"
  description = "host is part of a domain"
  default     = "True"
}

variable "host_iam_role" {
  type        = "string"
  description = "iam role"
  default     = ""
}

variable "host_vpc_dns" {
  type        = "string"
  description = "Used for legacy domain naming scheme. (.vpc1)"
  default     = ""
}

variable "host_ansible_groups" {
  type        = "string"
  description = "Ansible group name"
  default     = "['symfonyall','smfws']"
}

variable "host_fw_options" {
  type = "map"
  default = {
    count = "2"
    rule0 = "all_ports"
    rule1 = "efs_access"
  }
}

variable "host_root_disk" {
  type = "map"
  default = {
    size = "15"        # Size in GB
    type = "gp2"       # Type of disk
    delete  = "True"   # Delete on termination
  }
}