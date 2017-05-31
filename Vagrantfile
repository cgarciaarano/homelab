# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
IP_ADDRESS = "192.168.200.134"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "packer/build/ubuntu-16.04.2-server-amd64-docker.box"
  config.vm.provision "shell", path: "vagrant_provision.sh"
  config.vm.network "public_network", ip: "#{IP_ADDRESS}"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.provider "virtualbox" do |vb| 
     # Use VBoxManage to customize the VM. For example to change name, memory and DNS resolution:
     vb.name = "devlab"
     vb.customize ["modifyvm", :id, "--memory", "768"]
       vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
end
