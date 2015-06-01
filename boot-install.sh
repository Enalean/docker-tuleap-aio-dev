#!/bin/bash

set -ex

function generate_passwd {
   cat /dev/urandom | tr -dc "a-zA-Z0-9" | fold -w 15 | head -1
}

mkdir -p /data/etc/httpd/
mkdir -p /data/home
mkdir -p /data/lib
mkdir -p /data/etc/logrotate.d
mkdir -p /data/root && chmod 700 /data/root

pushd . > /dev/null
cd /var/lib
[ -d /var/lib/gitolite ] && mv /var/lib/gitolite /data/lib && ln -s /data/lib/gitolite gitolite
popd > /dev/null

# Install Tuleap
bash ./setup.sh --disable-selinux --sys-default-domain=$VIRTUAL_HOST --sys-org-name=Tuleap --sys-long-org-name=Tuleap --mysql-host=$DB_PORT_3306_TCP_ADDR --mysql-root-password=$MYSQL_ROOT_PASSWORD --mysql-httpd-host='%'

# Activate LDAP plugin
php /usr/share/tuleap/tools/utils/admin/activate_plugin.php ldap

# Setting root password
root_passwd=$(generate_passwd)
echo "root:$root_passwd" |chpasswd
echo "root: $root_passwd" >> /root/.tuleap_passwd

# Place for post install stuff
./boot-postinstall.sh

# Create fake file to avoid error below when moving
touch /etc/aliases.codendi

# Ensure system will be synchronized ASAP
/usr/share/tuleap/src/utils/php-launcher.sh /usr/share/tuleap/src/utils/launch_system_check.php

service httpd stop
service crond stop

### Move all generated files to persistant storage ###

# Conf
mv /etc/httpd/conf            /data/etc/httpd
mv /etc/httpd/conf.d          /data/etc/httpd
mv /etc/tuleap                /data/etc
mv /etc/aliases               /data/etc
mv /etc/aliases.codendi       /data/etc
mv /etc/logrotate.d/httpd     /data/etc/logrotate.d
mv /etc/libnss-mysql.cfg      /data/etc
mv /etc/libnss-mysql-root.cfg /data/etc
mv /etc/my.cnf                /data/etc
mv /etc/nsswitch.conf         /data/etc
mv /etc/crontab               /data/etc
mv /etc/passwd                /data/etc
mv /etc/shadow                /data/etc
mv /etc/group                 /data/etc
mv /root/.tuleap_passwd       /data/root

# Data
mv /home/codendiadm /data/home
mv /home/groups    /data/home
mv /home/users     /data/home
mv /var/lib/tuleap /data/lib

# Will be restored by boot-fixpath.sh later
[ -h /var/lib/gitolite ] && rm /var/lib/gitolite
