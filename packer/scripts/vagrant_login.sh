#!/bin/bash -eux
echo 'Defaults env_reset
vagrant ALL=(ALL) NOPASSWD: ALL
' > /etc/sudoers.d/vagrant

mkdir -p /vagrant
mkdir -p /home/vagrant/.ssh
wget https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 0700 /home/vagrant/.ssh
chmod 0600 /home/vagrant/.ssh/authorized_keys

echo 'cd /vagrant' > /home/vagrant/.profile