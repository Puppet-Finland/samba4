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
    $role,
    $host_ip,
    $host_name

) inherits samba4::params
{
    # Convert the parameters into upper- and lowercase
    $domain_lc = downcase($domain)
    $domain_uc = upcase($domain)
    $realm_lc = downcase($realm)
    $realm_uc = upcase($realm)

    Exec { path => ['/bin', '/sbin', '/usr/bin', '/usr/sbin' ], }

    # Stop Samba services
    exec { 'stop-smbd':
        command => $::samba4::params::samba_smbd_service_stop,
        require => Class['samba4::server::install'],
        unless  => "test -d ${::samba4::params::sysvol}",
    }

    exec { 'stop-samba-ad-dc':
        command => $::samba4::params::samba_ad_dc_service_stop,
        require => Exec['stop-smbd'],
        unless  => "test -d ${::samba4::params::sysvol}",
    }

    # Get rid of the default smb.conf, which prevents provisioning from working
    exec { 'rename-smb.conf':
        command => "mv ${::samba4::params::samba_config_name} ${::samba4::params::samba_config_name}.dist",
        unless  => "test -f ${::samba4::params::samba_config_name}.dist",
        require => Exec['stop-samba-ad-dc'],
    }

    # Provision the domain
    exec { 'samba4-domain-provisioning':
        command => "samba-tool domain provision --use-rfc2307 --dns-backend=SAMBA_INTERNAL --adminpass=\"${adminpass}\" --realm=${realm_uc} --domain=${domain_uc} --server-role=${role} --host-ip=${host_ip} --host-name=${host_name}",
        creates => "${::samba4::params::sysvol}/${realm_lc}",
        require => [ Exec['rename-smb.conf'], Class['samba4::server::install'] ],
        notify  => Service[$::samba4::params::samba_ad_dc_service_name],
        before  => [ Class['resolv_conf'], File['samba4-krb5.conf'] ],
    }

    # Modify smb.conf after provisioning

    # TLS is now enforced for simple binds, and while that is generally a good 
    # idea, it breaks existing setups. So we revert it for now. For details see
    #
    # <https://wiki.samba.org/index.php/Updating_Samba#Default_for_LDAP_Connections_Requires_Strong_Authentication>
    #
    ini_setting { 'samba4-ldap_server_require_strong_auth':
        ensure  => present,
        path    => $::samba4::params::samba_config_name,
        section => 'global',
        setting => 'ldap server require strong auth',
        value   => 'no',
        notify  => Service[$::samba4::params::samba_ad_dc_service_name],
        require => Exec['samba4-domain-provisioning'],
    }
}
