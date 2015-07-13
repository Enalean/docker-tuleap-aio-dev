#!/bin/bash

set -ex

# Fix php conf #
perl -pi -e "s%^error_reporting =.*%error_reporting = E_ALL & ~E_DEPRECATED%" /etc/php.ini
perl -pi -e "s%^display_errors = Off%display_errors = On%" /etc/php.ini

# Deploy ssh key #
if [ ! -z "$SSH_KEY" ]; then
    mkdir -p /root/.ssh
    chmod 0700 /root/.ssh
    echo "$SSH_KEY" >> /root/.ssh/authorized_keys
    chmod 0600 /root/.ssh/authorized_keys
fi

# Fix SSH config #
perl -pi -e "s%GSSAPIAuthentication yes%GSSAPIAuthentication no%" /etc/ssh/sshd_config

# Set APC Cache to 128M instead of only 64
sed -i "s/^apc.shm_size=.*$/apc.shm_size=128M/" /etc/php.d/apc.ini

# Enable API Explorer
ln -sf /usr/share/restler/vendor/Luracast/Restler/explorer/ /usr/share/tuleap/src/www/api/explorer
