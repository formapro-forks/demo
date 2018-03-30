FROM formapro/nginx-php-fpm:latest-all-exts

RUN apt-get update && \
    apt-get -y --no-install-recommends --no-install-suggests install php-sqlite3

ADD . /app
WORKDIR /app
RUN chown -R "www-data:www-data" /app

ENV NGINX_WEB_ROOT=/app/public
ENV SHELL_VERBOSITY=3
