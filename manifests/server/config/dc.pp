#
# == Class: samba4::server::config::dc
#
# Configure a Samba 4.x server as a AD Domain Controller
#
class samba4::server::config::dc
(
    $adminpass,
    $realm,
    $domain,
    $server_role,
    $host_ip,
    $host_name

) inherits samba4::params
{

    # Convert the parameters into upper- and lowercase
    $domain_lc = downcase($domain)
    $domain_uc = upcase($domain)
    $realm_lc = downcase($realm)
    $realm_uc = upcase($realm)

    exec { 'samba4-domain-provisioning':
        command => "samba-tool domain provision --use-rfc2307 --dns-backend=SAMBA_INTERNAL --adminpass=\"${adminpass}\" --realm=${realm_uc} --domain=${domain_uc} --server-role=${server_role} --host-ip=${host_ip} --host-name=${host_name}",
        path    => ['/bin', '/sbin', '/usr/bin', '/usr/sbin' ],
        creates => "${::samba4::params::sysvol}/${realm_lc}",
        require => Class['samba4::server::install'],
        notify  => Class['samba4::server::service::dc'],
    }

}
