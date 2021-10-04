![NC Logo](https://ownyourbits.com/wp-content/uploads/2017/11/ncp-square.png)

This is a fork of the build code for [NextCloudPi](https://nextcloudpi.com).

NextCloudPi is a ready to use image for Raspberry Pi, Odroid HC1, rock64 and other boards.

This version is modified in such a way, that you can install it directly on Ubuntu 20.04 Focal Foss.

This code also generates the NextCloudPi docker images for [all architectures](https://hub.docker.com/r/ownyourbits/nextcloudpi), and includes an installer for any Debian based system.

Find the full documentation at [docs.nextcloudpi.com](http://docs.nextcloudpi.com)

## Features

 * Ubuntu 20.04 Focal Foss
 * Nextcloud 22.1.1
 * Apache 2.4.25, with HTTP2 enabled
 * PHP 8
 * MariaDB 10
 * Redis memory cache
 * ncp-config for easy setup ( RAM logs, USB drive and more )
 * Automatic redirection to HTTPS
 * ACPU PHP cache
 * PHP Zend OPcache enabled with file cache
 * HSTS
 * Cron jobs for Nextcloud
 * Sane configuration defaults
 * Full emoji support
 * Postfix email
 * Secure

## Extras

 * Setup wizard
 * NextCloudPi Web Panel
 * Wi-Fi ready
 * Ram logs
 * Automatic security updates, activated by default.
 * Let’s Encrypt for trusted HTTPS certificates.
 * Fail2Ban protection against brute force attacks.
 * UFW firewall
 * Dynamic DNS support for no-ip.org
 * Dynamic DNS support for freeDNS
 * Dynamic DNS support for duckDNS
 * Dynamic DNS support for spDYN
 * Dynamic DNS support for Namecheap
 * dnsmasq DNS server with DNS cache
 * ModSecurity Web Application Firewall
 * NFS ready to mount your files over LAN
 * SAMBA ready to share your files with Windows/Mac/Linux
 * USB automount
 * Remote updates
 * Automatic NCP updates
 * Automatic Nextcloud updates
 * Update notifications
 * NextCloud backup and restore
 * NextCloud online installation
 * Format USB drive to BTRFS
 * BTRFS snapshots
 * Automatic BTRFS snapshots
 * BTRFS snapshot auto sync
 * scheduled rsync
 * UPnP automatic port forwarding
 * Security audits with Lynis and Debsecan
 * ZRAM
 * SMART hard drive health monitoring

Extras can be activated and configured using the web interface at HTTPS port 4443

Find the full (original) documentation at [docs.nextcloudpi.com](http://docs.nextcloudpi.com)

## Dependencies

```
# apt install curl 
```

## How to build

NextCloudPi can be installed in any architecture running Ubuntu 20.04
_Note: this assumes a clean Ubuntu install, and there is no rollback method_

```
# curl -sSL  https://raw.githubusercontent.com/Sebastian-47/nextcloudpi/ubuntu.20.04/install.sh | bash
```

