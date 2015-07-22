# == Class: samba4::server
#
# This class install and configures Samba 4 server
#
# == Parameters
#
# [*manage*]
#   Whether to manage Samba 4 using Puppet or not. Valid values 'yes' (default) 
#   and 'no'.
# [*manage_config*]
#   Whether to manage Samba 4 configuration using Puppet or not. Valid values 
#   'yes' (default) and 'no'.
# [*adminpass*]
#   Administrator password for the Samba 4 server. Only required for the domain 
#   controller ($role = 'dc').
# [*realm*]
#   The Kerberos realm, which will also be used as the Active Directory domain 
#   name. This parameter will be automatically converted to uppercase as needed. 
#   For example 'SMB.DOMAIN.COM'.
# [*domain*]
#   The NT4/Netbios domain name. Must not exceed 15 characters in length or have 
#   any punctuation marks in it. Typically this is the first part of the AD 
#   domain name, e.g. 'SMB'.
# [*role*]
#   Role of this server. Currently the only valid value is 'dc', although Samba 
#   4 itself supports others as well.
# [*host_ip*]
#   IP-address of this host.
# [*host_name*]
#   The AD hostname for this host. Typically something like 'DC1'.
# [*dns_server*]
#   Name of the DNS server. On domain controllers this should be (and defaults 
#   to) 127.0.0.1. On member servers this should be set to the IP address of the 
#   domain controller.
# [*monitor_email*]
#   Server monitoring email. Defaults to $::servermonitor.
# [*fileshares*]
#   A hash of samba4::fileshare resources to realize. Empty by default.
#
# == Examples
#
# Common Samba 4 parameters can be set at the lowest level in Hiera:
#
#   samba4::server::realm: 'SMB.DOMAIN.COM'
#   samba4::server::domain: 'SMB'
#
# On the Samba 4 Domain Controller use something like this:
#
#   ---
#   classes:
#     - dhclient
#     - samba4::server
#   
#   # The DC must have a static IP address and resolver configuration
#   dhclient::ensure: 'absent'
#   
#   samba4::server::adminpass: 'verysecret'
#   samba4::server::dns_server: '127.0.0.1'
#   samba4::server::host_name: 'DC1'
#   samba4::server::host_ip: '192.168.81.10'
#   samba4::server::role: 'dc'
#
# Setting up a member server:
#
#   ---
#   classes:
#     - dhclient
#     - samba4::server
#
#   # The member server could use DHCP, even though here we use static IPs and 
#   # resolver configuration.
#   dhclient::ensure: 'absent'
#
#   # The member server needs to point to Samba's DNS server
#   samba4::server::dns_server: '192.168.81.10'
#   samba4::server::host_name: 'MEMBER'
#   samba4::server::host_ip: '192.168.81.11'
#   samba4::server::role: 'member'
#   samba4::server::fileshares:
#     guestshare:
#       path: '/srv/samba/guestshare'
#
class samba4::server
(
    $manage = 'yes',
    $manage_config = 'yes',
    $adminpass = undef,
    $realm,
    $domain,
    $role,
    $host_ip,
    $host_name,
    $dns_server = undef,
    $monitor_email = $::servermonitor,
    $fileshares = {}

) inherits samba4::params
{

if $manage == 'yes' {

    include ::samba4::client

    class { '::samba4::server::prequisites':
        role => $role,
    }

    include ::samba4::server::install

    if $manage_config == 'yes' {
        class { '::samba4::server::config':
            adminpass  => $adminpass,
            realm      => $realm,
            domain     => $domain,
            role       => $role,
            host_ip    => $host_ip,
            host_name  => $host_name,
            dns_server => $dns_server,
            fileshares => $fileshares,
        }
    }

    class { '::samba4::server::service':
        role => $role,
    }
}
}
