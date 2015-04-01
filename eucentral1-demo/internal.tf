module "coreos_amitype" {
  source = "github.com/bobtfish/terraform-amitype"
  instance_type = "m3.large"
}

module "coreos_ami" {
  source = "github.com/bobtfish/terraform-coreos-ami"
  region = "${var.region}"
  channel = "beta"
  virttype = "${module.coreos_amitype.ami_type_prefer_hvm}"
}

resource "aws_launch_configuration" "kubernates-node" {
    image_id = "${module.coreos_ami.ami_id}"
    instance_type = "m3.large"
    security_groups = ["${terraform_state.vpc.output.security_group_allow_all}"]
    associate_public_ip_address = false
    user_data = "${var.kubernates-node-user-data}"
    key_name = "${terraform_state.vpc.output.admin_key_name}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "kubernates-node" {
  availability_zones = ["${terraform_state.vpc.output.primary-az}", "${terraform_state.vpc.output.secondary-az}"]
  name = "kubernates-node"
  max_size = "${var.size}"
  min_size = "${var.size}"
  desired_capacity = "${var.size}"
  health_check_grace_period = 120
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.kubernates-node.name}"
  vpc_zone_identifier = [ "${terraform_state.vpc.output.primary-az-ephemeralsubnet}", "${terraform_state.vpc.output.secondary-az-ephemeralsubnet}" ]
  tag {
    key = "Name"
    value = "kubernates-node"
    propagate_at_launch = true
  }
}

resource "aws_launch_configuration" "kubernates-master" {
    image_id = "${module.coreos_ami.ami_id}"
    instance_type = "m3.large"
    security_groups = ["${terraform_state.vpc.output.security_group_allow_all}"]
    associate_public_ip_address = false
    user_data = "${var.kubernates-master-user-data}"
    key_name = "${terraform_state.vpc.output.admin_key_name}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "kubernates-master" {
  availability_zones = ["${terraform_state.vpc.output.primary-az}", "${terraform_state.vpc.output.secondary-az}"]
  name = "kubernates-master"
  max_size = "${var.size}"
  min_size = "${var.size}"
  desired_capacity = "${var.size}"
  health_check_grace_period = 120
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.kubernates-master.name}"
  vpc_zone_identifier = [ "${terraform_state.vpc.output.primary-az-ephemeralsubnet}", "${terraform_state.vpc.output.secondary-az-ephemeralsubnet}" ]
  tag {
    key = "Name"
    value = "kubernates-master"
    propagate_at_launch = true
  }
}

