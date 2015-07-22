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
        notify  => Class['samba4::server::service'],
        before  => Class['resolv_conf'],
    }

    # Configure Kerberos
    file { 'samba4-krb5.conf':
        ensure  => present,
        name    => $::samba4::params::krb5_config_name,
        content => template('samba4/krb5.conf.erb'),
        owner   => $::os::params::adminuser,
        group   => $::os::params::admingroup,
        mode    => '0644',
        require => Exec['samba4-domain-provisioning'],
    }
}
