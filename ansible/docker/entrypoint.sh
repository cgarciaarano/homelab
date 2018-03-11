#!/bin/bash -eu

case $1 in
	playbook)
		exec ansible-playbook "${@:2}"
		;;
	vault)
		exec ansible-vault "${@:2}"
		;;		
	bash|shell)
		exec /bin/sh
		;;
	*)
		exec ansible "$@"
		;;
esac