#!/bin/bash -eux

mount -t iso9660 VBoxGuestAdditions.iso /media/cdrom/
/media/cdrom/VBoxLinuxAdditions.run
umount /media/cdrom/