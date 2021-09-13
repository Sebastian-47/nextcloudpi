#!/bin/bash

# Nextcloud LAMP base installation on Raspbian
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# Usage:
#
#   ./installer.sh lamp.sh <IP> (<img>)
#
# See installer.sh instructions for details
#
# Notes:
#   Upon each necessary restart, the system will cut the SSH session, therefore
#   it is required to save the state of the installation. See variable $STATE_FILE
#   It will be necessary to invoke this a number of times for a complete installation
#
# More at https://ownyourbits.com/2017/02/13/nextcloud-ready-raspberry-pi-image/
#

source /usr/local/etc/library.sh # sets PHPVER RELEASE

APTINSTALL="apt-get install -y --no-install-recommends"
export DEBIAN_FRONTEND=noninteractive

install()
{
    apt-get update
    $APTINSTALL apt-utils cron curl
    $APTINSTALL apache2

    $APTINSTALL -t $RELEASE php${PHPVER} php${PHPVER}-curl php${PHPVER}-gd php${PHPVER}-fpm php${PHPVER}-cli php${PHPVER}-opcache \
                            php${PHPVER}-mbstring php${PHPVER}-xml php${PHPVER}-zip php${PHPVER}-fileinfo php${PHPVER}-ldap \
                            php${PHPVER}-intl php${PHPVER}-bz2 

    # Since I'am German:
    $APTINSTALL -t $RELEASE php${PHPVER}-gearman

    # For PHPVER > 8 Json was moved into the core package
    if [[ ${PHPVER} < 8 ]]; then
      $APTINSTALL -t $RELEASE php${PHPVER}-json
    fi

    mkdir -p /run/php

    # mariaDB password
    local DBPASSWD="default"
    echo -e "[client]\npassword=$DBPASSWD" > /root/.my.cnf
    chmod 600 /root/.my.cnf

    $APTINSTALL postgresql-${POSTGRES_VER} postgresql-contrib php${PHPVER}-pgsql
    #mkdir -p /run/postgresql
    #chown postgres /run/postgresql

    # CONFIGURE APACHE
    ##########################################

  cat > /etc/apache2/conf-available/http2.conf <<EOF
Protocols h2 h2c http/1.1

# HTTP2 configuration
H2Push          on
H2PushPriority  *                       after
H2PushPriority  text/css                before
H2PushPriority  image/jpeg              after   32
H2PushPriority  image/png               after   32
H2PushPriority  application/javascript  interleaved

# SSL/TLS Configuration
SSLProtocol -all +TLSv1.2 +TLSv1.3
SSLHonorCipherOrder on
SSLCipherSuite ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES256-SHA:ECDHE-ECDSA-DES-CBC3-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:DES-CBC3-SHA:!DSS
SSLCompression          off
SSLSessionTickets       on

# OCSP Stapling
SSLUseStapling          on
SSLStaplingResponderTimeout 5
SSLStaplingReturnResponderErrors off
SSLStaplingCache        shmcb:/var/run/ocsp(128000)
EOF

    # CONFIGURE PHP
    ##########################################

    cat > /etc/php/${PHPVER}/mods-available/opcache.ini <<EOF
zend_extension=opcache.so
opcache.enable=1
opcache.enable_cli=1
opcache.fast_shutdown=1
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=10000
opcache.memory_consumption=1024
opcache.save_comments=1
opcache.revalidate_freq=1
opcache.file_cache=/tmp;
EOF

    a2enmod http2
    a2enconf http2
    a2enmod proxy_fcgi setenvif
    a2enconf php${PHPVER}-fpm
    a2enmod rewrite
    a2enmod headers
    a2enmod dir
    a2enmod mime
    a2enmod ssl

    echo "ServerName localhost" >> /etc/apache2/apache2.conf


    # CONFIGURE LAMP FOR NEXTCLOUD
    ##########################################

    $APTINSTALL ssl-cert # self signed snakeoil certs

    # configure postgresql (UTF8 4 byte support)
#    cat > /etc/postgresql/${POSTGRES_VER}/main/postgresql.conf <<EOF
#EOF


  # launch postgres if not already running
  if ! pgrep -c postgres &>/dev/null; then
    systemctl start postgresql.service 
  fi

  # wait for postgres
  while :; do
    [[ -S /run/postgresql/.s.PGSQL.5432 ]] && break
    sleep 0.5
  done

  cd /tmp
}

configure() { :; }


# License
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA

