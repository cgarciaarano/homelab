# PXE provisioning

PXE (Preboot eXecution Environment) is a low level approach. It uses TFTP, DHCP and HTTP to perform a bare-metal installation.

DHCP provides an option to define the TFTP server that has the execution environment needed, whereas HTTP is used to serve the media needed  for the OS installation. When a new host boots up with PXE active (booting from LAN), it expects to find options 66 (TFTP server address) and 67 (boot program file). It uses this values to load the  initial environment.

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

## Kickstart

There's another possibility to automate the installation, using Kickstart. This comes from RedHat, but I'm not using it now.