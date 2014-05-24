#!/bin/bash

set -e

if [ "$TULEAP_INSTALL_TIME" == "true" ]; then
    # Map appliction id to user who runs the container
    old_app_uid=$(id -u codendiadm)
    old_app_gid=$(id -g codendiadm)
    usermod -g $GID -u $UID codendiadm
    find / -uid $old_app_uid -exec chown codendiadm {} \;
    find / -gid $old_app_gid -exec chgrp codendiadm {} \;
fi

# Deploy ssh key #
if [ ! -z "$SSH_KEY" ]; then
    mkdir -p /root/.ssh
    chmod 0700 /root/.ssh
    echo "$SSH_KEY" >> /root/.ssh/authorized_keys
    chmod 0600 /root/.ssh/authorized_keys
fi

# Fix SSH config #
perl -pi -e "s%GSSAPIAuthentication yes%GSSAPIAuthentication no%" /etc/ssh/sshd_config



