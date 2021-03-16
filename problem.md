The following NEW packages will be installed:
  dnsmasq
0 upgraded, 1 newly installed, 0 to remove and 16 not upgraded.
Need to get 16.5 kB of archives.
After this operation, 75.8 kB of additional disk space will be used.
Get:1 http://ports.ubuntu.com/ubuntu-ports focal/universe arm64 dnsmasq all 2.80-1.1ubuntu1 [16.5 kB]
Fetched 16.5 kB in 0s (153 kB/s)   
Selecting previously unselected package dnsmasq.
(Reading database ... 85776 files and directories currently installed.)
Preparing to unpack .../dnsmasq_2.80-1.1ubuntu1_all.deb ...
Unpacking dnsmasq (2.80-1.1ubuntu1) ...
Setting up dnsmasq (2.80-1.1ubuntu1) ...
Created symlink /etc/systemd/system/multi-user.target.wants/dnsmasq.service → /lib/systemd/system/dnsmasq.service.
Job for dnsmasq.service failed because the control process exited with error code.
See "systemctl status dnsmasq.service" and "journalctl -xe" for details.
invoke-rc.d: initscript dnsmasq, action "start" failed.
● dnsmasq.service - dnsmasq - A lightweight DHCP and caching DNS server
     Loaded: loaded (/lib/systemd/system/dnsmasq.service; enabled; vendor preset: enabled)
     Active: failed (Result: exit-code) since Wed 2020-08-12 14:16:11 UTC; 22ms ago
    Process: 34812 ExecStartPre=/usr/sbin/dnsmasq --test (code=exited, status=0/SUCCESS)
    Process: 34821 ExecStart=/etc/init.d/dnsmasq systemd-exec (code=exited, status=2)

Aug 12 14:16:11 odroid systemd[1]: Starting dnsmasq - A lightweight DHCP and caching DNS server...
Aug 12 14:16:11 odroid dnsmasq[34812]: dnsmasq: syntax check OK.
Aug 12 14:16:11 odroid dnsmasq[34821]: dnsmasq: failed to create listening socket for port 53: Address already in use
Aug 12 14:16:11 odroid dnsmasq[34821]: failed to create listening socket for port 53: Address already in use
Aug 12 14:16:11 odroid dnsmasq[34821]: FAILED to start up
Aug 12 14:16:11 odroid systemd[1]: dnsmasq.service: Control process exited, code=exited, status=2/INVALIDARGUMENT
Aug 12 14:16:11 odroid systemd[1]: dnsmasq.service: Failed with result 'exit-code'.
Aug 12 14:16:11 odroid systemd[1]: Failed to start dnsmasq - A lightweight DHCP and caching DNS server.
Processing triggers for systemd (245.4-4ubuntu3.2) ...

