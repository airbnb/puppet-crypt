# Installs and configures Crypt
class crypt (
  $crypt_version  = '3.0.0',
  $server_url = 'http://crypt',
  $remove_plist = true,
  $package_source = "puppet:///modules/bigfiles/crypt/Crypt-${crypt_version}.pkg",
  $payload_organization = 'Example Organization',
  $crypt_files = [
    '/Library/Crypt/checkin',
    '/Library/Crypt/FoundationPlist.py',
    '/Library/LaunchDaemons/com.grahamgilbert.crypt.plist',
    '/Library/Security/SecurityAgentPlugins/Crypt.bundle/Contents/MacOS/Crypt'
  ],
  $wait_for_user = true,
  $force_install = false,
  $output_path = '/var/root/crypt_output.plist',
  $package_receipt = 'com.grahamgilbert.Crypt',
  $package_checksum = '',
  $http_username = '',
  $http_password = '',
){
  if $facts['os']['family'] == 'Darwin' and
  ($facts['mac_laptop'] == true or munki_item_installed('Crypt') or $force_install == true){
    class {'crypt::config': }
    -> class {'crypt::install': }
    -> class {'crypt::service': }
    -> Class['crypt']
  }
}
