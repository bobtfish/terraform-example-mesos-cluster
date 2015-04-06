resource "aws_key_pair" "admin" {
  key_name = "mesos-deployer-key"
  public_key = "${var.deploy_ssh_pubkey}"
}

