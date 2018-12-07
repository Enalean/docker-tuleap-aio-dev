## Tuleap All In One for development ##
FROM centos:6

RUN yum install -y \
        epel-release \
        centos-release-scl \
        postfix \
        openssh-server \
        rsyslog \
        cronie && \
    yum install -y supervisor && \
    yum clean all

# The later commend is meant to work around meld, distribute and supervisord
# issues on centos6
# http://stackoverflow.com/questions/7446187/no-module-named-pkg-resources

COPY RPM-GPG-KEY-remi /etc/pki/rpm-gpg/
COPY *.repo /etc/yum.repos.d/

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
    rpm --rebuilddb && \
    yum install -y \
    tuleap-install \
    tuleap-core-cvs \
    tuleap-core-subversion \
    tuleap-plugin-agiledashboard \
    tuleap-plugin-hudson \
    tuleap-plugin-git-gitolite3 \
    tuleap-plugin-gitlfs \
    tuleap-plugin-graphontrackers \
    tuleap-theme-flamingparrot \
    tuleap-documentation \
    tuleap-customization-default \
    tuleap-api-explorer \
    java-1.8.0-openjdk \
    tuleap-plugin-ldap \
    tuleap-plugin-mediawiki \
    tuleap-core-mailman \
    tuleap-plugin-forumml \
    tuleap-plugin-fulltextsearch \
    tuleap-plugin-webdav \
    openldap-clients \
    vim \
    php72-php-intl \
    php72-php-bcmath \
    php72-php-gd \
    php72-php-pear \
    php72-php-soap \
    php72-php-mysqlnd \
    php72-php-xml \
    php72-php-mbstring \
    php72-php-cli \
    php72-php-opcache \
    php72-php-process \
    php72-php-pdo \
    php72-php-fpm \
    php72-php-ldap \
    php72-php-pecl-xdebug \
    php72-php-intl \
    php72-php-bcmath \
    php72-php-pecl-zip \
    php72-php-pecl-redis \
    php72-php-pecl-mailparse \
    nginx \
    php-mediawiki-tuleap-123 && \
    yum clean all && \
    rm -rf /usr/share/tuleap && \
    sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf

# Add fr_FR.UTF-8 locale for translation using gettext
RUN localedef -i fr_FR -c -f UTF-8 fr_FR.UTF-8

COPY supervisord.conf /etc/supervisord.conf
COPY xdebug-fpm.ini /etc/opt/remi/php72/php.d/15-xdebug.ini

COPY . /root/app

## Run environement
WORKDIR /root/app
VOLUME [ "/data", "/usr/share/tuleap" ]
EXPOSE 22 80 443
CMD ["/root/app/run.sh"]
