module "ami" {
  source = "github.com/bobtfish/terraform-ubuntu-ami"
  region = "${var.region}"
  distribution = "trusty"
  architecture = "amd64"
  virttype = "hvm"
  storagetype = "instance-store"
}

resource "terraform_state" "vpc" {
    backend = "http"
    config {
        address = "https://raw.githubusercontent.com/bobtfish/terraform-example-vpc/master/eucentral1-demo/terraform.tfstate"
    }
}

resource "aws_instance" "internal-other" {
    ami = "${module.ami.ami_id}"
    instance_type = "m3.large"
    tags {
        Name = "internal-other"
    }
    key_name = "${terraform_state.vpc.output.admin_key_name}"
    subnet_id = "${terraform_state.vpc.output.primary-az-dedicatedsubnet}"
    private_ip = "${terraform_state.vpc.output.networkprefix}.1.5"
    security_groups = ["${terraform_state.vpc.output.security_group_allow_all}"]
    user_data = "#cloud-config\napt_sources:\n - source: \"deb https://get.docker.io/ubuntu docker main\"\n   keyid: 36A1D7869245C8950F966E92D8576A8BA88D21E9\n - source: \"deb http://apt.puppetlabs.com trusty main\"\n   keyid: 1054b7a24bd6ec30\napt_upgrade: true\nlocale: en_US.UTF-8\npackages:\n - lxc-docker\n - puppet\n - git\nruncmd:\n - [ /usr/bin/docker, run, -d, --name, consul, -p, \"8500:8500\", -p, \"8600:8600/udp\", fhalim/consul ]\n - [ /usr/bin/docker, run, --rm, -v, \"/usr/local/bin:/target\", jpetazzo/nsenter ]\n"
}

