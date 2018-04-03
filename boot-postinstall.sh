#!/bin/bash

set -ex

# Deploy snippet to generate combined in a dedicated directory
perl -pi -e "s%//.*sys_combined_dir.*%\\\$sys_combined_dir = '/var/tmp/tuleap_cache/combined';%" /etc/tuleap/conf/local.inc
