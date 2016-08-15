FROM php:7.0-apache
MAINTAINER McKay Software <hello@mckaysoftware.co.nz>

CMD /scripts/start
ENV PHP_MEMORY_LIMIT 512M
EXPOSE 80
WORKDIR /var/www/html

RUN apt-get update &&\
    apt-get install -y curl vim git unzip libfreetype6-dev \
      libjpeg62-turbo-dev libmcrypt-dev libpng12-dev &&\
    apt-get autoremove && rm -rf /var/lib/apt/lists/* &&\
    docker-php-ext-install -j$(nproc) iconv mcrypt &&\
    docker-php-ext-configure gd \
      --with-freetype-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ &&\
    docker-php-ext-install -j$(nproc) gd pdo pdo_mysql exif &&\
    curl -sS https://getcomposer.org/installer | php &&\
    mv composer.phar /usr/bin/composer &&\
    a2enmod rewrite &&\
    sed -i 's|#LogLevel info ssl:warn|SetEnvIf Authorization "(.*)" HTTP_AUTHORIZATION=$1|' \
      /etc/apache2/sites-enabled/000-default.conf

COPY ./php.ini /usr/local/etc/php/
COPY ./scripts /scripts
RUN cd /scripts && chmod +x setup start
