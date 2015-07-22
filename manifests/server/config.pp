#
# == Class: samba4::server::config
#
# Configure the Samba 4 server
#
class samba4::server::config
(
    $adminpass,
    $realm,
    $domain,
    $role,
    $host_ip,
    $host_name,
    $dns_server,
    $fileshares

) inherits samba4::params
{

    # Add static resolv.conf
    $realm_lc = downcase($realm)

    class { '::resolv_conf':
        nameservers => [$dns_server],
        domainname  => $realm_lc,
    }

    # Make this Samba 4 instance a Domain Controller
    if $role == 'dc' {
        class { '::samba4::server::config::dc':
            adminpass => $adminpass,
            realm     => $realm,
            domain    => $domain,
            role      => $role,
            host_ip   => $host_ip,
            host_name => $host_name,
        }
    } elsif $role == 'member' {
        class { '::samba4::server::config::member':
            realm      => $realm,
            domain     => $domain,
            host_name  => $host_name,
            fileshares => $fileshares,
        }
    } else {
        fail("Invalid value ${role} for parameter role!")
    }
}
