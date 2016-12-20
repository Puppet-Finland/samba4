#
# == Class: samba4::monit
#
# Sets up monit rules for Samba 4 server
#
class samba4::server::monit
(
    $role,
    $monitor_email

) inherits samba4::params
{

    monit::fragment { 'samba4-winbindd':
        basename   => 'winbindd',
        modulename => 'samba4',
    }

    if $role == 'dc' {
        monit::fragment { 'samba4-samba-ad-dc.monit':
            basename   => 'samba-ad-dc',
            modulename => 'samba4',
        }
    }
}
