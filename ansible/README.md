# Ansible


##Development environent

This directory contains a development environment for Ansible using Docker Compose.

It defines one container with Ansible and another one with the target machine. Just run 

```
dev up -d
```

to start the target machine and the network, then run an ansible command against it:

```
dev run ansible <whatever>
```