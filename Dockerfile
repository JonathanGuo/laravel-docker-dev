FROM php:7.2-fpm-alpine
LABEL maintainer="jonathan <chc.jonathan.guo@outlook.com>"

WORKDIR /app

# Install system packages
RUN apk update && \
    apk upgrade && \
    apk add --no-cache bash \
        git \
        freetds \
        freetype \
        icu \
        libintl \
        libldap \
        libjpeg \
        libmcrypt \
        libpng \
        libpq \
        libwebp \
        supervisor \
        nginx \
        nodejs && \
    apk add --no-cache --virtual build-dependencies \
        curl-dev \
        freetds-dev \
        freetype-dev \
        gettext-dev \
        icu-dev \
        jpeg-dev \
        libmcrypt-dev \
        libpng-dev \
        libwebp-dev \
        libxml2-dev \
        openldap-dev \
        postgresql-dev \
        zlib-dev \
        autoconf \
        build-base && \
    docker-php-ext-configure gd \
        --with-freetype-dir=/usr/include/ \
        --with-png-dir=/usr/include/ \
        --with-jpeg-dir=/usr/include/ && \
    docker-php-ext-configure ldap --with-libdir=lib/ && \
    docker-php-ext-configure pdo_dblib --with-libdir=lib/ && \
    docker-php-ext-install \
        curl \
        exif \
        gd \
        gettext \
        intl \
        opcache \
        pdo_mysql \
        pdo_pgsql \
        pdo_dblib \
        soap \
        zip && \
    pecl install xdebug && \
    pecl install grpc && \
    docker-php-ext-enable xdebug grpc && \
    echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.default_enable=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_host=docker.for.mac.localhost" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_port=9005" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_connect_back=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.remote_log=/tmp/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apk del build-dependencies

ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD supervisor/supervisord.conf /etc/supervisord.conf

# Download trusted certs 
RUN mkdir -p /etc/ssl/certs && update-ca-certificates

CMD ["supervisord", "--nodaemon"]

EXPOSE 80