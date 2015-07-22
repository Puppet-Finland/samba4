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

            $samba_config_name = '/etc/samba/smb.conf'
            $krb5_config_name = '/etc/krb5.conf'

            $samba_smbd_service_name = 'smbd'
            $samba_nmbd_service_name = 'nmbd'
            $samba_ad_dc_service_name = 'samba-ad-dc'

            $service_start_cmd = "${::os::params::systemctl} start"
            $service_stop_cmd  = "${::os::params::systemctl} stop"

            $samba_smbd_service_start  = "${service_start_cmd} ${samba_smbd_service_name}"
            $samba_nmbd_service_start  = "${service_start_cmd} ${samba_nmbd_service_name}"
            $samba_ad_dc_service_start = "${service_start_cmd} ${samba_ad_dc_service_name}"

            $samba_smbd_service_stop  = "${service_stop_cmd} ${samba_smbd_service_name}"
            $samba_nmbd_service_stop  = "${service_stop_cmd} ${samba_nmbd_service_name}"
            $samba_ad_dc_service_stop = "${service_stop_cmd} ${samba_ad_dc_service_name}"

            $piddir = '/var/run/samba'
            $libdir = '/var/lib/samba'
            $sysvol = "${libdir}/sysvol"
            $samba_pidfile = "${piddir}/samba.pid"
        }
        default: {
            fail("Unsupported distribution: ${::lsbdistcodename}")
        }
    }
}
