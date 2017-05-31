################################################################
# Docker image for Ansible in Alpine, with PostgreSQL support
#
################################################################
FROM python:2.7-alpine

RUN apk update && apk add bash libffi
RUN apk add git && \
	git clone git://github.com/ansible/ansible.git --recursive /opt/ansible && \
	cd /opt/ansible && \
 	apk add g++ make libffi-dev openssl-dev postgresql-dev && \
 	pip install -r ./requirements.txt psycopg2==2.7.1 && \
	make install && \
 	apk del g++ make libffi-dev openssl-dev git postgresql-dev && \
	rm -rf /var/cache/apk/* && \
	cd .. && \
	rm -rf ansible

COPY entrypoint.sh /usr/local/bin/

WORKDIR /opt/ansible

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/bin/ansible", "--version"]
