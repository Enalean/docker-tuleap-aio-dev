## Tuleap All In One for development ##
FROM centos:centos6

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

RUN yum install -y \
        epel-release \
    	postfix \
        openssh-server \
        rsyslog \
        cronie && \
    yum install -y python-pip && \
    yum clean all && \
    curl https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py | python

# The later commend is meant to work around meld, distribute and supervisord
# issues on centos6
# http://stackoverflow.com/questions/7446187/no-module-named-pkg-resources

COPY Tuleap.repo /etc/yum.repos.d/

# Gitolite will not work out-of-the-box with an error like
# "User gitolite not allowed because account is locked"
# Given http://stackoverflow.com/a/15761971/1528413 you might want to trick
# /etc/shadown but the following pam modification seems to do the trick too
# It's better for as as it can be done before installing gitolite, hence
# creating the user.
# I still not understand why it's needed (just work without comment or tricks
# on a fresh centos install)

# Second sed is for cron
# Cron: http://stackoverflow.com/a/21928878/1528413

RUN sed -i '/session    required     pam_loginuid.so/c\#session    required     pam_loginuid.so' /etc/pam.d/sshd && \
    sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond && \
    /sbin/service sshd start && \
    yum install -y --exclude=php-pecl-apcu \
    tuleap-install \
    tuleap-core-cvs \
    tuleap-core-subversion \
    tuleap-plugin-agiledashboard \
    tuleap-plugin-hudson \
    tuleap-plugin-git-gitolite3 \
    tuleap-plugin-graphontrackers \
    tuleap-theme-flamingparrot \
    tuleap-documentation \
    tuleap-customization-default \
    tuleap-api-explorer \
    php-pecl-xdebug \
    java-1.7.0-openjdk \
    tuleap-plugin-ldap \
    tuleap-plugin-mediawiki \
    tuleap-core-mailman \
    tuleap-plugin-forumml \
    tuleap-plugin-fulltextsearch \
    tuleap-plugin-webdav \
    openldap-clients \
    php-markdown \
    php-ZendFramework2-Loader \
    php-jwt \
    php-paragonie-random-compat \
    vim \
    php-guzzle \
    yum clean all && \
    pip install supervisor && \
    install -d -m 0755 -o codendiadm -p codendiadm /var/tmp/tuleap_cache/combined && \
    cp /usr/share/tuleap/src/etc/combined.conf.dist /etc/httpd/conf.d/tuleap-plugins/tuleap-combined.conf && \
    perl -pi -e "s%apc.shm_size=64M%apc.shm_size=128M%" /etc/php.d/apc.ini && \
    rm -rf /usr/share/tuleap

COPY supervisord.conf /etc/supervisord.conf
COPY xdebug.ini /etc/php.d/xdebug.ini

COPY . /root/app

## Run environement
WORKDIR /root/app
VOLUME [ "/data", "/usr/share/tuleap" ]
EXPOSE 22 80 443
CMD ["/root/app/run.sh"]
