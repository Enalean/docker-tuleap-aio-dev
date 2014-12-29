#!/bin/bash

set -e

# It's a "reboot", just discard image default
[ -f /etc/aliases ]               && rm -f /etc/aliases
[ -f /etc/logrotate.d/httpd ]     && rm -f /etc/logrotate.d/httpd
[ -f /etc/libnss-mysql-root.cfg ] && rm -f /etc/libnss-mysql-root.cfg
[ -f /etc/libnss-mysql.cfg ]      && rm -f /etc/libnss-mysql.cfg
[ -f /etc/my.cnf ]                && rm -f /etc/my.cnf
[ -f /etc/nsswitch.conf ]         && rm -f /etc/nsswitch.conf
[ -f /etc/crontab ]               && rm -f /etc/crontab
[ -f /etc/passwd ]               && rm -f /etc/passwd
[ -f /etc/shadow ]               && rm -f /etc/shadow
[ -f /etc/group ]               && rm -f /etc/group
[ -d /etc/tuleap ]                && rm -rf /etc/tuleap
[ -d /etc/httpd/conf ]            && rm -rf /etc/httpd/conf
[ -d /etc/httpd/conf.d ]          && rm -rf /etc/httpd/conf.d

[ -d /home/codendiadm ]  && rm -rf /home/codendiadm
[ -d /home/groups ]      && rm -rf /home/groups
[ -d /home/users ]       && rm -rf /home/users
[ -d /var/lib/tuleap ]   && rm -rf /var/lib/tuleap
[ -d /var/lib/gitolite ] && rm -rf /var/lib/gitolite

# Update paths to refer to persistent storage
cd /etc
ln -s /data/etc/tuleap tuleap
ln -s /data/etc/aliases aliases
ln -s /data/etc/aliases.codendi aliases.codendi
ln -s /data/etc/libnss-mysql-root.cfg libnss-mysql-root.cfg
ln -s /data/etc/libnss-mysql.cfg libnss-mysql.cfg
ln -s /data/etc/my.cnf my.cnf
ln -s /data/etc/nsswitch.conf nsswitch.conf
ln -s /data/etc/crontab crontab
ln -s /data/etc/passwd passwd
ln -s /data/etc/shadow shadow
ln -s /data/etc/group group

cd /etc/logrotate.d
ln -s /data/etc/logrotate.d/httpd httpd

cd /etc/httpd
ln -s /data/etc/httpd/conf conf
ln -s /data/etc/httpd/conf.d conf.d

cd /home
ln -s /data/home/codendiadm codendiadm
ln -s /data/home/users users
ln -s /data/home/groups groups

cd /var/lib
ln -s /data/lib/mysql mysql
ln -s /data/lib/tuleap tuleap
[ -d /data/lib/gitolite ] && ln -s /data/lib/gitolite gitolite
