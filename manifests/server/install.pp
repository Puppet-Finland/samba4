#
# == Class: samba4::server::install
#
# Install the Samba 4 server
#
class samba4::server::install inherits samba4::params {

    package { 'samba4-samba':
        ensure => present,
        name => $::samba4::params::samba_package_name,
    }

    package { 'samba4-krb5-user':
        ensure => present,
        name => $::samba4::params::krb5_user_package_name,
    }
}
