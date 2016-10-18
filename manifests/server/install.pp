#
# == Class: samba4::server::install
#
# Install the Samba 4 server
#
class samba4::server::install
(
    $role

) inherits samba4::params {

    Package { ensure => 'present' }

    package { 'samba4-samba':     name => $::samba4::params::samba_package_name }
    package { 'samba4-winbind':   name => $::samba4::params::winbind_package_name }
    package { 'samba4-krb5-user': name => $::samba4::params::krb5_user_package_name }

    if $role == 'member' {
        # The "acl" package is required for fileshares. On systemd-enabled
        # distributions this gets pulled in as a depencency even without this
        # include.
        include ::setfacl

        package { $::samba4::params::libpam_winbind_package_name: }
        package { $::samba4::params::libnss_winbind_package_name: }
    }
}
