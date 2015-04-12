module "mesos" {
    source                      = "github.com/bobtfish/tf_aws_mesos"
    adminlbs                    = "1"
    lbs                         = "2"
    masters                     = "3"
    slaves                      = "5"
    region = "${var.region}"
    admin_iprange = "${var.admin_iprange}"
    admin_key_name = "${aws_key_pair.admin.key_name}"
    private_subnet_ids = "${module.vpc.ephemeralsubnets}"
    public_subnet_ids = "${module.vpc.frontsubnets}"
    domain = "${var.domain}"
    vpc_iprange = "${module.vpc.cidr_block}"
    vpc_id = "${module.vpc.id}"
    discovery_instance_profile = "describe-instances"
}

