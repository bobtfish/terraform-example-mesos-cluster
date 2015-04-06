module "mesos" {
    source                      = "github.com/bobtfish/tf_aws_mesos"
    adminlbs                    = "1"
    lbs                         = "2"
    masters                     = "3"
    slaves                      = "5"
    region = "${var.region}"
    admin_key_name = "${terraform_remote_state.vpc.output.admin_key_name}"
    private_subnet_ids = "${terraform_remote_state.vpc.output.primary-az-ephemeralsubnet}"
    public_subnet_ids = "${terraform_remote_state.vpc.output.primary-az-frontsubnet}"
    domain = "mesos.notanisp.net"
    vpc_id = "${terraform_remote_state.vpc.output.id}"
    ssh_private_key_file = "../id_rsa"
    discovery_instance_profile = "temp-admin"
}

output "master_public_ips" {
  value = "${module.mesos.master_public_ips}"
}

output "marathon_api" {
  value = "${module.mesos.marathon_api}"
}

