FROM centos:7

ENV container docker

STOPSIGNAL SIGRTMIN+3

COPY remi-safe.repo /etc/yum.repos.d/
COPY RPM-GPG-KEY-remi /etc/pki/rpm-gpg/
COPY Tuleap.repo /etc/yum.repos.d/
COPY run-dev.service /etc/systemd/system

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/* && \
    systemctl enable run-dev.service && \
    rpm --rebuilddb && \
    yum install -y \
    epel-release \
    centos-release-scl \
    postfix \
    openssh-server && \
    yum install -y \
    tuleap-plugin-agiledashboard \
    tuleap-plugin-graphontrackers \
    tuleap-theme-burningparrot \
    tuleap-theme-flamingparrot \
    tuleap-plugin-git \
    tuleap-plugin-svn \
    tuleap-plugin-hudson\* \
    tuleap-plugin-mediawiki \
    tuleap-plugin-ldap \
    tuleap-api-explorer \
    java-1.8.0-openjdk \
    openldap-clients \
    vim \
    php74-php-intl \
    php74-php-bcmath \
    php74-php-gd \
    php74-php-pear \
    php74-php-soap \
    php74-php-mysqlnd \
    php74-php-xml \
    php74-php-mbstring \
    php74-php-cli \
    php74-php-opcache \
    php74-php-process \
    php74-php-pdo \
    php74-php-fpm \
    php74-php-ldap \
    php74-php-sodium \
    php74-php-pecl-xdebug \
    php74-php-intl \
    php74-php-bcmath \
    php74-php-pecl-zip \
    php74-php-pecl-mailparse \
    php74-php-pecl-redis5 \
    nginx && \
    yum clean all && \
    rm -rf /usr/share/tuleap && \
    sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf && \
    localedef -i fr_FR -c -f UTF-8 fr_FR.UTF-8

COPY xdebug-fpm.ini /etc/opt/remi/php74/php.d/15-xdebug.ini

COPY . /root/app

## Run environement
ENV PHP_VERSION php74
WORKDIR /root/app
VOLUME [ "/data", "/usr/share/tuleap" ]
EXPOSE 22 80 443
CMD ["/usr/sbin/init"]
