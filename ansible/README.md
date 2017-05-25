# Ansible

Agentless configuration management tool.

## Development environent

This directory contains a development environment for Ansible using Docker Compose.

It defines one container with Ansible and another one with the target machine. 

- Ansible: Alpine with Python 2.7. Ansible is installed via `pip` and the configuration and hosts files are mounted on `/etc/ansible/`. It also contains a private key to connect to the target machines
- Target: Ubuntu Xenial with ssh server to test Ansible playbooks. Python is installed, as it's needed by Ansible to run (this would be a problem in embedded systems). It contains a public key to allow passwordless logins from Ansible container.

Just run:

```
dev up -d
```

to start the target machine and the network, then run an ansible command against it:

```
dev run ansible target -m ping
```

There's a key pair to avoid password prompts. The public key is copied to `target` when the image is created, but the ansible private key is mounted on the container. If want to change it, just generate another key pair and substitute the current pair. **WARNING**: It uses `root` to connect, so it should't be used in production.