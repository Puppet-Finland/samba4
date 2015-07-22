#
# == Class: samba4::config::member
#
# Configure Samba 4 AD member server
#
class samba4::server::config::member
(
    $realm,
    $domain,
    $host_name

) inherits samba4::params
{
    $realm_uc = upcase($realm)
    $domain_uc = upcase($domain)

    file { 'samba4-smb.conf-member':
        ensure  => present,
        name    => $::samba4::params::samba_config_name,
        content => template('samba4/smb.conf-member.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Class['samba4::server::install'],
    }
}
