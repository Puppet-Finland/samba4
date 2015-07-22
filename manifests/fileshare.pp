#
# == Define: samba4::fileshare
#
# Manage a Samba 4 fileshare
#
define samba4::fileshare
(
    $path,
    $readonly = true
)
{
    include ::samba4::params

    $sharename = $title

    file { "samba4-fileshare-${sharename}":
        ensure => directory,
        name   => $path,
    }

    concat::fragment { "samba4-smb.conf-fileshare-${sharename}":
        target  => 'samba4-smb.conf',
        content => template('samba4/smb.conf-fileshare.erb'),
        notify  => Class['samba4::server::service'],
    }
}
