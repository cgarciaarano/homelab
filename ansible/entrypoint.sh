#!/bin/bash -eu

case $1 in
	playbook)
		ansible-playbook "${@:2}"
		;;
	bash|shell)
		/bin/bash
		;;
	*)
		ansible "$@"
		;;
esac