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
    # Install PHP Extensions        
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install mbstring mcrypt pdo pdo_pgsql pdo_mysql mysqli \
        curl json intl gd xml zip bz2 opcache \
    # Install XDebug    
    && pecl install xdebug-2.5.5 \
    && docker-php-ext-enable xdebug

# Set up Node JS 10.x
RUN apt-get install gnupg2 -yqq \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt-get install gcc g++ make -yqq \
    && apt-get install -y nodejs -yqq \
    && curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install yarn -yqq