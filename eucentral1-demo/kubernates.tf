/*
module "kubernates" {
    etcd_discovery_uri = "${var.etcd_discovery_uri}"
    source = "github.com/bobtfish/terraform-aws-coreos-kubernates-cluster"
    master-instance_type = "m3.large"
    node-instance_type = "m3.large"
    region = "${var.region}"
    coreos-channel = "beta"
    sg = "${terraform_remote_state.vpc.output.security_group_allow_all}"
    admin_key_name = "${terraform_remote_state.vpc.output.admin_key_name}"
    primary-az = "${terraform_remote_state.vpc.output.primary-az}"
    secondary-az = "${terraform_remote_state.vpc.output.secondary-az}"
    master-cluster-size = 3
    node-cluster-size = 3
    primary-az-subnet = "${terraform_remote_state.vpc.output.primary-az-ephemeralsubnet}"
    secondary-az-subnet = "${terraform_remote_state.vpc.output.secondary-az-ephemeralsubnet}"
}
*/
