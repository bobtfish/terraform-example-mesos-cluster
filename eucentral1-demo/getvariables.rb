#!/usr/bin/ruby
require 'json'
require 'net/https'

def get(text)
  uri = URI.parse(text)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)
  response.body.gsub('$', '\$')
end

kubernates_master_ud = get 'https://raw.githubusercontent.com/GoogleCloudPlatform/kubernetes/master/docs/getting-started-guides/aws/cloud-configs/master.yaml'
kubernates_node_ud = get 'https://raw.githubusercontent.com/GoogleCloudPlatform/kubernetes/master/docs/getting-started-guides/aws/cloud-configs/node.yaml'

output = {
  "variable" => {
    "deploy_ssh_pubkey" => {
      "description" => "The Deployment ssh pub key",
      "default" => IO.read(File.dirname(__FILE__) + '/../id_rsa.pub').chomp
    },
    "etcd_discovery_uri" => {
      "description" => "An etcd cluster discovery token",
      "default" => IO.read(File.dirname(__FILE__) + '/../etcd_discovery_uri').chomp
    },
    "kubernates-master-user-data" => {
      "default" => kubernates_master_ud
    },
    "kubernates-node-user-data" => {
      "default" => kubernates_node_ud
    },
  }
}

puts JSON.pretty_generate(output)

