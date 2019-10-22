# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG TAG="20191018"
ARG IMAGETYPE="application,base"
ARG LIZMAP_VERSION="master"
ARG BASEIMAGE="huggla/qgisserver-alpine:$TAG"
ARG ADDREPOS="http://dl-cdn.alpinelinux.org/alpine/edge/testing"
ARG RUNDEPS="fcgi php7 php7-fpm php7-tokenizer php7-opcache php7-session \
    php7-iconv php7-intl php7-mbstring php7-openssl php7-fileinfo php7-curl \
    php7-json php7-redis php7-pgsql php7-sqlite3 php7-gd php7-dom php7-xml \
    php7-xmlrpc php7-xmlreader php7-xmlwriter php7-simplexml php7-phar \
    php7-gettext php7-ctype php7-zip php7-ldap"
ARG CLONEGITS="'--branch $LIZMAP_VERSION --depth=1 https://github.com/3liz/lizmap-web-client.git lizmap-web-client'"
ARG BUILDCMDS=\
"   rm -rf lizmap-web-client/vagrant lizmap-web-client/.git "\
"&& mv lizmap-web-client /www "\
"&& mv /www/lizmap/var/config /www/lizmap/var/config.dist \
    && mv /www/lizmap/www /www/lizmap/www.dist
ARG STARTUPEXECUTABLES="/usr/sbin/php-fpm7"
