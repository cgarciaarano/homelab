#!/bin/bash
HOME=/home/vagrant

# Ask for Docker Cloud logon
cat << EOF > $HOME/.profile
. ~/.bashrc
cd /vagrant
while [ ! -e ~/.docker/config.json ] ; do
	echo
	echo
	echo -e "\e[0;36mDockerCloud Registry login\e[m"
	echo -e "\e[0;33mdocker login \e[m"
	echo
	docker login
done
EOF

# Aliases for docker compose and stuff
cat << EOF > $HOME/.bash_aliases
# dev avoids annoying bug in sendfile syscall
alias dev="sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'; docker-compose -f docker-compose.yml"
alias clean="docker images --no-trunc | grep '<none>' | awk '{ print \$3 }' | xargs -r docker rmi ; docker ps --filter status=dead --filter status=exited -aq  | xargs docker rm -v ; docker volume ls -qf dangling=true | xargs -r docker volume rm"
EOF
