FROM php:7.1.20

# Add a user "automation"
RUN useradd automation --shell /bin/bash --create-home

# PHP configuration & debugging
RUN apt-get update -yqq \
    && apt-get install git \
            libmcrypt-dev libpq-dev libcurl4-gnutls-dev \
            libicu-dev libvpx-dev libjpeg-dev libpng-dev \
            libxpm-dev zlib1g-dev libjpeg62-turbo-dev libfreetype6-dev libxml2-dev \
            libexpat1-dev libbz2-dev libgmp3-dev libldap2-dev \
            unixodbc-dev libsqlite3-dev libaspell-dev \
            libsnmp-dev libpcre3-dev libtidy-dev -yqq \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install mbstring mcrypt pdo pdo_pgsql pdo_mysql mysqli \
    curl json intl gd xml zip bz2 opcache \
    && pecl install xdebug-2.5.0 \
    && docker-php-ext-enable xdebug

# Install Python
RUN apt-get -yqq update && \
    apt-get -yqq install curl unzip && \
    apt-get -yqq install xvfb tinywm && \
    apt-get -yqq install fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic && \
    apt-get -yqq install python && \
    rm -rf /var/lib/apt/lists/*