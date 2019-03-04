module "smfws_aws" {
  source = "../aws_gen_host"
  name = "smfws${var.host_num}"
  type = "t2"
  size = "small"
  os_image = "${var.host_ami}"
  location = "${var.host_location}"

  network_info = {
    vpc        = "${var.host_vpc}"
    vpc_subnet = "${var.host_vpc_subnet}"
    sub_env    = "${var.host_env_name}${var.host_vpc_dns}"
    domain     = "${var.host_domain_name}"

    num_cname  = "0"
  }

  tags = {
    dom_is_zone         = "${var.host_dom_is_zone}"
    ec2_schedule        = "${var.host_ec2_schedule}"
    ansible_group       = "['symfonyall','smfws']"
    ansible_groups      = "${var.host_ansible_groups}"
    sub_env             = "${var.host_env_name}"
    domain              = "${var.host_domain_name}"
    prod                = "${var.host_prod}"
    owner               = "${var.host_owner}"
    working_environment = "${var.host_working_environment}"
    project             = "${var.host_project}"
    terraform           = "True"
    terraform_repo      = "${var.host_terraform_repo}"
    to_be_terminated    = "False"
    exp_date            = "${var.host_exp_date}"
    login_name          = "${var.host_login_name}"
    jira                = "${var.host_jira}"
    terraform_repo      = "${var.host_terraform_repo}"
  }

  extra_vars = {
      aws_profile = "697867080916"
      no_api_termination = "False"
      public_ip_address = "False"
      shutdown_type = "stop"
      aws_key = "${var.host_aws_key}"
      iam_role = "${var.host_iam_role}"
  }

  fw_options = "${var.host_fw_options}"

  root_disk  = "${var.host_root_disk}"

}