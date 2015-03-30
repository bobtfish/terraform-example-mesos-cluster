resource "terraform_state" "vpc" {
    backend = "http"
    config {
        address = "https://raw.githubusercontent.com/${var.github_username}/terraform-example-vpc/master/${replace(var.region, \"-\", \"\")}-${var.account}/terraform.tfstate"
    }
}

output "nat_public_ip" {
    value = "${terraform_state.vpc.output.nat_public_ip}"
}
