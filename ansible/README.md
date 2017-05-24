# Ansible

Agentless configuration management tool.

## Development environent

This directory contains a development environment for Ansible using Docker Compose.

It defines one container with Ansible and another one with the target machine. Just run 

```
dev up -d
```

to start the target machine and the network, then run an ansible command against it:

```
dev run ansible <whatever>
```

There's a key pair to avoid password prompts. The public key is copied to `target` when th eimage is created, but the ansible private key is mounted on the container. If want to change it, just generate another key pair and substitute the current pair.