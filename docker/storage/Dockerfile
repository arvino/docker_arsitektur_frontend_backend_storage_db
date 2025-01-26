FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    nginx \
    git \
    composer \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/sites-available/default

# Membuat direktori yang diperlukan
RUN mkdir -p /var/www/public/uploads \
    && chown -R www-data:www-data /var/www/public \
    && chmod -R 755 /var/www/public

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"] 