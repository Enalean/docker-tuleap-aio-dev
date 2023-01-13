FROM rockylinux@sha256:99376f245b2d13d273260654d3b769918aa8af29b04f771add8ea0c9bf40a66c

ENV container docker

STOPSIGNAL SIGRTMIN+3

RUN rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/* && \
    dnf install -y \
        epel-release \
        https://rpms.remirepo.net/enterprise/remi-release-9.rpm \
        https://ci.tuleap.net/yum/tuleap/rhel/9/dev/x86_64/tuleap-community-release.rpm && \
    dnf install -y \
    glibc-locale-source \
    glibc-langpack-en \
    glibc-langpack-fr \
    glibc-langpack-pt \
    postfix \
    openssh-server \
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
    php81-php-intl \
    php81-php-bcmath \
    php81-php-gd \
    php81-php-soap \
    php81-php-mysqlnd \
    php81-php-xml \
    php81-php-mbstring \
    php81-php-cli \
    php81-php-opcache \
    php81-php-process \
    php81-php-pdo \
    php81-php-fpm \
    php81-php-ldap \
    php81-php-sodium \
    php81-php-pecl-xdebug \
    php81-php-intl \
    php81-php-bcmath \
    php81-php-ffi \
    php81-php-pecl-zip \
    php81-php-pecl-mailparse \
    php81-php-pecl-redis5 && \
    dnf clean all && \
    rm -rf /usr/share/tuleap && \
    sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf && \
    localedef -i fr_FR -c -f UTF-8 fr_FR.UTF-8 && \
    localedef -i pt_BR -c -f UTF-8 pt_BR.UTF-8

COPY xdebug-fpm.ini /etc/opt/remi/php81/php.d/15-xdebug.ini

## Run environment
ENV PHP_VERSION php81
WORKDIR /usr/share/tuleap
VOLUME [ "/data", "/usr/share/tuleap" ]
EXPOSE 22 80 443
CMD ["/usr/share/tuleap/tools/docker/tuleap-aio-dev/init"]
