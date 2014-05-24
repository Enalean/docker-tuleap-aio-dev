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
