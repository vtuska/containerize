#!/bin/bash
set -x
set -e

if [[ ! $1 =~ (debootstrap|build|config|strip|dump) ]]; then
	echo "Wrong parameter"
	exit
fi
source config
mkdir -pv ${DESTINATION}/.workbench

function executeinchroot {
	cp -a $1 ${DESTINATION}/.workbench/
	cp config ${DESTINATION}/.workbench/
	chroot $DESTINATION /.workbench/${1}
}

case $1 in
	debootstrap)
		debootstrap $DISTRO $DESTINATION
	;;
	build)
		executeinchroot build.sh
	;;
	config)
		executeinchroot config.sh
	;;
	strip)
		executeinchroot strip.sh
	;;
	dump)
		executeinchroot dump.sh
	;;
esac
