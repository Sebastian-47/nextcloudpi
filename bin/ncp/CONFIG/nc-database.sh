#!/bin/bash

# Data dir configuration script for NextCloudPi
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# More at https://ownyourbits.com/
#


is_active()
{
  local SRCDIR=$( grep datadir /etc/postgresql/${POSTGRES_VER}/main/postgresql.conf | awk -F " " '{ print $3 }' )
  [[ "$SRCDIR" != "/var/lib/postgresql/${POSTGRES_VER}/main" ]]
}

configure()
{
  local SRCDIR=$( grep datadir /etc/postgresql/${POSTGRES_VER}/main/postgresql.conf | awk -F " " '{ print $3 }' )
  [ -d "$SRCDIR" ] || { echo -e "database directory $SRCDIR not found"; return 1; }

  [ -d "$DBDIR" ] && {
    [[ $( find "$DBDIR" -maxdepth 0 -empty | wc -l ) == 0 ]] && {
      echo "$DBDIR is not empty"
      return 1
    }
    rmdir "$DBDIR" 
  }

  local BASEDIR=$( dirname "$DBDIR" )
  mkdir -p "$BASEDIR"

  grep -q -e ext -e btrfs <( stat -fc%T "$BASEDIR" ) || { echo -e "Only ext/btrfs filesystems can hold the data directory"; return 1; }
  
  sudo -u postgres test -x "$BASEDIR" || { echo -e "ERROR: the user postgres does not have access permissions over $BASEDIR"; return 1; }

  [[ $( stat -fc%d / ) == $( stat -fc%d "$BASEDIR" ) ]] && \
    echo -e "INFO: moving database to the SD card\nIf you want to use an external mount, make sure it is properly set up"

  cd /var/www/nextcloud
  sudo -u www-data php occ maintenance:mode --on

  echo "moving database to $DBDIR..."
  service postgresql stop
  mv "$SRCDIR" "$DBDIR" && \
    sed -i "s|^data_directory.*|data_directory = $DBDIR|" /etc/postgresql/${POSTGRES_VER}/main/postgresql.conf
  service postgresql start 

  sudo -u www-data php occ maintenance:mode --off
}

install(){ :; }

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

