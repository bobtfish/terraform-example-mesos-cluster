output "domain" {
  value = "${var.domain}"
}
output "marathon_api" {
  value = "${module.mesos.marathon_api}"
}
output "mesos_api" {
  value = "${module.mesos.mesos_api}"
}
