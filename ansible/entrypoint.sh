#!/bin/bash -eu

case $1 in
	playbook)
		exec ansible-playbook "${@:2}"
		;;
	bash|shell)
		exec /bin/bash
		;;
	*)
		exec ansible "$@"
		;;
esac