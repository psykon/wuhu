FROM php:7.4-apache
LABEL Name=wuhu Version=0.0.1
RUN apt-get update && apt-get install -y \
        libpng-dev \
        zlib1g-dev \
        libjpeg62-turbo-dev \
        libfreetype6-dev \
        libcurl4-openssl-dev \
        libonig-dev

RUN docker-php-ext-install gd &&\
    docker-php-ext-install mysqli &&\
    docker-php-ext-install pdo pdo_mysql &&\
    docker-php-ext-install curl &&\
    docker-php-ext-install mbstring

RUN chmod -R g+rw /var/www
RUN chown -R www-data:www-data /var/www

RUN mkdir /var/www/entries_private
RUN mkdir /var/www/entries_public
RUN mkdir /var/www/screenshots

# RUN mkdir /var/log/apache
COPY www_party/ /var/www/www_party
COPY www_admin/ /var/www/www_admin

RUN chmod -R g+rw /var/www/*
RUN chown -R www-data:www-data /var/www/*


COPY config/php.ini "$PHP_INI_DIR/php.ini"
COPY config/wuhu.conf /etc/apache2/sites-available/


# RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf &&\
    echo "Listen 8080" >> /etc/apache2/apache2.conf &&\
    echo "Listen 8090" >> /etc/apache2/apache2.conf &&\
    a2enmod rewrite &&\
    a2enmod authz_groupfile &&\
    a2dissite 000-default &&\
    a2ensite wuhu &&\
    service apache2 restart

# RUN a2ensite wuhu
# RUN service apache2 restart

# ENV APACHE_RUN_DIR=/var/run/apache2
# ENV APACHE_LOCK_DIR=/var/lock/apache2
# ENV APACHE_LOG_DIR=/var/log/apache
# ENV APACHE_RUN_USER=www-data
# ENV APACHE_RUN_GROUP=www-data
# ENV APACHE_PID_FILE=/var/run/apache2/apache2.pid


EXPOSE 8080
EXPOSE 8090
EXPOSE 80

#CMD ["/usr/sbin/apache2"]
    
