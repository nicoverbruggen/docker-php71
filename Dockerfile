FROM php:7.1.13
RUN apt-get update -yqq \
    && apt-get install git \
            libmcrypt-dev libpq-dev libcurl4-gnutls-dev \
            libicu-dev libvpx-dev libjpeg-dev libpng-dev \
            libxpm-dev zlib1g-dev libfreetype6-dev libxml2-dev \
            libexpat1-dev libbz2-dev libgmp3-dev libldap2-dev \
            unixodbc-dev libsqlite3-dev libaspell-dev \
            libsnmp-dev libpcre3-dev libtidy-dev -yqq \
    && docker-php-ext-install mbstring mcrypt pdo pdo_pgsql pdo_mysql mysqli \
    curl json intl gd xml zip bz2 opcache \
    && pecl install xdebug-2.5.0 \
    && docker-php-ext-enable xdebug