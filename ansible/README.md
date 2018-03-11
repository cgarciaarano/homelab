# Ansible

Agentless configuration management tool.

## Development environent

This directory contains a development environment for Ansible Playbooks using Docker Compose. (Not intended for Ansible developing)

It defines one container with Ansible and another one with the target machine. 

- `ansible`: Alpine with Python 2.7. Ansible is installed via `git`, the configuration in `etc/` is mounted on `/etc/ansible/`, and the `ansible/` directory is mounted on `/opt/ansible`. It also contains a private key to connect to the target machines
- `target`: Ubuntu Xenial with ssh server to test Ansible playbooks. Python is installed, as it's needed by Ansible to run (this would be a problem in embedded systems). It contains a public key to allow passwordless logins from Ansible container.

Just run:

```
dev up -d
```

to start the target machine and the network, then run an ansible command against it:

```
dev run ansible target -m ping
```

There's a key pair without passphrase to avoid password prompts. The public key is copied to `target` when the image is created, but the ansible private key is mounted on the container. If want to change it, just generate another key pair and substitute the current pair. 

> **WARNING**: It uses `root` to connect, so it should't be used in production.

To discard all changes done on `target`, just destroy the environment and start it again (`restart` only stops and restarts the containers, so the volumes are preserved):

```
dev down
dev up -d
```

## Playbooks

There are some examples in the playbooks directory. As an exercise, I'm going to write a playbook to install PostgreSQL 9.x.

### PostgreSQL

The process to install PostgreSQL can be summarized as:

1. Add repository
2. Authenticate repository
3. Install packages
4. Setup configuration files
5. Setup users
6. Restart

These are going to be the tasks in the YML file. I've started with a simple playbook, but it's better organized as a role, so I have developed just the role.

#### Variables
 
- version: We can pass the version setting the variables in the command line: `ansible-playbook playbooks/psql.yml -e "version=9.4"`. Defaults to 9.6.
- datapath: It's created based on `version`.
- configpath: It's created based on `version`.

#### Tasks

They are pretty self explanatory

- Add repo, takes in account the distro.
- Authenticate repo.
- Install packages, will use the appropiate version of `postgresql`.
- Setup, uses some templating. It can be hard to be consistent between versions. [Here](https://github.com/ANXS/postgresql) they solved it using different templates for each version.
- Add admin user. This is tricky. Usage of `postgresql_user` module requires `psycopg2` to be installed on the target host, which is far from ideal. Other option is to create the user using a crafted query via `psql` binary, which is also crappy, so I've taken the option of installing `python-psycopg2` system package, as it's the cleanest way.

#### Templates

There are templates for:

- postgresql.conf
- pg_hba.conf

#### Meta

There are no dependecies with other roles, nor Galaxy stuff

#### Playbook

First, we create a group in runtime to select only the Debian family, then apply the role to that group.

## Desktop provision

To ease the provision of a working desktop computer, there's a `desktop.yml` playbook that will add the tools and shortcut that I usually use.

To execute this playbook in the current computer, just run:

```
docker-compose run ansible playbook playbooks/desktop.yml --extra-vars "host=$HOSTNAME" --user=$(whoami)--ask-become-pass --ask-pass
```

### Requisites

- $HOSTNAME should be in the ansible inventory, with the options `ansible_user=your_user` and `ansible_become=true` 
- docker & docker-compose shoudl be installed
- openssh-server shoud be installed and running

