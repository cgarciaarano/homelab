
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

I will cover the creation of the environment using these tools, and the creation of different services. 


# Contents

- [Development Environment](#development-environment)
  - [Packer](#packer)
  - [Vagrant](#vagrant)
- [Virtualization Server](#virtualization-server)
  - [PXE provisioning](#pxe-provisioning)
     - [Kickstart](#kickstart)
  - [Wake On LAN](#wake-on-lan)
  - [Provision](#provision)
    - [Ansible](#ansible)
    - [Puppet](#puppet)
  ...

# Development environment

This environment is on the Windows 10 laptop, using VirtualBox and Vagrant. A custom Vagrant box based on Ubuntu
is defined to run a Linux environment with Docker Engine and Docker Compose for development.

So you need [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and its Extension Pack, [Vagrant](http://www.vagrantup.com/downloads.html) and [Packer](https://www.packer.io/downloads.html).
I've used the following versions:

- VirtualBox 5.1.4
- Vagrant 1.9.2
- Packer 1.0.0

## Packer

Visit [`packer` section](packer/README.md)

## Vagrant

Once the vagrant box it's created, we can use it to run the development environment. The box has Docker and Docker Compose under Ubuntu, so the development will be done under containers without polluting the VM guest with dependencies. The intended usage is to use Compose to define and run the environment.

The VM is provisioned to avoid a nasty bug in VirtualBox Sahred Folders + Docker, which corrupts the filesystem within the containers. There's an alias `dev` for `docker-compose` that prepends some instructions to avoid this behaviour, so we can use docker-compose safely. For example, to start the environment we'll just run 

```
dev up
```

As we're going to use different applications, some of them network related, it's convenient to use bridged network adapters (`public_network` in vagrant), so the VM has its own IP address that can be accessed directly.

# Virtualization Server

We're going to use an old laptop as a virtualization server so we can create, provision and manage remote VMs. The first step it's to provision the server with the OS properly configured. There are many options to do this:

- Cobbler
- Foreman
- Puppet Razor
- PXE

## PXE provisioning
`pxe\`

PXE (Preboot eXecution Environment) is the low level approach. It uses TFTP, DHCP and HTTP. DHCP provides an option to define the TFTP server that has the execution environment needed, whereas HTTP is used to serve the media needed  for the OS installation. When a new host boots up with PXE active (booting from LAN), it expects to find options 66 (TFTP server address) and 67 (boot program file). It uses this values to load the  initial environment.

References: 
- http://blog.scottlowe.org/2015/05/20/fully-automated-ubuntu-install/
- https://www.hiroom2.com/2016/05/19/ubuntu-16-04-debian-8-run-pxe-boot-server-for-automated-install/

Before anything, we need to mount the ISO in the host running Docker. I haven't found a way to mount the ISO in a container in a reliable way. The ISO file is not included in the repository, so you have to download it first. From `pxe/` directory:

```
wget http://releases.ubuntu.com/16.04.2/ubuntu-16.04.2-server-amd64.iso -P xenial64/
sudo mount -t iso9660 xenial64/ubuntu-16.04.2-server-amd64.iso /media/cdrom/
```

I have hardcoded the public IP address of the host (See `Vagrantfile` and `xenial64/lixun-boot`. HINT: I moved IP related commands to kernel params). There should be a better way to do this, maybe templating or using DNS. **TODO**: Find a way to pass the bridged IP address to the script.

Check if the IP is correct and has connectivity to other hosts on the net. Then we run the services:

```
dev run
```

Then, boot up the machine and boot form network interface. DHCP should kick in and provide an IP with the proper options. **NOTE**: If you're testing this with a VM, be sure to give it at least 768 MB, because it needs it to install the `filesystem.squashfs`. If not, it returns a cryptic error message, stopping the installation. In the logs you will see someting like, `Cannot write to /tmp/live-install/filesystem.squashfs`.


### Kickstart

There's another possibility to automate the installation, using Kickstart. This comes from RedHat, but I'm not using it now.

## Wake On LAN
`wol/`

I added a feature to boot up the virtualization server. We need to configure the BIOS to allow WoL, and also configure the network card:

```
sudo ethtool -s enp0s3 wol g
```

To start the server, there's a Compose file that uses a Docker image with the package `awake` in `alpine`. We just need to pass the MAC address, already set in the Compose file.

```
dev up
```

Also, to save some space in my desktop I need to close the laptop, but this suspends it. To avoid this, we can configure `logind`. In `/etc/systemd/logind.conf` ensure:

```
 HandleLidSwitch=ignore
 ```

 and restart the service `sudo service systemd-logind restart`.

 **TODO** Set this configuration in provisioning.

 ## Provision

 We need to perform some configuration in the just created server, as the WoL feature. We have many options to do this, but we're going to use Ansible.

 ### Ansible

 We'll use this [development environment](ansible/README.md)

 ### Puppet