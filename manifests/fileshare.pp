#
# == Define: samba4::fileshare
#
# Manage a Samba 4 fileshare
#
# == Parameters
#
# [*title*]
#   While not strictly a parameter, the resource title defines the share name as 
#   seen by users.
# [*path*]
#   The filesystem path to the share. This directory will be automatically 
#   generated if it does not exist, provided that it's parent directory exists.
# [*valid_users*]
#   Users that are allowed to use the fileshare. Defaults to undef, allowing 
#   access to any authenticated user. See Samba documentation for details on 
#   this option.
# [*guest_ok*]
#   Allow passwordless connections to this fileshare. Valid values are 'no' 
#   (default) and 'yes'.
# [*read_only*]
#   Determines whether this fileshare is read-only or not. Valid values are 'no' 
#   (default) and 'yes'.
#
define samba4::fileshare
(
    $path,
    $valid_users = undef,
    $guest_ok = no,
    $read_only = no,
)
{
    include ::samba4::params

    $sharename = $title

    file { "samba4-fileshare-${sharename}":
        ensure => directory,
        name   => $path,
    }

    if $valid_users {
        $valid_users_line = "valid users = ${valid_users}"
    } else {
        $valid_users_line = "valid users ="
    }

    concat::fragment { "samba4-smb.conf-fileshare-${sharename}":
        target  => 'samba4-smb.conf',
        content => template('samba4/smb.conf-fileshare.erb'),
        notify  => Class['samba4::server::service'],
    }
}
