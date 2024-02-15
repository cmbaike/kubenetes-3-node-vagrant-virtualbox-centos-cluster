# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# Define the number of master and worker nodes
# If this number is changed, remember to update setup-hosts.sh script with the new hosts IP details in /etc/hosts of each VM.
NUM_WORKER_NODE = 2

IP_NW = "192.168.56."
MASTER_IP_START = 11
NODE_IP_START = 20

# Sets up hosts file and DNS
def setup_hosts(node)
  # Set up /etc/hosts
  node.vm.provision "setup-hosts", :type => "shell", :path => "centos/vagrant/setup-hosts.sh" do |s|
    s.args = ["eth1", node.vm.hostname]
  end
end

def setup_kubernetes(node)
  # Set up node
  node.vm.provision "setup-kubernetes", :type => "shell", :path => "centos/vagrant/setup-kubernetes.sh"
end

def create_cluster(node)
  # Set up node
  node.vm.provision "create-cluster", :type => "shell", :path => "centos/vagrant/create-cluster.sh"
end

# Runs provisioning steps that are required by masters and workers
def provision_kubernetes_node(node)
  # Setup host
  setup_hosts node
  # Setup kubernetes
  setup_kubernetes node
  # Setup cluster
  create_cluster node
  # Setup ssh
  node.vm.provision "setup-ssh", :type => "shell", :path => "centos/vagrant/ssh.sh"
  # Setup kubectl auto-complete
  node.vm.provision "auto-complete", :type => "shell", :path => "centos/vagrant/kubectl-autocomplete.sh"
end

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  # config.vm.box = "base"
  config.vm.box = "centos/7"
  config.vm.boot_timeout = 900

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Provision Master Nodes
  config.vm.define "controller-node" do |node|
    # Name shown in the GUI
    node.vm.provider "virtualbox" do |vb|
      vb.name = "controller-node"
      vb.memory = 2048
      vb.cpus = 2
    end
    node.vm.hostname = "controller-node"
    node.vm.network :private_network, ip: IP_NW + "#{MASTER_IP_START}"
    node.vm.network "forwarded_port", guest: 22, host: "#{2710}"
    provision_kubernetes_node node
    node.trigger.after :up do |trigger|
      trigger.info = "Copying join command to host"
      trigger.run = {path: "./centos/vagrant/copy-join-command-to-host.sh"}
      trigger.run_remote = {path: "./centos/vagrant/kubectl-autocomplete.sh"}
    end
  end


  #Provision Worker Nodes
  (1..NUM_WORKER_NODE).each do |i|
    config.vm.define "worker-node0#{i}" do |node|
      node.vm.provider "virtualbox" do |vb|
        vb.name = "worker-node0#{i}"
        vb.memory = 1024
        vb.cpus = 1
      end
      node.vm.hostname = "worker-node0#{i}"
      node.vm.network :private_network, ip: IP_NW + "#{NODE_IP_START + i}"
      node.vm.network "forwarded_port", guest: 22, host: "#{2720 + i}"
      provision_kubernetes_node node
      node.trigger.after :up do |trigger|
        trigger.info = "Join worker node to cluster"
        trigger.run_remote = {path: "./centos/vagrant/join-command.sh"}
        trigger.run_remote = {path: "./centos/vagrant/kubectl-autocomplete.sh"}
      end
    end
  end
 end