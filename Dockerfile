# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_VERSION="1.1-edge"
ARG TAG="20191024"
ARG IMAGETYPE="application"
ARG LIZMAP_VERSION="3.3.0"
ARG QGISSERVER_VERSION="3.4"
ARG BASEIMAGE="huggla/qgisserver-alpine:$QGISSERVER_VERSION-20191018"
ARG INITCMDS=\
'   alpineVersion="$(egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release)" '\
'&& repoUrlPrefix="https://nginx.org/packages/mainline/alpine/v" '\
'&& if ! wget --spider -q "$repoUrlPrefix$alpineVersion"; '\
'   then '\
'      alpineVersion="$(echo "$alpineVersion" | awk -F . '"'"'{system("echo -n "$1". && expr "$2" - 1")}'"'"')"; '\
'   fi '\
'&& echo "$repoUrlPrefix$alpineVersion/main" >> /etc/apk/repositories'
ARG RUNDEPS="curl libressl fcgi php7 php7-fpm php7-tokenizer php7-opcache php7-session \
    php7-iconv php7-intl php7-mbstring php7-openssl php7-fileinfo php7-curl \
    php7-json php7-redis php7-pgsql php7-sqlite3 php7-gd php7-dom php7-xml \
    php7-xmlrpc php7-xmlreader php7-xmlwriter php7-simplexml php7-phar \
    php7-gettext php7-ctype php7-zip php7-ldap"
ARG RUNDEPS_UNTRUSTED="nginx"
ARG DOWNLOADS="https://github.com/3liz/lizmap-web-client/archive/$LIZMAP_VERSION.tar.gz"
ARG MAKEDIRS="/home/data/cache /var/www/html"
ARG BUILDCMDS=\
"   rm -rf lizmap-web-client-$LIZMAP_VERSION/vagrant "\
"&& mv lizmap-web-client-$LIZMAP_VERSION /finalfs/var/www/lizmap-web-client"
ARG FINALCMDS=\
"   ln -s /var/www/lizmap-web-client/lizmap/www /var/www/html/lizmap "\
"&& cd /var/www/lizmap-web-client "\
"&& cd lizmap/var/config "\
"&& mv lizmapConfig.ini.php.dist lizmapConfig.ini.php "\
"&& mv localconfig.ini.php.dist localconfig.ini.php "\
"&& mv profiles.ini.php.dist profiles.ini.php "\
"&& cd ../../.. "\
"&& mv /etc/nginx/sites-available/default.conf /etc/nginx/sites-available/default.conf.tmp "\
"&& php lizmap/install/installer.php "\
"&& sed -i '/^user /d' /etc/nginx/nginx.conf "\
"&& mv -f /etc/nginx/sites-available/default.conf.tmp /etc/nginx/sites-available/default.conf "\
"&& sed -i '/= nobody/d' /etc/php7/php-fpm.d/www.conf "\
"&& sed -i 's|= 127.0.0.1:9000|= /run/php7/php-fpm.sock|' /etc/php7/php-fpm.d/www.conf "\
"&& lizmap/install/set_rights.sh 102 102 "\
"&& cd /etc/nginx/conf.d "\
"&& ln -sf ../sites-available/default.conf default.conf "\
"&& cd /var/www/lizmap-web-client/lizmap "\
'&& tar -cpf var.tar.gz var '\
'&& rm -rf var'
ARG EXECUTABLES="/usr/sbin/nginx /usr/sbin/php-fpm7"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} as content1
FROM ${CONTENTIMAGE2:-scratch} as content2
FROM ${CONTENTIMAGE3:-scratch} as content3
FROM ${CONTENTIMAGE4:-scratch} as content4
FROM ${CONTENTIMAGE5:-scratch} as content5
FROM ${INITIMAGE:-${BASEIMAGE:-huggla/sam_$SaM_VERSION:base-$TAG}} as init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-huggla/sam_$SaM_VERSION:build-$TAG} as build
FROM ${BASEIMAGE:-huggla/sam_$SaM_VERSION:base-$TAG} as final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
ENV VAR_LINUX_USER="lizmap" \
    VAR_LIZMAP_CONFIG_DIR="/etc/lizmap" \
    VAR_NGINX_CONFIG_FILE="/etc/nginx/nginx.conf" \
    VAR_NGINX_CONFIG_DIR="/etc/nginx/conf.d" \
    VAR_FINAL_COMMAND='/usr/local/bin/spawn-fcgi -d $VAR_PROJECT_STORAGE_DIR -s $VAR_SOCKET_DIR/fastcgi.sock -M 777 -- /usr/local/bin/multiwatch -f $VAR_FCGICHILDREN /usr/qgis/qgis_mapserv.fcgi && php-fpm7 && VAR_SERVER_NAME=$VAR_SERVER_NAME VAR_SERVER_PORT=$VAR_SERVER_PORT nginx -c "$VAR_NGINX_CONFIG_FILE" -g "daemon off;"' \
    VAR_NGINX_LOG_DIR="/var/log/nginx" \
    VAR_NGINX_SOCKET_DIR="/run/nginx" \
    VAR_NGINX_CACHE_DIR="/var/cache/nginx" \
    VAR_PHPFPM_LOG_DIR="/var/log/php7" \
    VAR_PHPFPM_SOCKET_DIR="/run/php7" \
    VAR_SERVER_NAME="localhost" \
    VAR_SERVER_PORT="8080"
STOPSIGNAL SIGTERM

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>
