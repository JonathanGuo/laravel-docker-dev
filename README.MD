# Laravel Docker Dev

This is a image for you to quickly start running a Laravel application in docker. The image contains xdebug so you don't want to use it for production.

`Composer` comes with the image.

## Supported tags and respective Dockerfile links

- [`latest` (Dockerfile)](https://github.com/JonathanGuo/laravel-docker-dev/blob/master/Dockerfile) - PHP-FPM 7.2 alpine
- [`1.0` (Dockerfile)](https://github.com/JonathanGuo/laravel-docker-dev/blob/1.0/Dockerfile) - PHP-FPM 7.0 alpine

## PHP Extensions

- [x] bcmath
- [x] curl
- [x] gettext
- [x] gd
- [x] exif
- [x] iconv
- [x] intl
- [x] ldap
- [x] mbstring
- [x] opcache
- [x] pdo_mysql
- [x] pdo_pgsql
- [x] pdo_dblib
- [x] soap
- [x] sockets
- [x] zip
- [x] xdebug
- [x] grpc
- [x] memcached

## Environment variables

The image the environment variables below:

```
PHP_XDEBUG_REMOTE_ENABLE: on
PHP_XDEBUG_REMOTE_AUTOSTART: on
PHP_XDEBUG_DEFAULT_ENABLE: off
PHP_XDEBUG_REMOTE_HOST: docker.for.mac.localhost
PHP_XDEBUG_REMOTE_PORT: 9000
PHP_XDEBUG_REMOTE_CONNECT_BACK: off
PHP_XDEBUG_IDEKEY: PHPSTORM
```

## Volumes mount

`/app` - The directory the application should be mounted to

### A sample usage with docker-compose

docker-composer.yml


```yml
version: '3'
services:
  php:
    image: chcjonathanguo/laravel-docker-dev:latest
    volumes:
      - ./:/app:delegated
    ports:
      - '8000:80'
    volumes:
      - ~/.composer-docker/cache:/root/.composer/cache:delegated
      - ./:/app:delegated
    environment:
      PHP_IDE_CONFIG: "serverName=myapp.domain"
  nginx:
    image: nginx:latest
    depends_on:
      - php
    volumes:
      - ./:/app:delegated
      - ./docker-config/dev/nginx/default.conf:/etc/nginx/conf.d/default.conf
```