FROM ubuntu:22.04

MAINTAINER Tin Benjamin Matuka <mail@tbmatuka.com>

# set up timezone
ENV TIMEZONE="UTC"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# install deps, apache, php and php modules all in one run and clean up afterwards to reduce the snapshot size
RUN apt-get clean && \
    apt-get -y update && \
    apt-get install -y --force-yes \
        locales \
        curl \
        software-properties-common \
        git \
        apt-transport-https \
        sudo \
        nvi \
        iproute2 \
        telnet \
        dnsutils \
        unzip \
        rsync \
        nodejs \
        npm \
        inetutils-ping && \
    locale-gen en_US.UTF-8 && \
    LC_ALL=en_US.UTF-8 add-apt-repository ppa:ondrej/php && apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes \
        imagemagick \
        php8.2 php8.2-amqp php8.2-apcu php8.2-bcmath php8.2-bz2 php8.2-cgi php8.2-cli php8.2-common php8.2-curl php8.2-dev php8.2-gd php8.2-gmp php8.2-imagick php8.2-imap php8.2-intl php8.2-ldap php8.2-mailparse php8.2-mbstring php8.2-memcached php8.2-mysql php8.2-odbc php8.2-opcache php8.2-pgsql php8.2-pspell php8.2-readline php8.2-redis php8.2-snmp php8.2-soap php8.2-sqlite3 php8.2-tidy php8.2-uuid php8.2-xml php8.2-xsl php8.2-yaml php8.2-zip php8.2-zmq \
        php-mail && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

# set php version as active
RUN update-alternatives --set php "/usr/bin/php8.2"

# add www-data to sudoers
COPY ./sudoers /etc/sudoers.d/www-data

# prepare www-data to be used as main user
RUN usermod -s /bin/bash -G staff www-data && \
    mkdir -p /var/www /app && \
    touch /var/www/.bash_profile && \
    chown -R www-data. /var/www /app

# install composer
RUN curl https://getcomposer.org/composer-1.phar > composer1 && \
    curl https://getcomposer.org/composer-2.phar > composer && \
    mv composer1 composer /usr/local/bin/ && \
    chown www-data:www-data /usr/local/bin/composer1 /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer1 /usr/local/bin/composer

# install yarn without nodejs
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends yarn && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# this lets us make our build behave differently if needed
ENV DOCKER="yes"

# prepare entrypoint and default command
COPY ./entrypoint.sh /usr/local/bin/

WORKDIR /app/

USER www-data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD []
