chroot build/trusty/
cd /.workbench/linked
for i in `find .`; do if [ ! -d ${i:1} ]; then dpkg -S ${i:1}; fi ; done|cut -f1 -d ':'|sort|uniq
