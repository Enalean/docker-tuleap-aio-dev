#!/bin/bash

set -ex

# Ensure httpd is stopped to avoid errors
#service httpd stop

# Map appliction id to user who runs the container
#old_app_uid=$(id -u codendiadm)
#old_app_gid=$(id -g codendiadm)
#groupmod -g $GID codendiadm
#usermod -g $GID -u $UID codendiadm
#find / -uid $old_app_uid -exec chown codendiadm {} \; || true
#find / -gid $old_app_gid -exec chgrp codendiadm {} \; || true

# Set apache/php in verbose mode
perl -pi -e "s%^php_value error_reporting.*%%" /etc/httpd/conf.d/php.conf
echo php_flag html_errors On >> /etc/httpd/conf.d/php.conf
