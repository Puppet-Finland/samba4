#
# == Class: samba4::server::service
#
# Enable Samba service on boot
#
class samba4::server::service
(
    $server_role

) inherits samba4::params
{
    if $server_role == 'dc' {
        include ::samba4::server::service::dc
    }
}

