################################################################
# Docker image for Ansible in Alpine
#
################################################################
FROM python:2.7-alpine

RUN apk update && apk add bash libffi

RUN apk add git g++ make libffi-dev openssl-dev && \
	pip install git+https://github.com/ansible/ansible.git@devel && \
	apk del g++ make libffi-dev openssl-dev git && \
	rm -rf /var/cache/apk/*

COPY entrypoint.sh /
COPY etc /etc

WORKDIR /etc/ansible

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/local/bin/ansible", "--version"]
