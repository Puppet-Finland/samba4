#
# == Class: samba4::server::config
#
# Configure the Samba 4 server
#
class samba4::server::config
(
    String              $adminpass,
    String              $realm,
    String              $domain,
    Enum['dc','member'] $role,
    String              $host_ip,
    String              $host_name,
    String              $kdc,
    Variant[String,Array] $dns_server,
    Hash                $fileshares

) inherits samba4::params
{

    # Add static resolv.conf
    $realm_lc = downcase($realm)
    $realm_uc = upcase($realm)

    class { '::resolv_conf':
        nameservers => $dns_server,
        domainname  => $realm_lc,
    }

    # Configure Kerberos
    file { 'samba4-krb5.conf':
        ensure  => present,
        name    => $::samba4::params::krb5_config_name,
        content => template('samba4/krb5.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
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
            adminpass  => $adminpass,
            fileshares => $fileshares,
        }
    } else {
        fail("Invalid value ${role} for parameter role!")
    }
}
