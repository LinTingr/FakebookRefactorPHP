FROM composer:latest as composer

FROM php:8.2.6-fpm-alpine

EXPOSE 9000

RUN apk update

RUN --mount=type=bind,from=mlocati/php-extension-installer:1.5,source=/usr/bin/install-php-extensions,target=/usr/local/bin/install-php-extensions \
     install-php-extensions gd bcmath pdo_mysql mysqli zip xsl dom exif intl pcntl sockets mongodb redis swoole && \
     apk del --no-cache ${PHPIZE_DEPS} ${BUILD_DEPENDS}

RUN echo 'memory_limit = -1' >> "$PHP_INI_DIR/php.ini-production"
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /var/www/app
COPY . /var/www/app

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

# CMD ["/bin/sh"]
CMD ["php-fpm"]