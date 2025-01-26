FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    nginx \
    git \
    composer \
    php8.1 \
    php8.1-fpm \
    php8.1-mysql \
    mysql-server \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 3306 80

CMD service mysql start && service php8.1-fpm start && nginx -g "daemon off;" 