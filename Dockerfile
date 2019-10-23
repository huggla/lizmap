# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="1.0"
ARG TAG="20191018"
ARG IMAGETYPE="application"
ARG LIZMAP_VERSION="3.3.0"
ARG QGISSERVER_VERSION="3.4-20191007"
ARG BASEIMAGE="huggla/qgisserver-alpine:$QGISSERVER_VERSION"
ARG RUNDEPS="nginx curl libressl fcgi php7 php7-fpm php7-tokenizer php7-opcache php7-session \
    php7-iconv php7-intl php7-mbstring php7-openssl php7-fileinfo php7-curl \
    php7-json php7-redis php7-pgsql php7-sqlite3 php7-gd php7-dom php7-xml \
    php7-xmlrpc php7-xmlreader php7-xmlwriter php7-simplexml php7-phar \
    php7-gettext php7-ctype php7-zip php7-ldap"
ARG DOWNLOADS="https://github.com/3liz/lizmap-web-client/archive/$LIZMAP_VERSION.tar.gz"
ARG MAKEDIRS="/home/data/cache /var/www/html"
ARG BUILDCMDS=\
"   rm -rf lizmap-web-client-$LIZMAP_VERSION/vagrant "\
"&& mv lizmap-web-client-$LIZMAP_VERSION /finalfs/var/www"
ARG FINALCMDS=\
"   ln -s /var/www/lizmap-web-client-$LIZMAP_VERSION/lizmap/www /var/www/html/lizmap "\
"&& cd /var/www/lizmap-web-client-$LIZMAP_VERSION "\
"&& lizmap/install/set_rights.sh 102 102 "\
"&& cd lizmap/var/config "\
"&& cp lizmapConfig.ini.php.dist lizmapConfig.ini.php "\
"&& cp localconfig.ini.php.dist localconfig.ini.php "\
"&& cp profiles.ini.php.dist profiles.ini.php "\
"&& cd ../../.. "\
"&& php lizmap/install/installer.php "\
"&& ln -s /tmp /var/lib/nginx/ "\
"&& sed -i 's/80 default/8080 default/g' /etc/nginx/conf.d/default.conf"
ARG EXECUTABLES="/usr/sbin/nginx"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/base:$SaM_VERSION-$TAG}} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/build:$SaM_VERSION-$TAG} as build
FROM ${BASEIMAGE:-huggla/base:$SaM_VERSION-$TAG} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
ENV VAR_LINUX_USER="nginx" \
    VAR_FINAL_COMMAND="nginx" \
    VAR_LOG_DIR="/var/log/nginx" \
    VAR_SOCKET_DIR="/run/nginx"
STOPSIGNAL SIGTERM

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
