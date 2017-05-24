################################################################
# Example from https://www.amon.cx/blog/one-year-with-ansible/
#
################################################################
FROM ubuntu:trusty

RUN apt-get update

RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:ansible/ansible
RUN apt-get update
RUN apt-get install -y git curl ansible

ADD mysql.yml /playbooks/mysql.yml
RUN ansible-playbook /playbooks/mysql.yml -i 'localhost' --conection=local

CMD ["/bin/bash"]