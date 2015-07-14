#
# == Class: samba::client
#
# Install Samba client tools
#
# == Parameters
#
# [*manage*]
#   Whether to manage Samba 4 client using Puppet or not. Valid values are 'yes' 
#   (default) and 'no'.
#
class samba4::client
(
    $manage = 'yes'
)
{
    if $manage == 'yes' {
        include ::samba4::client::install
    }
}
