#!/bin/bash
set -x
set -e

ls -l /.workbench
source /.workbench/config

for i in ${XLINKDIR[@]}; do
	EXCLUDES+=("${i}/*")
	FILE=$(echo ${i}|tr '/' '_')
	cd $i && tar -czvpf /.workbench/${FILE}.tgz ./
done

for i in ${EXCLUDEPKGS[@]}; do
	for j in `dpkg -L $i`; do
		if [ ! -d ${j} ]; then
			EXCLUDES+=("${j}")
		fi
	done
done

EXCLUDES+=("/.workbench")

for i in ${EXCLUDES[@]}; do
	echo $i
done|tar -X - -cvzpf /.workbench/rootfs.tgz /
