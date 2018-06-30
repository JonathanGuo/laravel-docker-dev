# Laravel Docker Dev

This is a image for you to quickly start running a Laravel application in docker. The image contains xdebug so you don't want to use it for production.

## Volumes mount

`/app` - The directory the application should be mounted to


## Enable xDebug (OSX)

Since I personally develop apps in OSX, so I've created the image contains the predefined xdebug remote host. 

### OSX Quirks

This is a solution for using xDebug in OSX. [Read more details](https://gist.github.com/ralphschindler/535dc5916ccbd06f53c1b0ee5a868c93)

For people don't want to read text, please just run the command below.

```shell
sudo curl -o /Library/LaunchDaemons/com.ralphschindler.docker_10254_alias.plist https://gist.githubusercontent.com/ralphschindler/535dc5916ccbd06f53c1b0ee5a868c93/raw/com.ralphschindler.docker_10254_alias.plist
```

After reboot you will have the alias set up.

Or, you just want to try it out without rebooting or adding a startup script:

```shell
ifconfig lo0 alias 10.254.254.254
```

### A sample usage with docker-compose

docker-composer.yml


```yml
version: '3'
services:
  php:
    image: chcjonathanguo/laravel-docker-dev:latest
    links:
      - "db:db"
    volumes:
      - ./:/app:delegated
    ports:
      - '8000:80'
  db:
    image: mysql:5.7
    restart: always
    volumes:
      - db-data:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD:
      MYSQL_DATABASE: app
      MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
    ports:
      - '33060:3306'
volumes:
    db-data:
```