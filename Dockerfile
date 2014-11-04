## Tuleap All In One for development ##

FROM enalean/tuleap-aio:centos6

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

RUN yum install -y \
    php-pecl-xdebug \
    java-1.7.0-openjdk \
    tuleap-plugin-ldap \
    openldap-clients \
    gitolite3; \
    yum clean all

COPY xdebug.ini /etc/php.d/xdebug.ini
COPY Tuleap.repo /etc/yum.repos.d/

RUN install -d -m 0755 -o codendiadm -p codendiadm /var/tmp/tuleap_cache/combined

RUN rm -rf /usr/share/tuleap

ADD . /root/app

## Run environement
WORKDIR /root/app
VOLUME [ "/data", "/usr/share/tuleap" ]
EXPOSE 22 80 443
CMD ["/root/app/run.sh"]
