#!/bin/bash
set -x
set -e

source config

VOLUME=""
for i in ${XLINKDIR[@]}; do
	VOLUMENAME=$(echo $i|tr '/' '_')
	VOLUME+=" -v ${IMAGENAME}${INSTANCENAME}${VOLUMENAME}:${i}"

	if  [[ ${VOLUMENAME} =~ .*_ro$ ]]; then
		VOLUME+=":ro"
	fi
done

EXPOSE=""
for i in ${PORT}; do
	EXPOSE+=" -p $i"
done

docker run $EXPOSE --read-only -u ${USRID}:${GRPID} -d $VOLUME --name ${IMAGENAME}${INSTANCENAME} ${IMAGENAME} $RUN
