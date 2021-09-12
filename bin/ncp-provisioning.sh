#!/bin/bash

# this script runs at startup to provide an unique random passwords for each instance

source /usr/local/etc/library.sh

## redis provisioning

CFG=/var/www/nextcloud/config/config.php
REDISPASS="$( grep "^requirepass" /etc/redis/redis.conf | cut -f2 -d' ' )"

### IF redis password is the default one, generate a new one

[[ "$REDISPASS" == "default" ]] && {
  REDISPASS="$( openssl rand -base64 32 )"
  echo Provisioning Redis password
  sed -i -E "s|^requirepass .*|requirepass $REDISPASS|" /etc/redis/redis.conf
  chown redis:redis /etc/redis/redis.conf
  is_docker || systemctl restart redis
}

### If there exists already a configuration adjust the password
[[ -f "$CFG" ]] && {
  echo "Updating NextCloud config with Redis password"
  sed -i "s|'password'.*|'password' => '$REDISPASS',|" "$CFG"
}

## PostgreSQL provisioning

DBADMIN=ncadmin
DBPASSWD=$( grep password /root/.my.cnf | sed 's|password=||' )

[[ "$DBPASSWD" == "default" ]] && {
  DBPASSWD=$( openssl rand -base64 32 )
  echo Provisioning Postgresql password
  echo -e "[client]\npassword=$DBPASSWD" > /root/.my.cnf
  chmod 600 /root/.my.cnf
  sudo -u postgres psql <<EOF
DROP DATABASE IF EXISTS nextcloud;
CREATE DATABASE nextcloud TEMPLATE template0 ENCODING 'UNICODE';
DROP USER IF EXISTS $DBADMIN;
CREATE USER $DBADMIN WITH password '$DBPASSWD';
ALTER DATABASE nextcloud OWNER TO $DBADMIN;
GRANT ALL privileges ON DATABASE nextcloud TO $DBADMIN;
\q
EOF
}

[[ -f "$CFG" ]] && {
  echo "Updating NextCloud config with Postgresql password"
  sed -i "s|'dbpassword' =>.*|'dbpassword' => '$DBPASSWD',|" "$CFG"
}

## nc.limits.sh (auto)adjustments: number of threads, memory limits...

source /usr/local/etc/library.sh
run_app nc-limits

## Check for interrupted upgrades and rollback
BKP="$( ls -1t /var/www/nextcloud-bkp_*.tar.gz 2>/dev/null | head -1 )"
[[ -f "$BKP" ]] && [[ "$( stat -c %U "$BKP" )" == "root" ]] && [[ "$( stat -c %a "$BKP" )" == 600 ]] && {
  echo "Detected interrupted upgrade. Restoring..."
  BKP_NEW="failed_$BKP"
  mv "$BKP" "$BKP_NEW"
  ncp-restore "$BKP_NEW" && rm "$BKP_NEW"
}

exit 0
