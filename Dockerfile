## Tuleap All In One for development ##

FROM enalean/tuleap-aio

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

# Debug
RUN yum install -y php-pecl-xdebug
ADD xdebug.ini /etc/php.d/xdebug.ini

RUN mv /usr/share/tuleap /usr/share/tuleap.RPM

ADD . /root/app

## Run environement
WORKDIR /root/app
VOLUME [ "/data", "/usr/share/tuleap" ]
EXPOSE 22 80 443
CMD ["/root/app/run.sh"]
