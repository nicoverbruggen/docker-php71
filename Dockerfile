FROM php:7.1.20

# Add a user "automation"
RUN useradd automation --shell /bin/bash --create-home

# PHP configuration & debugging
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

# Install Python
RUN apt-get -yqq update && \
    apt-get -yqq install curl unzip && \
    apt-get -yqq install xvfb tinywm && \
    apt-get -yqq install fonts-ipafont-gothic xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic && \
    apt-get -yqq install python && \
    rm -rf /var/lib/apt/lists/*

# Install Supervisor
RUN curl -sS -o - https://bootstrap.pypa.io/ez_setup.py | python && \
    easy_install -q supervisor

# Install Chrome WebDriver
RUN CHROMEDRIVER_VERSION=`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    mkdir -p /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROMEDRIVER_VERSION && \
    rm /tmp/chromedriver_linux64.zip && \
    chmod +x /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver && \
    ln -fs /opt/chromedriver-$CHROMEDRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# Install Google Chrome
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
    apt-get -yqq update && \
    apt-get -yqq install google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Configure Supervisor
ADD ./etc/supervisord.conf /etc/
ADD ./etc/supervisor /etc/supervisor

# Default configuration
ENV DISPLAY :20.0
ENV SCREEN_GEOMETRY "1440x900x24"
ENV CHROMEDRIVER_PORT 4444
ENV CHROMEDRIVER_WHITELISTED_IPS "127.0.0.1"
ENV CHROMEDRIVER_URL_BASE ''

EXPOSE 4444

VOLUME [ "/var/log/supervisor" ]

CMD ["/usr/local/bin/supervisord", "-c", "/etc/supervisord.conf"]