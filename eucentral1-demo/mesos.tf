module "mesos" {
    source                      = "github.com/bobtfish/tf_aws_mesos"
    adminlbs                    = "1"
    lbs                         = "2"
    masters                     = "3"
    slaves                      = "5"
    region = "${var.region}"
    admin_iprange = "${var.admin_iprange}"
    admin_key_name = "${aws_key_pair.admin.key_name}"
    availability_zones = "${module.vpc.primary-az}"
    private_subnet_ids = "${module.vpc.primary-az-ephemeralsubnet}"
    public_subnet_ids = "${module.vpc.primary-az-frontsubnet}"
    domain = "${var.domain}"
    vpc_iprange = "${module.vpc.cidr_block}"
    vpc_id = "${module.vpc.id}"
    discovery_instance_profile = "describe-instances"
}

