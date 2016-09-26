# == Class: samba4::server
#
# This class install and configures Samba 4 server
#
# == Parameters
#
# [*manage*]
#   Whether to manage Samba 4 using Puppet or not. Valid values are true 
#   (default) and false.
# [*manage_config*]
#   Whether to manage Samba 4 configuration using Puppet or not. Valid values 
#   are true (default) and 'false.
# [*adminpass*]
#   Administrator password for the Samba 4 domain. Required on both Domain 
#   Controllers and Member servers.
# [*realm*]
#   The Kerberos realm, which will also be used as the Active Directory domain 
#   name. This parameter will be automatically converted to uppercase as needed. 
#   For example 'SMB.DOMAIN.COM'.
# [*domain*]
#   The NT4/Netbios domain name. Must not exceed 15 characters in length or have 
#   any punctuation marks in it. Typically this is the first part of the AD 
#   domain name, e.g. 'SMB'.
# [*role*]
#   Role of this server. Either 'dc' or 'member'.
# [*host_ip*]
#   IP-address of this host.
# [*host_name*]
#   The AD hostname for this host. Typically something like 'DC1'.
# [*kdc*]
#   IP-address of the Key Distribution Center (KDC) server for this realm. This 
#   should match the IP of the Samba4 AD DC you've configured.
# [*dns_server*]
#   Name of the DNS server, can be a string or an array. On domain controllers 
#   this defaults to '127.0.0.1'. However, when bootstrapping domain controllers 
#   you should use an array and include the primary DNS server of the internal 
#   network also, e.g. use ['127.0.0.1','192.168.84.5']). This needs to be done 
#   to prevent the resolvconf class nuking /etc/resolv.conf before Puppet has 
#   time to configure Samba 4's built-in resolver.
#
#   On member servers this should be set to the IP address of the domain 
#   controller. The same precaution about using a backup domain controller 
#   applies here.

# [*monitor_email*]
#   Server monitoring email. Defaults to $::servermonitor.
# [*fileshares*]
#   A hash of samba4::fileshare resources to realize. Empty by default.
#
class samba4::server
(
    Boolean $manage = true,
    Boolean $manage_config = true,
            $adminpass,
            $realm,
            $domain,
            $role,
            $host_ip,
            $kdc,
            $host_name,
            $dns_server = undef,
            $monitor_email = $::servermonitor,
            $fileshares = {}

) inherits samba4::params
{

if $manage {

    include ::samba4::client

    class { '::samba4::server::install':
        role => $role,

    }
    if $manage_config {
        class { '::samba4::server::config':
            adminpass  => $adminpass,
            realm      => $realm,
            domain     => $domain,
            role       => $role,
            host_ip    => $host_ip,
            host_name  => $host_name,
            kdc        => $kdc,
            dns_server => $dns_server,
            fileshares => $fileshares,
        }
    }

    class { '::samba4::server::service':
        role => $role,
    }
}
}
