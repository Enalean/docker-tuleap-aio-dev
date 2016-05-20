Deploy Tuleap development environment
=====================================

Deploy a Tuleap inside a docker container for use with codenvy

More info about Tuleap on [tuleap.org](http://www.tuleap.org)

How to use it?
---------------

* Checkout the tuleap sources somewhere

* Then run `docker run -e VIRTUAL_HOST=name_or_ip -v $PWD:/usr/share/tuleap -p 80:80 -p 443:443 -p 22:22 tuleap`

** `name_or_ip` is the domain name you will use to acces the machine (eg. `localhost`)

* After sometime you should get a running machine in the container
* To login, use informations stored inside the container in `/data/root/.tuleap_passwd`

