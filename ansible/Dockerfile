################################################################
# Docker image for Ansible in Alpine
#
################################################################
FROM python:2.7-alpine

RUN apk update && apk add bash libffi
RUN apk add git && \
	git clone git://github.com/ansible/ansible.git --recursive /opt/ansible && \
	cd /opt/ansible && \
 	apk add g++ make libffi-dev openssl-dev && \
 	pip install -r ./requirements.txt && \
	make install && \
 	apk del g++ make libffi-dev openssl-dev git && \
	rm -rf /var/cache/apk/* && \
	cd .. && \
	rm -rf ansible

COPY entrypoint.sh /usr/local/bin/

WORKDIR /opt/ansible

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/bin/ansible", "--version"]
