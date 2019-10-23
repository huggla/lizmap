# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG TAG="20191018"
ARG IMAGETYPE="application,base"
ARG LIZMAP_VERSION="master"
ARG BASEIMAGE="huggla/qgisserver-alpine:$TAG"
ARG ADDREPOS="http://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS="nginx curl libressl fcgi php7 php7-fpm php7-tokenizer php7-opcache php7-session \
    php7-iconv php7-intl php7-mbstring php7-openssl php7-fileinfo php7-curl \
    php7-json php7-redis php7-pgsql php7-sqlite3 php7-gd php7-dom php7-xml \
    php7-xmlrpc php7-xmlreader php7-xmlwriter php7-simplexml php7-phar \
    php7-gettext php7-ctype php7-zip php7-ldap"
ARG DOWNLOADS="https://github.com/3liz/lizmap-web-client/archive/$LIZMAP_VERSION.tar.gz"
ARG MAKEDIRS="/home/data/cache /var/www/html"
ARG BUILDCMDS=\
"   rm -rf lizmap-web-client-3.3.0/vagrant "\
'&& mv lizmap-web-client-3.3.0 "/finalfs/var/www"'
ARG FINALCMDS=\
"   ln -s /var/www/lizmap-web-client-$LIZMAP_VERSION/lizmap/www /var/www/html/lizmap "\
"&& cd /var/www/lizmap-web-client-$LIZMAP_VERSION "\
"&& lizmap/install/set_rights.sh www-data www-data "\
"&& cd lizmap/var/config "\
"&& cp lizmapConfig.ini.php.dist lizmapConfig.ini.php "\
"&& cp localconfig.ini.php.dist localconfig.ini.php "\
"&& cp profiles.ini.php.dist profiles.ini.php "\
"&& cd ../../.. "\
"&& php lizmap/install/installer.php"
ARG STARTUPEXECUTABLES="/usr/sbin/php-fpm7"
