# Packer

First step is to build the development box. The creation of the box is inspired on this post, [Building a Vagrant Box from Start to Finish](https://blog.engineyard.com/2014/building-a-vagrant-box), but since it's a manual procedure, I'm using Packer so the box is defined as code, which the purpose of this project.

## Trying with Alpine

Alpine is the distribution I selected in first place because it's minimal. Since we're going to use Docker to run any binary, the dependencies will be handled by containers instead of the OS. The Alpine installation is straightforward, just run `setup-alpine`, answer the questions and it's ready to go. To build it with Packer, it's needed to populate the `boot-command` with the answers to this script. There are some variables to change some settings in the virtual machine, as the keyboard layout, memory and number of cores. 

However, Alpine does not get along well with Vagrant, as it needs a `shutdown` command that Alpine lacks, used when performing `vagrant halt`. Also, the VBox Guest Additions doesn't work, probably with some work could be done, but I prefer to keep this as simple as possible, so I will follow with an Ubuntu installation.

## Using Ubuntu

Ubuntu uses `debconf` to perform the installation, so we can use preseed files to automate it. It's not straightforward though, and it requires a lot of trial and error. The approach I've taken is to perform a manual installation and generate the preseed file for that installation. However, it contains a lot of configuration directives (and scrambled!), which is not very useful. As most of the directives are populated with default values, I used a minimalistic template and changed od add the relevant parts, as the keyboard layout and package selection.

Here's an article as [reference](http://kappataumu.com/articles/creating-an-Ubuntu-VM-with-packer.html).

Additionally to the OS installation, Vagrant needs the creation of a vagrant user with sudo privileges, a `/vagrant` directory, and the installation of the Guest Additions in order to share folders between the guest and the host. This is done using shell scripts, under the `packer/scripts/` directory. The installation of Docker and Docker Compose is done also in the provision phase.

## Execution

The relevant file is `ubuntu64.json`. To build the box, just execute inside `packer/` directory:

```
packer build ubuntu64.json
```

To pass parameters to the build, as user login and alike:

```
packer build -var=ssh_username=youruser -var=ssh_password=yourpassword ubuntu64.json
```