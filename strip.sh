#!/bin/bash
set -x
set -e

source /.workbench/config


P=0
for i in ${XLINKDIR[@]}; do
	mkdir -pv $i
	for j in $(eval echo \${XLINKIFY2DIR${P}[@]}); do
		echo $j
		cp -av --parent $j $i
		rm -rf $j
		ln -s ${i}${j} $j
	done
	P=$((P+1))
done

mkdir -pv /.meta
touch /.meta/.userinfo.${USR}:${GRP}
chown ${USR}:${GRP} /.meta/.userinfo.${USR}:${GRP}
