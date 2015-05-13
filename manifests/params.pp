#
# == Class: samba4::params
#
# Defines some variables based on the operating system
#
class samba4::params {

    include ::os::params

    # We currently only support Debian 8 ("Jessie"). Adding support for other
    # operating systems should be fairly straightforward, provided that their
    # Samba 4 packages supports AD DC (unlike, say, RHEL/CentOS 7).
    #
    case $::lsbdistcodename {
        'jessie': {
            $samba_package_name = 'samba'
            $smbclient_package_name = 'smbclient'
            $krb5_user_package_name = 'krb5-user'

            $samba_ad_dc_service_name = 'samba-ad-dc'

            $piddir = '/var/run/samba'
            $libdir = '/var/lib/samba'
            $samba_pidfile = "${piddir}/samba.pid"
        }
        default: {
            fail("Unsupported distribution: ${::lsbdistcodename}")
        }
    }
}
