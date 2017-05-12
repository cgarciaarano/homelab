############################################################
# Dockerfile for PXE 
#
# Based on Ubuntu 16.04
############################################################

# Set the base image to Ubuntu
FROM ubuntu:16.04

MAINTAINER cgarciaarano@gmail.com

# Update the repository sources list
RUN apt update && apt install -y apache2 tftpd-hpa inetutils-inetd



EXPOSE 67/udp
EXPOSE 80

CMD ["python", "manage.py", "runserver", "0.0.0.0:8080"]
