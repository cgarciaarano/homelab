
# Homelab

This project describes the infrastructure used as lab at home. The current setup is:

- Laptop with Windows 10, will be used for development using Vagrant and VirtualBox.
- Laptop with Ubuntu Server 16.04 and KVM
- Some Raspberries PI

The idea is to have an environment to experiment with infrastructure tools such as:

- Ansible/Puppet
- KVM/Ganeti
- Docker
- Kubernetes/OpenShift
- Vagrant/Terraform/Packer
- Consul/Etcd

# Development environment

This environment is on the Windows 10 laptop, using VirtualBox and Vagrant. A custom Vagrant box based on Alpine
is defined to run a Linux environment with Docker Engine and Docker Compose for development.

So you need [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and its Extension Pack, [Vagrant](http://www.vagrantup.com/downloads.html) and [Packer](https://www.packer.io/downloads.html).
I've used the following versions:

- VirtualBox 5.1.4
- Vagrant 1.9.2
- Packer 1.0.0

## Vagrant box creation

The creation of the box is inspired on this post, [Building a Vagrant Box from Start to Finish](https://blog.engineyard.com/2014/building-a-vagrant-box), but since it's a 
manual procedure, I'm using Packer so the box is defined as code, which the purpose of this project.

Alpine is the distribution I've selected because it's minimal. Since we're going to use Docker to run any binary, the dependencies will be handled by containers instead of the OS. The Alpine installation
is straightforward, just run `setup-alpine`, answer the questions and it's ready to go. To build it with Packer, it's needed to populate the `boot-command` with the answers to this script. There are some variables to change come settings in the virtual machine, as the keyboard layout, memory and nº of cores.

The relevant file is `alpine.json`. To build the box, just execute

```
packer build alpine.json
```

~~After trying to install Alpine on VirtualBox without success, due to weird network problems (can ping but can't wget, looks like a musl issue), I decide to skip this step.~~

## Vagrantfile

After trying to create the box, I'm going to use one from Atlas. 