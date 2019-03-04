provider "aws" {
  region = "${var.location}"
  profile = "${lookup(var.extra_vars, "aws_profile")}"
}

data "aws_security_group" "ec2_groups" {
  count = "${var.fw_options["count"]}"
  vpc_id = "${lookup(var.network_info, "vpc")}"
  tags {
    Name = "${lookup(var.fw_options, "rule${count.index}")}"
  }
}

data "template_file" "init-userdata" {
  template = "${file("ansible/user-data.yml.tp")}"

  vars {
    hostname = "${var.name}"
    fqdn = "${local.dns_host_name}"
    dns_search = "${local.dns_domain_name}"
  }
}

resource "aws_volume_attachment" "ec2_ebs_att" {
  count = "${lookup(var.extra_disks, "num_disks")}"
  device_name = "${lookup(var.extra_disks, "disk${count.index}.name")}"
  volume_id   = "${element(aws_ebs_volume.ec2_extra_disk.*.id, count.index)}"
  instance_id = "${aws_instance.ec2_instance.id}"
}

resource "aws_instance" "ec2_instance" {
  instance_type = "${var.type}.${var.size}"

  user_data = "${lookup(var.extra_vars, "user_data")}"

  subnet_id = "${lookup(var.network_info, "vpc_subnet")}"
  ami = "${var.os_image}"
  key_name = "${lookup(var.extra_vars, "aws_key")}"

  associate_public_ip_address = "${lookup(var.extra_vars, "public_ip_address")}"
  disable_api_termination = "${lookup(var.extra_vars, "no_api_termination")}"
  iam_instance_profile = "${lookup(var.extra_vars, "iam_role", "")}"
  instance_initiated_shutdown_behavior = "${lookup(var.extra_vars, "shutdown_type")}"
  vpc_security_group_ids = ["${data.aws_security_group.ec2_groups.*.id}"]

  root_block_device = {
    volume_type = "${lookup(var.root_disk, "type")}"
    volume_size = "${lookup(var.root_disk, "size")}"
    delete_on_termination = "${lookup(var.root_disk, "delete")}"
  }

  volume_tags = {
    Name = "${var.name}_${lookup(var.network_info, "sub_env", "nosub")}_rbd_tf"
    terraform_managed = "True"
  }

  tags = "${merge(
    var.tags,
    var.ec2_internal_tags,
    map("Name", format("%s", var.name))
  )}"

  user_data = "${data.template_file.init-userdata.rendered}"

  provisioner "remote-exec" {
    inline = "sudo service network restart"

    connection {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("/home/ad4e/Downloads/devops_ppl10_us_west_2.pem")}"
    }
  }

  provisioner "local-exec" {
    command = "./${lookup(var.post_provision, "base")} -l ${aws_instance.ec2_instance.private_ip} -b ${lookup(var.post_provision, "branch")} -u ${lookup(var.post_provision, "user")} -e ${lookup(var.network_info, "sub_env")} -a '${lookup(var.post_provision, "extra_args")}'"
    working_dir = "${lookup(var.post_provision, "path")}"
  }

}

resource "aws_ebs_volume" "ec2_extra_disk" {
  count = "${lookup(var.extra_disks, "num_disks")}"
  availability_zone = "${lookup(var.extra_disks, "disk${count.index}.zone")}"
  size = "${lookup(var.extra_disks, "disk${count.index}.size")}"
  type = "${lookup(var.extra_disks, "disk${count.index}.type")}"
  skip_destroy = true
  tags {
      Name = "${var.name}_extra_disk${count.index}_tf"
  }
}


data "aws_route53_zone" "zone_found" {
  name         = "${lookup(var.tags, "dom_is_zone", false) ? lookup(var.network_info, "domain") : format("%s.%s", lookup(var.network_info, "sub_env"),lookup(var.network_info, "domain"))}"
  private_zone = true
}

locals {
  dns_host_name = "${lower("${var.name}.${lookup(var.network_info, "sub_env")}.${lookup(var.network_info, "domain")}")}"
  dns_domain_name = "${lower("${format("%s.%s", lookup(var.network_info, "sub_env"),lookup(var.network_info, "domain"))}")}"
  dns_fqdn = "${local.dns_host_name}.${local.dns_domain_name}"
}

resource "aws_route53_record" "ec2_host_dns" {
  zone_id = "${data.aws_route53_zone.zone_found.zone_id}"
  name    = "${local.dns_host_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.ec2_instance.private_ip}"]
}

resource "aws_route53_record" "ec2_dns_cnames" {
  zone_id = "${data.aws_route53_zone.zone_found.zone_id}"
  count = "${lookup(var.network_info, "num_cname")}"
  name    = "${lookup(var.network_info, "cname.${count.index}")}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${local.dns_host_name}"]
}


variable ec2_internal_tags {
  type = "map"
  description = "EC2 tags that we always add."
  default = {
    login_name = "ec2-user"
    terraform_managed = "True"
  }
}


output "Intance_IP" {
  value =  "Intance: ${var.name}  IP: ${aws_instance.ec2_instance.private_ip}"
}