#
# == Class: samba4::server::prequisites
#
# Install prequisites for Samba 4 servers
#
class samba4::server::prequisites
(
    $role

) inherits samba4::params
{
    if $role == 'dc' {
        # Kerberos is required on the AD DC
        package { 'samba4-krb5-user':
            ensure => present,
            name   => $::samba4::params::krb5_user_package_name,
        }
    } elsif $role == 'member' {
        # The "acl" package is required for fileshares. On systemd-enabled 
        # distributions this gets pulled in as a depencency even without this 
        # include.
        include ::setfacl
    } else {
        fail("ERROR: Invalid role \$role ${role}!")
    }
}
