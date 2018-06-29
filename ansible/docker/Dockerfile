################################################################
# Docker image for Ansible in Alpine
#
################################################################
FROM python:3

RUN apt-get update && apt-get install bash

RUN apt-get -y install git build-essential && \
	pip install git+https://github.com/ansible/ansible.git@devel && \
	pip install aead && \
	apt-get -y remove build-essential git && \
	rm -rf /var/cache/apt/*

COPY entrypoint.sh /
COPY etc /etc

WORKDIR /etc/ansible

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/ansible", "--version"]
