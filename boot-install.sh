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
/usr/share/tuleap/tools/setup.el7.sh \
    --assumeyes \
    --configure \
    --mysql-server=db \
    --mysql-password=$MYSQL_ROOT_PASSWORD \
    --server-name=$VIRTUAL_HOST

# Activate LDAP plugin
su -c '/usr/share/tuleap/src/utils/php-launcher.sh /usr/share/tuleap/tools/utils/admin/activate_plugin.php ldap' -l codendiadm
cp /root/app/ldap.inc /etc/tuleap/plugins/ldap/etc/ldap.inc
sed -i "s/^\$sys_auth_type.*/\$sys_auth_type = 'ldap';/" /etc/tuleap/conf/local.inc

# Log level debug
sed -i "s/^\$sys_logger_level.*/\$sys_logger_level = 'debug';/" /etc/tuleap/conf/local.inc

chown -R codendiadm:codendiadm /etc/tuleap

# Setting root password
root_passwd=$(generate_passwd)
echo "root:$root_passwd" |chpasswd
echo "root: $root_passwd" >> /root/.tuleap_passwd

# Create fake file to avoid error below when moving
touch /etc/aliases.codendi

# Ensure system will be synchronized ASAP
/usr/bin/tuleap queue-system-check

### Move all generated files to persistant storage ###

# Conf
mv /etc/httpd/conf            /data/etc/httpd
mv /etc/httpd/conf.d/tuleap-plugins /etc/httpd-conf.d-tuleap-plugins
mv /etc/httpd/conf.d          /data/etc/httpd
mv /etc/tuleap                /data/etc
mv /etc/aliases               /data/etc
mv /etc/aliases.codendi       /data/etc
mv /etc/logrotate.d/httpd     /data/etc/logrotate.d
mv /etc/my.cnf                /data/etc
mv /etc/nsswitch.conf         /data/etc
mv /root/.tuleap_passwd       /data/root

# Data
mv /home/codendiadm /data/home
mv /home/groups    /data/home
mv /home/users     /data/home
mv /var/lib/tuleap /data/lib

# Will be restored by boot-fixpath.sh later
[ -h /var/lib/gitolite ] && rm /var/lib/gitolite
