module "vpc" {
    source = "github.com/bobtfish/terraform-vpc-nat"
    account = "${var.account}"
    region = "${var.region}"
    networkprefix = "${var.networkprefix}"
    aws_key_name = "${aws_key_pair.admin.key_name}"
    aws_key_location = "../id_rsa"
}

