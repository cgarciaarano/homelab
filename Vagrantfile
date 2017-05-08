# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "build/alpine-3.5.2-x86_64.box"
  config.vm.provision "shell", path: "vagrant_provision.sh"
  config.vm.network :forwarded_port, guest: 22, host: 2222, id: 'ssh'

  config.vm.synced_folder ".", "/vagrant"
  config.vm.hostname = "dev-lab"
  config.vm.provider "virtualbox" do |vb| 
     # Use VBoxManage to customize the VM. For example to change name, memory and DNS resolution:
     vb.name = "devlab"
     vb.customize ["modifyvm", :id, "--memory", "512"]
	   vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
  end
  config.ssh.insert_key = false
end
