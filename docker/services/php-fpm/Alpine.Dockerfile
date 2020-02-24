FROM php:7.2-fpm-alpine

#MAINTAINER dzmitry.danilau@innowise-group.com

RUN set -xe \
    && apk update \
    && apk add bash curl wget \
    #gd
        freetype-dev \
    #intl
        icu-dev \
    #gettext
        gettext-dev \
    #zip
        zlib-dev

RUN set -xe \
	&& apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && docker-php-ext-install gd \
    && docker-php-ext-install intl \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pdo \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install zip \
    # Pecl
    && pecl install igbinary redis && docker-php-ext-enable redis \
    # Cleaning up
    && apk del --no-network .build-deps

COPY entrypoint.sh /usr/local/bin
COPY docker-php-composer-install.sh /usr/local/bin

RUN set -xe \
    && rm -rf /var/www \
    && /usr/bin/install -m 0775 -o www-data -g www-data -d \
    /var/www/ \
    /var/www/logs \
    /var/www/src/ \
    /var/www/.composer

RUN chown -R www-data:www-data /var/www/src
RUN chmod 777 /var/www/src/

VOLUME ["/var/www/logs", "/var/www/.composer"]

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["php-fpm"]