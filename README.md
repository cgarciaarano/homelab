
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

I will cover the setup of the environment using these tools, and the setup of different services. 


# Contents

- [Development Environment](#development-environment)
  - [Packer](#packer)
  - [Vagrant](#vagrant)
- [Virtualization Server](#virtualization-server)
  - [Bare-metal provision](#bare-metal-provision)
  - [Configuration management](#configuration-management)
    - [Ansible](#ansible)
    - [Puppet](#puppet)
  - [Wake On LAN](#wake-on-lan)
 
...

# Development environment

This environment is on the Windows 10 laptop, using VirtualBox and Vagrant. A custom Vagrant box based on Ubuntu is defined to run a Linux environment with Docker Engine and Docker Compose for development.

So you need [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and its Extension Pack, [Vagrant](http://www.vagrantup.com/downloads.html) and [Packer](https://www.packer.io/downloads.html).

I've used the following versions:

- VirtualBox 5.1.4
- Vagrant 1.9.2
- Packer 1.0.0

## Packer

We'll use `packer` to create a custom box for development.

Visit [`packer` section](packer/) for more details.

## Vagrant

Once the vagrant box it's created, we can use it to run the development environment. The box has Docker and Docker Compose under Ubuntu, so the development will be done under containers without polluting the VM guest with dependencies. The intended usage is to use Compose to define and run the environment.

The VM is provisioned to avoid a nasty bug in VirtualBox Sahred Folders + Docker, which corrupts the filesystem within the containers. There's an alias `dev` for `docker-compose` that prepends some instructions to avoid this behaviour, so we can use docker-compose safely. For example, to start the environment we'll just run 

```
dev up
```

As we're going to use different applications, some of them network related, it's convenient to use bridged network adapters (`public_network` in vagrant), so the VM has its own IP address that can be accessed directly.

# Virtualization Server

## Bare metal provision
	
We're going to use an old laptop as a virtualization server so we can create, provision and manage remote VMs. The first step it's to provision the server with the OS properly configured. There are many options to do a bare-metal provision:

- PXE
- Cobbler
- Foreman
- Puppet Razor

### PXE provisioning

PXE (Preboot eXecution Environment) is a low level approach. It uses TFTP, DHCP and HTTP to perform a bare-metal installation.

Visit the [`pxe` section](pxe/) for more details

## Configuration management

We need to perform some configuration in the just created server, as the WoL feature. We have many options to do this, but we're going to use Ansible.

### Ansible

Agentless configuration management tool.

Visit [`ansible`section](ansible/) for more details.

### Puppet

## Wake On LAN

I added a feature to boot up the virtualization server via LAN. 

Visit [`wol` section](wol/) for more details