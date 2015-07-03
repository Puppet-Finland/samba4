#
# == Class: samba4::server::service
#
# Enable Samba services on boot
#
class samba4::server::service
(
    $role

) inherits samba4::params
{

    Service {
        enable  => true,
        require => Class['samba4::server::install'],
    }

    service { 'samba4-nmbd':
        name => $::samba4::params::samba_nmbd_service_name,
    }

    if $role == 'dc' {
        service { 'samba4-samba-ad-dc':
            name => $::samba4::params::samba_ad_dc_service_name,
        }
    } elsif $role == 'member' {
        service { 'samba4-samba-smbd':
            name => $::samba4::params::samba_smbd_service_name,
        }
    } else {
        fail("ERROR: Invalid value ${role} for parameter \$role!")
    }
}
