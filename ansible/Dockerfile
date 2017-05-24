################################################################
# Docker image for Ansible in Alpine
#
################################################################
FROM python:2.7-alpine

RUN apk update && apk add bash
RUN apk add g++ make libffi-dev openssl-dev && \
 	pip install ansible && \
 	apk del g++ make libffi-dev openssl-dev && \
	rm -rf /var/cache/apk/*

CMD ["/bin/bash"]