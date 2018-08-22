#!/bin/bash

set -ex

if [ "$DO_NOT_LAUNCH_FORGEUPGRADE" == true ] ; then
    echo "Database may be inconsistent. You should run a forgeupgrade update."
else
    # On start, ensure db is consistent with data (useful for version bump)
    /usr/lib/forgeupgrade/bin/forgeupgrade --config=/etc/tuleap/forgeupgrade/config.ini update
fi

# Ensure system will be synchronized ASAP (once system starts)
/usr/share/tuleap/src/utils/php-launcher.sh /usr/share/tuleap/src/utils/launch_system_check.php
