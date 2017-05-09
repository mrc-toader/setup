#!/bin/bash
set -e
set -x

SRC=/opt/dokuwiki
DST=/var/www/dokuwiki

cd /var/www
cp -r $SRC /var/www
cd $DST
chown -R www-data:www-data $DST
chmod -R a-w $DST
chmod -R u+rw $DST/data
chmod -R u+rw $DST/lib/plugins
chmod -R u+rw $DST/lib/tpl
chmod -R u+rw $DST/conf

systemctl restart nginx
