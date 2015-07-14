#
# == Class: samba4::client::install
#
# Install the Samba 4 client
#
class samba4::client::install inherits samba4::params {

    package { 'samba4-smbclient':
        ensure => present,
        name   => $::samba4::params::smbclient_package_name,
    }
}
