FROM php:7.0-apache
MAINTAINER McKay Software <hello@mckaysoftware.co.nz>

CMD /start
ENV APP_LOG=errorlog
EXPOSE 80
WORKDIR /var/www/html

COPY ./php.ini /usr/local/etc/php/
COPY ./setup ./start /

RUN apt-get update &&\
    apt-get install -y curl vim git unzip libfreetype6-dev \
      libjpeg62-turbo-dev libmcrypt-dev libpng12-dev &&\
    docker-php-ext-install -j$(nproc) iconv mcrypt &&\
    docker-php-ext-configure gd \
      --with-freetype-dir=/usr/include/ \
      --with-jpeg-dir=/usr/include/ &&\
    docker-php-ext-install -j$(nproc) gd pdo pdo_mysql exif &&\
    curl -sS https://getcomposer.org/installer | php &&\
    mv composer.phar /usr/bin/composer &&\
    a2enmod rewrite &&\
    sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' \
      /etc/apache2/sites-enabled/000-default.conf &&\
    chmod +x /setup /start

