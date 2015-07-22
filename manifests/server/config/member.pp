#
# == Class: samba4::config::member
#
# Configure Samba 4 AD member server
#
class samba4::server::config::member
(
    $realm,
    $domain,
    $host_name,
    $fileshares

) inherits samba4::params
{
    $realm_uc = upcase($realm)
    $domain_uc = upcase($domain)

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
}
