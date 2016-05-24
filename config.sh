#!/bin/bash
set -x
set -e

source /.workbench/config

apt-get -y -qq update
apt-get -y -qq upgrade
apt-get -y -qq install apt-rdepends

init

apt-get -y -qq install ${PACKAGES[@]}

apt-rdepends ${PACKAGES[@]} > /.workbench/apt-rdepends.lst
dpkg-query -W -f="\${Package}\n" > /.workbench/debs-installed.txt

apt-get clean
apt-get autoremove
apt-get autoclean

finalize

