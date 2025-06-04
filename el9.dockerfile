FROM rockylinux@sha256:d7be1c094cc5845ee815d4632fe377514ee6ebcf8efaed6892889657e5ddaaa6

ARG PHP_BASE

ENV container docker

STOPSIGNAL SIGRTMIN+3

COPY ${PHP_BASE}-tuleap-php-fpm-override.conf /etc/systemd/system/tuleap-php-fpm.service.d/override.conf
COPY xdebug-fpm.ini /etc/opt/remi/${PHP_BASE}/php.d/15-xdebug.ini

RUN rm -f /lib/systemd/system/multi-user.target.wants/*;\
    rm -f /etc/systemd/system/*.wants/*;\
    rm -f /lib/systemd/system/local-fs.target.wants/*; \
    rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
    rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
    rm -f /lib/systemd/system/basic.target.wants/*;\
    rm -f /lib/systemd/system/anaconda.target.wants/* && \
    dnf install -y \
        epel-release \
        rocky-release-security \
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
    tuleap-plugin-gitlfs \
    tuleap-plugin-svn \
    tuleap-plugin-hudson\* \
    tuleap-plugin-mediawiki \
    tuleap-plugin-mediawiki-standalone \
    tuleap-plugin-ldap \
    tuleap-api-explorer \
    java-1.8.0-openjdk \
    openldap-clients \
    vim \
    mysql \
    less \
    ${PHP_BASE}-php-intl \
    ${PHP_BASE}-php-bcmath \
    ${PHP_BASE}-php-gd \
    ${PHP_BASE}-php-soap \
    ${PHP_BASE}-php-mysqlnd \
    ${PHP_BASE}-php-xml \
    ${PHP_BASE}-php-mbstring \
    ${PHP_BASE}-php-cli \
    ${PHP_BASE}-php-opcache \
    ${PHP_BASE}-php-process \
    ${PHP_BASE}-php-pdo \
    ${PHP_BASE}-php-fpm \
    ${PHP_BASE}-php-ldap \
    ${PHP_BASE}-php-sodium \
    ${PHP_BASE}-php-pecl-xdebug \
    ${PHP_BASE}-php-intl \
    ${PHP_BASE}-php-bcmath \
    ${PHP_BASE}-php-ffi \
    ${PHP_BASE}-php-pecl-zip \
    ${PHP_BASE}-php-pecl-mailparse \
    ${PHP_BASE}-php-pecl-redis5 && \
    dnf clean all && \
    rm -rf /usr/share/tuleap && \
    sed -i 's/inet_interfaces = localhost/inet_interfaces = all/' /etc/postfix/main.cf && \
    localedef -i fr_FR -c -f UTF-8 fr_FR.UTF-8 && \
    localedef -i pt_BR -c -f UTF-8 pt_BR.UTF-8

## Run environment
ENV PHP_VERSION php82
WORKDIR /usr/share/tuleap
VOLUME [ "/data", "/usr/share/tuleap" ]
EXPOSE 22 80 443
CMD ["/usr/share/tuleap/tools/docker/tuleap-aio-dev/init"]
