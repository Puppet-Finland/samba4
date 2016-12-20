#
# == Class: samba4::server::config::member
#
# Configure Samba 4 AD member server
#
class samba4::server::config::member
(
    $realm,
    $domain,
    $host_name,
    $adminpass,
    $fileshares

) inherits samba4::params
{
    $realm_uc = upcase($realm)
    $realm_lc = downcase($realm)
    $domain_uc = upcase($domain)
    $host_name_lc = downcase($host_name)

    # Convert the realm into LDAP format:
    #
    # smb.domain.com -> DC=smb,DC=domain,DC=com
    #
    # The second regsubst strips out the trailing ','
    $pre = regsubst($realm_lc, '(^|[.])([a-zA-Z0-9_-]+)', 'DC=\2,', 'G')
    $rdn = regsubst($pre, ',$', '')

    # Concat is used here because it seems the only reasonable option:
    #
    # - Samba does not support including all files in a directory (e.g.
    #   /etc/samba/smb.conf.d/*.conf), so the usual smb.conf.d -type solution
    #   is out of the question.
    # - Augeas does not support _keys_ with spaces (e.g. "read only"), so it is
    #   ruled out.
    # - Adding per-fileshare include lines to smb.conf would trigger useless
    #   changes on every Puppet run.
    #
    concat { 'samba4-smb.conf':
        ensure  => present,
        path    => $::samba4::params::samba_config_name,
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['samba4::server::install'],
    }

    concat::fragment { 'samba4-smb.conf-base':
        target  => 'samba4-smb.conf',
        content => template('samba4/smb.conf-base.erb'),
        notify  => Class['samba4::server::service'],
    }

    # Add smb.conf fragment for each fireshare
    create_resources('samba4::fileshare', $fileshares)

    # Configure nsswitch.conf
    class { '::nsswitch':
        passwd => [ 'compat', 'winbind' ],
        group  => [ 'compat', 'winbind' ],
    }

    # Join domain unless a DNS query shows that a machine account has already 
    # been created. Note that this approach will fail on rejoin, but 
    # improvements can be made later.
    exec { 'samba4-net-ads-join':
        command => "net ads join -U administrator%${adminpass}",
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        unless  => "net ads dn \'CN=${host_name_lc},CN=Computers,${rdn}\' cn -Uadministrator%${adminpass}|grep cn: ",
        require => Class['nsswitch'],
    }

    # Configure pam_winbind.conf
    file { 'samba4-pam_winbind.conf':
        ensure  => present,
        name    => '/etc/security/pam_winbind.conf',
        content => template('samba4/pam_winbind.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['samba4::server::install'],
    }
}
