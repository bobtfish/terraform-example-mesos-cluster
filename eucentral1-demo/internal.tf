module "ami" {
  source = "github.com/bobtfish/terraform-ubuntu-ami"
  region = "${var.region}"
  distribution = "trusty"
  architecture = "amd64"
  virttype = "hvm"
  storagetype = "instance-store"
}

resource "aws_launch_configuration" "consul" {
    image_id = "${module.ami.ami_id}"
    instance_type = "m3.large"
    security_groups = ["${terraform_state.vpc.output.security_group_allow_all}"]
    associate_public_ip_address = false
    user_data = "#cloud-config\napt_sources:\n - source: \"deb https://get.docker.io/ubuntu docker main\"\n   keyid: 36A1D7869245C8950F966E92D8576A8BA88D21E9\n - source: \"deb http://apt.puppetlabs.com trusty main\"\n   keyid: 1054b7a24bd6ec30\napt_upgrade: true\nlocale: en_US.UTF-8\npackages:\n - lxc-docker\n - puppet\n - git\nruncmd:\n - [ /usr/bin/docker, run, --net=host, -d, --name, consul, -p, \"8500:8500\", -p, \"8600:8600/udp\", bobtfish/consul-awsnycast, -dc, ${var.region}-${var.account}, -retry-join, 10.255.255.253  ]\n - [ /usr/bin/docker, run, --rm, -v, \"/usr/local/bin:/target\", jpetazzo/nsenter ]\n"
    key_name = "${terraform_state.vpc.output.admin_key_name}"
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "consul" {
  availability_zones = ["${terraform_state.vpc.output.primary-az}", "${terraform_state.vpc.output.secondary-az}"]
  name = "consul"
  max_size = "${var.size}"
  min_size = "${var.size}"
  desired_capacity = "${var.size}"
  health_check_grace_period = 120
  health_check_type = "EC2"
  force_delete = true
  launch_configuration = "${aws_launch_configuration.consul.name}"
  vpc_zone_identifier = [ "${terraform_state.vpc.output.primary-az-ephemeralsubnet}", "${terraform_state.vpc.output.secondary-az-ephemeralsubnet}" ]
  tag {
    key = "Name"
    value = "consul"
    propagate_at_launch = true
  }
}

