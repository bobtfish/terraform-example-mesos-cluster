resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "${var.deploy_ssh_pubkey}"
}

module "vpc" {
    source = "github.com/bobtfish/terraform-vpc-nat"
    account = "${var.account}"
    region = "${var.region}"
    networkprefix = "${var.networkprefix}"
    aws_key_name = "${aws_key_pair.deployer.key_name}"
    aws_key_location = "../id_rsa"
}

output "nat_public_ip" {
    value = "${module.vpc.nat_public_ip}"
}

