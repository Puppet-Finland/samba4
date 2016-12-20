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
            $winbind_package_name = 'winbind'
            $libpam_winbind_package_name = 'libpam-winbind'
            $libnss_winbind_package_name = 'libnss-winbind'

            $samba_config_dir = '/etc/samba'
            $samba_config_name = "${samba_config_dir}/smb.conf"
            $krb5_config_name = '/etc/krb5.conf'

            $smbd_service_name = 'smbd'
            $nmbd_service_name = 'nmbd'
            $winbindd_service_name = 'winbind'
            $samba_ad_dc_service_name = 'samba-ad-dc'

            $service_start_cmd = "${::os::params::systemctl} start"
            $service_stop_cmd  = "${::os::params::systemctl} stop"

            $smbd_service_start = "${service_start_cmd} ${smbd_service_name}"
            $nmbd_service_start = "${service_start_cmd} ${nmbd_service_name}"
            $winbindd_service_start = "${service_start_cmd} ${winbindd_service_name}"
            $samba_ad_dc_service_start = "${service_start_cmd} ${samba_ad_dc_service_name}"

            $smbd_service_stop = "${service_stop_cmd} ${smbd_service_name}"
            $nmbd_service_stop = "${service_stop_cmd} ${nmbd_service_name}"
            $winbindd_service_stop = "${service_stop_cmd} ${winbindd_service_name}"
            $samba_ad_dc_service_stop = "${service_stop_cmd} ${samba_ad_dc_service_name}"

            $piddir = '/run/samba'
            $libdir = '/var/lib/samba'
            $sysvol = "${libdir}/sysvol"

            $samba_pidfile = "${piddir}/samba.pid"
            $smbd_pidfile = "${piddir}/smbd.pid"
            $winbindd_pidfile = "${piddir}/winbindd.pid"
        }
        default: {
            fail("Unsupported distribution: ${::lsbdistcodename}")
        }
    }
}
