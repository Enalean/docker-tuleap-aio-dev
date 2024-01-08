FROM centos:7

ENV container docker

STOPSIGNAL SIGRTMIN+3

COPY remi-safe.repo /etc/yum.repos.d/
COPY RPM-GPG-KEY-remi /etc/pki/rpm-gpg/
COPY Tuleap.repo /etc/yum.repos.d/
COPY tuleap-php-fpm-override.conf /etc/systemd/system/tuleap-php-fpm.service.d/override.conf

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
    systemd-tmpfiles-setup.service ] || rm -f $i; done); \
    rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/* && \
    rpm --rebuilddb && \
    yum install -y \
    epel-release \
    centos-release-scl \
    postfix \
    openssh-server && \
    yum install -y \
    rh-mysql80-mysql \
    tuleap-plugin-agiledashboard \
    tuleap-plugin-graphontrackers \
    tuleap-theme-burningparrot \
    tuleap-theme-flamingparrot \
    tuleap-plugin-git \
    tuleap-plugin-svn \
    tuleap-plugin-hudson\* \
    tuleap-plugin-mediawiki \
    tuleap-plugin-mediawiki-standalone \
    tuleap-plugin-ldap \
    tuleap-api-explorer \
    java-1.8.0-openjdk \
    openldap-clients \
    vim \
    less \
    php82-php-intl \
    php82-php-bcmath \
    php82-php-gd \
    php82-php-soap \
    php82-php-mysqlnd \
    php82-php-xml \
    php82-php-mbstring \
    php82-php-cli \
    php82-php-opcache \
    php82-php-process \
    php82-php-pdo \
    php82-php-fpm \
    php82-php-ldap \
    php82-php-sodium \
    php82-php-pecl-xdebug \
    php82-php-intl \
    php82-php-bcmath \
    php82-php-ffi \
    php82-php-pecl-zip \
    php82-php-pecl-mailparse \
    php82-php-pecl-redis5 \
    nginx && \
    yum clean all && \
    rm -rf /usr/share/tuleap && \
    sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf && \
    localedef -i fr_FR -c -f UTF-8 fr_FR.UTF-8 && \
    localedef -i pt_BR -c -f UTF-8 pt_BR.UTF-8

COPY xdebug-fpm.ini /etc/opt/remi/php82/php.d/15-xdebug.ini

## Run environment
ENV PHP_VERSION php82
WORKDIR /usr/share/tuleap
VOLUME [ "/data", "/usr/share/tuleap" ]
EXPOSE 22 80 443
CMD ["/usr/share/tuleap/tools/docker/tuleap-aio-dev/init"]
