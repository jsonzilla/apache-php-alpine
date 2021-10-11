FROM alpine:edge

# PHP and Apache2
RUN export phpverx=$(alpinever=$(cat /etc/alpine-release|cut -d '.' -f1);[ $alpinever -ge 9 ] && echo  7|| echo 5)
RUN apk add apache2 php$phpverx-apache2 php7

## Add files
## ADD . /var/www/localhost/htdocs

# Add dependency
RUN apk add curl ca-certificates openssl \
    php7-soap php7-xml php7-curl php7-json \
    php7-phar php7-iconv php7-mbstring \
    php7-openssl

# Add extras
RUN apk add tzdata openntpd nano \
    php7-ftp php7-xdebug php7-mcrypt php7-gmp \
    php7-gmp php7-pdo_odbc php7-dom php7-pdo php7-zip \
    php7-mysqli php7-sqlite3 php7-pdo_pgsql php7-bcmath \
    php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite \
    php7-gettext php7-xml php7-xmlreader php7-xmlwriter \
    php7-tokenizer php7-xmlrpc php7-bz2 php7-pdo_dblib \
    php7-ctype php7-session php7-redis php7-exif php7-intl \
    php7-fileinfo php7-ldap php7-simplexml

# Install o composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN composer require php-comp/lite-cache

# Cleanup
RUN rm -rf /tmp/* /var/cache/apk/*

# Run Apache2
CMD exec /usr/sbin/httpd -D FOREGROUND
EXPOSE 80
