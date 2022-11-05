FROM php:8.1-fpm

MAINTAINER jinsoo.kim <jjambbongjoa@gmail.com>

# -----------------------------------------------------------------------------
### SERVER COMMON Configuration
# -----------------------------------------------------------------------------
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime \
 && sed -i -- 's/^# alias/alias/g' /root/.bashrc \
 && sed -i -- 's/^# export/export/g' /root/.bashrc

# 한국 미러 서버로 변경
#RUN sed -i 's/deb.debian.org/mirror.kakao.com/g' /etc/apt/sources.list

RUN apt-get update --fix-missing && apt-get install -y git iputils-ping net-tools

# -----------------------------------------------------------------------------
### PHP/-FPM Configuration
# -----------------------------------------------------------------------------
# - ORIGIN BACKUP
RUN mv /usr/local/etc/php-fpm.d /usr/local/etc/php-fpm.d-ORIGIN
COPY php.ini /usr/local/etc/php/
# - CHANGE Configuration
COPY www.pool.conf /usr/local/etc/php-fpm.d/


# -----------------------------------------------------------------------------
### PHP-Composer
# -----------------------------------------------------------------------------
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN cd /usr/local/bin && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && chmod u+x ./composer.phar \
    && cd -

RUN cp /usr/local/bin/composer.phar /usr/local/bin/composer

RUN apt-get update

# -----------------------------------------------------------------------------
### PHP Extensions Install
# -----------------------------------------------------------------------------
# @see refs https://github.com/m2sh/php7/blob/master/Dockerfile
RUN pecl channel-update pecl.php.net

RUN apt-get install -y \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxml2-dev \
        zlib1g-dev \
        libzip-dev \
        libonig-dev \
        libfreetype6-dev \
 && docker-php-ext-configure gd --with-jpeg=/usr/include --with-freetype \
 && docker-php-ext-install gd \
 && docker-php-ext-install pdo_mysql \
 && docker-php-ext-install mbstring \
 && docker-php-ext-install opcache \
 && docker-php-ext-install soap \
 && docker-php-ext-install zip

# mongodb
RUN apt-get install -y \
        libcurl4-openssl-dev \
        pkg-config \
        libssl-dev
RUN pecl install mongodb \
 && docker-php-ext-enable mongodb

# imagemagick
RUN apt-get install -y \
        libmagickwand-dev --no-install-recommends
RUN pecl install imagick \
 && docker-php-ext-enable imagick

# SSH2
RUN apt-get install -y libssh2-1-dev
RUN pecl install ssh2-1.3.1 && docker-php-ext-enable ssh2

WORKDIR /var/workspace/php

#CMD ["php-fpm", "-F"]
