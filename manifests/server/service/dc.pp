#
# == Class: samba4::server::service::dc
#
# Enable Samba 4 service on boot
#
class samba4::server::service::dc inherits samba4::params {

    service { 'samba4-samba-ad-dc':
        name => $::samba4::params::samba_ad_dc_service_name,
        enable => true,
        require => Class['samba4::server::install'],
    }
}
