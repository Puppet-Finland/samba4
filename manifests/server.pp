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
#   The administrator password for the Samba 4 server.
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
# [*monitor_email*]
#   Server monitoring email. Defaults to $::servermonitor.
#
class samba4::server
(
    $manage = 'yes',
    $manage_config = 'yes',
    $adminpass,
    $realm,
    $domain,
    $role,
    $host_ip,
    $host_name,
    $monitor_email = $::servermonitor

) inherits samba4::params
{

if $manage == 'yes' {

    include ::samba4::server::install

    if $manage_config == 'yes' {
        class { '::samba4::server::config':
            adminpass   => $adminpass,
            realm       => $realm,
            domain      => $domain,
            role        => $role,
            host_ip     => $host_ip,
            host_name   => $host_name
        }
    }

    class { '::samba4::server::service':
        role => $role,
    }
}
}
