
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

This environment is on the Windows 10 laptop, using VirtualBox and Vagrant. A custom Vagrant box based on Ubuntu
is defined to run a Linux environment with Docker Engine and Docker Compose for development.

So you need [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and its Extension Pack, [Vagrant](http://www.vagrantup.com/downloads.html) and [Packer](https://www.packer.io/downloads.html).
I've used the following versions:

- VirtualBox 5.1.4
- Vagrant 1.9.2
- Packer 1.0.0

## Vagrant box creation

The creation of the box is inspired on this post, [Building a Vagrant Box from Start to Finish](https://blog.engineyard.com/2014/building-a-vagrant-box), but since it's a 
manual procedure, I'm using Packer so the box is defined as code, which the purpose of this project.

Alpine is the distribution I selected in first place because it's minimal. Since we're going to use Docker to run any binary, the dependencies will be handled by containers instead of the OS. The Alpine installation is straightforward, just run `setup-alpine`, answer the questions and it's ready to go. To build it with Packer, it's needed to populate the `boot-command` with the answers to this script. There are some variables to change some settings in the virtual machine, as the keyboard layout, memory and number of cores. 

The relevant file is `alpine.json`. To build the box, just execute inside `packer/` directory:

```
packer build alpine.json
```

To pass parameters to the build, as user login and alike:

```
packer build -var=ssh_username=youruser -var=ssh_password=yourpassword alpine.json
```

However, Alpine does not get along well with Vagrant, as it needs a `shutdown` command that Alpine lacks, used when performing `vagrant halt`. Also, the VBox Guest Additions doesn't work, probably with some work could be done, but I prefer to keep this as simple as possible, so I will follow with an Ubuntu installation.

Ubuntu uses `debconf` to perform the installation, so we can use preseed files to automate it. It's not straightforward though, and it requires a lot of trial and error. The approach I've taken is to perform a manual installation and generate the preseed file for that installation. However, it contains a lot of configuration directives (and scrambled!), which is not very useful. As most of the directives are populated with default values, I used a minimalistic template and changed od add the relevant parts, as the keyboard layout and package selection.

Here's an article as [reference](http://kappataumu.com/articles/creating-an-Ubuntu-VM-with-packer.html).

Additionally to the OS installation, Vagrant needs the creation of a vagrant user with sudo privileges, a `/vagrant` directory, and the installation of the Guest Additions in order to share folders between the guest and the host. This is done using shell scripts, under the `packer/scripts/` directory. The installation of Docker and Docker Compose is done also in the provision phase.

## Vagrantfile

Once the vagrant box it's created, we can use it to run the development environment. The box has Docker and Docker Compose under Ubuntu, so the development will be done under containers without polluting the VM guest with dependencies. The intended usage is to use Compose to define and run the environment.

The VM is provisioned to avoid a nasty bug in VirtualBox Sahred Folders + Docker, which corrupts the filesystem within the containers. There's an alias `dev` for `docker-compose` that prepends some instructions to avoid this behaviour, so we can use docker-compose safely. For example, to start the environment we'll just run 

```
dev up
```

As we're going to use different applications, dome of them network related, it's convenient to use bridged network adapters (`public_network` in vagrant), so the VM has its own IP address that can be accessed directly.

# Virtualization Server

We're going to use an old laptop as a virtualization server so we can create, provision and manage remote VMs. 


# Bare metal provisioning

## PXE

TFTP, DHCP and HTTP needed