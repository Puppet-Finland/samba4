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
    $server_role,
    $host_ip,
    $host_name

) inherits samba4::params
{
    # Make this Samba 4 instance a Domain Controller
    if $server_role == 'dc' {
        class { '::samba4::server::config::dc':
            adminpass   => $adminpass,
            realm       => $realm,
            domain      => $domain,
            server_role => $server_role,
            host_ip     => $host_ip,
            host_name   => $host_name,
        }
    } else {
        fail("Invalid value ${server_role} for parameter server_role!")
    }
}
