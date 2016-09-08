# samba4

A Puppet module for managing Samba 4

# Module usage

Common Samba 4 parameters can be set at the lowest level in Hiera, e.g. 
in common.yaml:

    samba4::server::realm: 'SMB.DOMAIN.COM'
    samba4::server::domain: 'SMB'

To setup a Samba 4 Domain Controller:

    classes:
        - dhclient
        - samba4::server
    
    # The DC must have a static IP address and resolver configuration
    dhclient::ensure: 'absent'
    
    samba4::server::adminpass: 'verysecret'
    samba4::server::dns_server: '127.0.0.1'
    samba4::server::host_name: 'DC1'
    samba4::server::host_ip: '192.168.81.10'
    samba4::server::kdc: '192.168.81.10'
    samba4::server::role: 'dc'

To set up a member server:

    classes:
        - dhclient
        - samba4::server
        - sshd
    
    # The member server could use DHCP, even though here we use static IPs and 
    # resolver configuration.
    dhclient::ensure: 'absent'
    
    # The member server needs to point to Samba's DNS server
    samba4::server::dns_server: '192.168.81.10'
    samba4::server::host_name: 'MEMBER'
    samba4::server::host_ip: '192.168.81.11'
    samba4::server::kdc: '192.168.81.10'
    samba4::server::role: 'member'
    samba4::server::fileshares:
        guestshare:
            path: '/srv/samba/guestshare'
    
    # This is required for logins as domain user
    sshd::kerberosauthentication: 'yes'

For details see class documentation:

* [Class: samba4](manifests/init.pp)
* [Class: samba4::server](manifests/server.pp)

# Dependencies

See [metadata.json](metadata.json).

# Operating system support

This module has been tested on

* Debian 8

For details see [params.pp](manifests/params.pp).
