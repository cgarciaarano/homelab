################################################################
# Docker image for Ansible in Alpine
#
################################################################
FROM python:2.7-alpine

RUN apk update && apk add bash libffi
RUN apk add g++ make libffi-dev openssl-dev && \
 	pip install https://github.com/ansible/ansible/archive/devel.zip && \
 	apk del g++ make libffi-dev openssl-dev git && \
	rm -rf /var/cache/apk/*

COPY entrypoint.sh /usr/local/bin/

WORKDIR /opt/ansible

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/bin/ansible", "--version"]
