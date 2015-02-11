## Tuleap All In One for development ##
FROM centos:centos6

MAINTAINER Manuel Vacelet, manuel.vacelet@enalean.com

COPY rpmforge.repo Tuleap.repo /etc/yum.repos.d/

RUN rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt && \
    rpm -i http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm && \
    yum install -y \
        epel-release \
    	postfix \
        openssh-server \
        sudo \
        rsyslog \
        cronie; \
        yum clean all

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
    yum install -y --enablerepo=rpmforge-extras --exclude=php-pecl-apcu \
    tuleap-install \
    tuleap-core-cvs \
    tuleap-core-subversion \
    tuleap-plugin-agiledashboard \
    tuleap-plugin-hudson \
    tuleap-plugin-git \
    tuleap-plugin-graphontrackers \
    tuleap-theme-flamingparrot \
    tuleap-documentation \
    tuleap-customization-default \
    restler-api-explorer \
    php-pecl-xdebug \
    java-1.7.0-openjdk \
    tuleap-plugin-ldap \
    tuleap-plugin-mediawiki \
    tuleap-core-mailman \
    tuleap-plugin-forumml \
    tuleap-plugin-fulltextsearch \
    tuleap-plugin-webdav \
    openldap-clients \
    python-pip \
    gitolite3 && \
    yum clean all && \
    pip install pip --upgrade && \
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
