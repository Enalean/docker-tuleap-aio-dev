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
    tuleap-api-explorer \
    java-1.8.0-openjdk \
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
    nginx && \
    yum clean all && \
    rm -rf /usr/share/tuleap && \
    sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf && \
    localedef -i fr_FR -c -f UTF-8 fr_FR.UTF-8

COPY xdebug-fpm.ini /etc/opt/remi/php72/php.d/15-xdebug.ini

COPY . /root/app

## Run environement
WORKDIR /root/app
VOLUME [ "/data", "/usr/share/tuleap" ]
EXPOSE 22 80 443
CMD ["/usr/sbin/init"]
