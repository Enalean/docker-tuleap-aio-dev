Deploy Tuleap development environment
=====================================

Deploy a Tuleap inside a docker container

More info about Tuleap on [tuleap.org](http://www.tuleap.org)

How to use it?
---------------

* Install [fig](http://www.fig.sh/install.html) and [docker](http://docker.io)

* Link tuleap sources here:
```
    ln -s /path/to/tuleap_sources tuleap
```

* Set environment variables:
```
    export MYSQL_ROOT_PASSWORD=welcome0
    export VIRTUAL_HOST=tuleap.local
```

* Run

    fig up

* Add front end IP to your machin hosts file:

    FRONT=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' tuleapaiodev_tuleap_1)
    echo "$FRONT_IP $VIRTUAL_HOST" >> /etc/hosts

* Access with

    xdg-open http://tuleap.local

Host to use it with skydock ?
-----------------------------

* Install & setup docker, fig and [skydock](https://github.com/crosbymichael/skydock)

* Link tuleap sources here:

    ln -s /path/to/tuleap_sources tuleap

* Set environment variables:

    export MYSQL_ROOT_PASSWORD=welcome0
    export VIRTUAL_HOST=tuleapaiodev_tuleap.dev.docker

* Run

    fig up

* Access with

    xdg-open http://tuleapaiodev_tuleap.dev.docker
