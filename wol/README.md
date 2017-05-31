# Wake On LAN

I added a feature to boot up the virtualization server via LAN. We need to configure the BIOS to allow WoL, and also configure the network card:

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

> **NOTE**: There's an [ansible playbook](../ansible/playbooks/lid_down.yml) to configure this. 