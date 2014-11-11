#!/bin/bash

set -ex

# Set apache/php in verbose mode
perl -pi -e "s%^php_value error_reporting.*%%" /etc/httpd/conf.d/php.conf
echo php_flag html_errors On >> /etc/httpd/conf.d/php.conf

# Deploy snippet to generate combined in a dedicated directory
perl -pi -e "s%//.*sys_combined_dir.*%\\\$sys_combined_dir = '/var/tmp/tuleap_cache/combined';%" /etc/tuleap/conf/local.inc
