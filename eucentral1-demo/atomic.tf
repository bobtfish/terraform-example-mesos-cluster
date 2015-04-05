/*
module "atomic_ami" {
      source = "github.com/terraform-community-modules/tf_aws_fedora_ami"
      region = "eu-central-1"
      distribution = "atomic"
      virttype = "hvm"
    }

    resource "aws_instance" "atomic" {
      ami = "${module.atomic_ami.ami_id}"
      instance_type = "m3.large"
      subnet_id ="${terraform_remote_state.vpc.output.primary-az-ephemeralsubnet}"
      key_name = "${terraform_remote_state.vpc.output.admin_key_name}"
    }
*/
