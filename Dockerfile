FROM php:7.3-fpm-alpine
LABEL maintainer="jonathan <chc.jonathan.guo@outlook.com>"

WORKDIR /app

ENV PHP_XDEBUG_REMOTE_ENABLE=${PHP_XDEBUG_REMOTE_ENABLE:-on}
ENV PHP_XDEBUG_REMOTE_AUTOSTART=${PHP_XDEBUG_REMOTE_AUTOSTART:-on}
ENV PHP_XDEBUG_DEFAULT_ENABLE=${PHP_XDEBUG_DEFAULT_ENABLE:-off}
ENV PHP_XDEBUG_REMOTE_HOST=${PHP_XDEBUG_REMOTE_HOST:-docker.for.mac.localhost}
ENV PHP_XDEBUG_REMOTE_PORT=${PHP_XDEBUG_REMOTE_PORT:-9000}
ENV PHP_XDEBUG_REMOTE_CONNECT_BACK=${PHP_XDEBUG_REMOTE_CONNECT_BACK:-off}
ENV PHP_XDEBUG_IDEKEY=${PHP_XDEBUG_IDEKEY:-PHPSTORM}
ENV ENABLE_CRON_JOB=${ENABLE_CRON_JOB:-false}
ENV ENABLE_LARAVEL_WORKER=${ENABLE_LARAVEL_WORKER:-false}
ENV ENV_ENABLE_LARAVEL_HORIZON=${ENV_ENABLE_LARAVEL_HORIZON:-false}

COPY config /tmp/config

# Install system packages
RUN apk update && \
    apk add --no-cache \
        bash \
        git \
        freetds \
        freetype \
        icu \
        libintl \
        libldap \
        libjpeg \
        libpng \
        libpq \
        libwebp \
        libmemcached \
        supervisor \
        libzip \
        composer && \
    apk add --no-cache --virtual build-dependencies \
        curl-dev \
        freetds-dev \
        freetype-dev \
        gettext-dev \
        icu-dev \
        jpeg-dev \
        libpng-dev \
        libwebp-dev \
        libxml2-dev \
        libzip-dev \
        libmemcached-dev \
        openldap-dev \
        postgresql-dev \
        zlib-dev \
        autoconf \
        build-base && \
# Install PHP extensions
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure ldap --with-libdir=lib/ && \
    docker-php-ext-configure pdo_dblib --with-libdir=lib/ && \
    docker-php-ext-install \
        bcmath \
        curl \
        gettext \
        gd \
        exif \
        iconv \
        intl \
        ldap \
        mbstring \
        pdo_mysql \
        pdo_pgsql \
        pdo_dblib \
        soap \
        sockets \
        zip \
        pcntl && \
# Install PECL extensions
    pecl install xdebug-2.7.2 grpc memcached && \
    docker-php-ext-enable xdebug grpc memcached && \
    echo "xdebug.remote_enable=${PHP_XDEBUG_REMOTE_ENABLE}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_autostart=${PHP_XDEBUG_REMOTE_AUTOSTART}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.default_enable=${PHP_XDEBUG_DEFAULT_ENABLE}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_host=${PHP_XDEBUG_REMOTE_HOST}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_port=${PHP_XDEBUG_REMOTE_PORT}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_connect_back=${PHP_XDEBUG_REMOTE_CONNECT_BACK}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.idekey=${PHP_XDEBUG_IDEKEY}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    apk del build-dependencies && \
# Download trusted certs
    mkdir -p /etc/ssl/certs && update-ca-certificates && \
# Copy php configuration
    cp /tmp/config/php.ini /usr/local/etc/php/php.ini && \
# Copy supervisor config
    mkdir /etc/supervisor.d && \
    cp /tmp/config/supervisord.conf /etc/supervisord.conf && \
    cp -r /tmp/config/supervisor.d /etc && \
# Copy cron job
    cp /tmp/config/crontab /etc/crontabs/root && \
    cp /tmp/config/entrypoint.sh /entrypoint.sh && \
    rm -rf /tmp/config && \
    chmod a+x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
