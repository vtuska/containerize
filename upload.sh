#!/bin/bash
set -x
#set -e

source config

for i in _shared_ro _shared_rw _unshared_rw; do
	docker volume rm ${IMAGENAME}${INSTANCENAME}${i}
	docker volume create --name ${IMAGENAME}${INSTANCENAME}${i}
	VOLPATH=$(docker volume inspect -f '{{ .Mountpoint }}' ${IMAGENAME}${INSTANCENAME}${i})
	tar -xzvpf ${DESTINATION}/.workbench/${i}.tgz -C ${VOLPATH}

	REALUSRID=$(stat -c "%u" ${DESTINATION}/.meta/.userinfo.${USR}:${GRP})
	REALGRPID=$(stat -c "%g" ${DESTINATION}/.meta/.userinfo.${USR}:${GRP})
	chown -R --from=${REALUSRID} ${USRID} ${VOLPATH}/
	chown -R --from=:${REALGRPID} :${GRPID} ${VOLPATH}/

	if [ -e ${VOLPATH}/etc/passwd ]; then
		perl -i -pe "s/^${USR}:x:${REALUSRID}:${REALGRPID}:/${USR}:x:${USRID}:${GRPID}:/" ${VOLPATH}/etc/passwd
	fi
	if [ -e ${VOLPATH}/etc/group ]; then
		perl -i -pe "s/^${GRP}:x:${REALGRPID}:/${USR}:x:${GRPID}:/" ${VOLPATH}/etc/group
	fi
done

if [ "$1" == "FULL" ]; then
	gzip -c -d ${DESTINATION}/.workbench/rootfs.tgz |docker import - $IMAGENAME
fi
