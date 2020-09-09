# Installs Crypt
class crypt::install {

  $crypt_version    = $crypt::crypt_version
  $package_source   = $crypt::package_source
  $crypt_files      = $crypt::crypt_files
  $crypt_directory  = $crypt::crypt_directory
  $output_path      = $crypt::output_path
  $package_checksum = $crypt::package_checksum
  $package_receipt  = $crypt::package_receipt

  $shortversion = crypt_version_trim($crypt_version)

  if versioncmp($facts['crypt_version'], $shortversion) > 0  {
    $force_install = true
  } else {
    $force_install = false
  }

  apple_package { 'Crypt':
    source        => $package_source,
    version       => $crypt_version,
    receipt       => $package_receipt,
    installs      => $crypt_files,
    force_install => $force_install,
    http_checksum => $package_checksum,
    http_username => $crypt::http_username,
    http_password => $crypt::http_password
  }

  file { $crypt_directory:
    ensure       => directory,
    owner        => 0,
    group        => 0,
    mode         => '0755',
    recurse      => true,
    recurselimit => 1,
    require      => Apple_package['Crypt']
  }

  $plist = {
    'Label'      => 'com.grahamgilbert.crypt_watchpath',
    'Program'    => '/Library/Crypt/checkin',
    'RunAtLoad'  => true,
    'WatchPaths' => [
      $output_path
    ]
  }

  file {'/Library/LaunchDaemons/com.grahamgilbert.crypt_watchpath.plist':
    ensure  => present,
    owner   => '0',
    group   => '0',
    mode    => '0644',
    content => plist($plist)
  }

}
