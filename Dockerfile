## Tuleap All In One for development ##

FROM enalean/tuleap-aio

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

# Debug
RUN yum install -y php-pecl-xdebug; yum clean all
ADD xdebug.ini /etc/php.d/xdebug.ini

# This is JAVA! (needed for XML validation)
RUN yum install -y java-1.7.0-openjdk; yum clean all

RUN mv /usr/share/tuleap /usr/share/tuleap.RPM

ADD . /root/app

## Run environement
WORKDIR /root/app
VOLUME [ "/data", "/usr/share/tuleap" ]
EXPOSE 22 80 443
CMD ["/root/app/run.sh"]
