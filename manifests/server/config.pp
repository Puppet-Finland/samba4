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
    $host_name

) inherits samba4::params
{
    # Make this Samba 4 instance a Domain Controller
    if $role == 'dc' {
        class { '::samba4::server::config::dc':
            adminpass   => $adminpass,
            realm       => $realm,
            domain      => $domain,
            role        => $role,
            host_ip     => $host_ip,
            host_name   => $host_name,
        }
    } else {
        fail("Invalid value ${role} for parameter role!")
    }
}
