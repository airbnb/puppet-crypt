# Installs Crypt
class crypt::install {

  $crypt_version  = $crypt::crypt_version
  $package_source = $crypt::package_source
  $crypt_files    = $crypt::crypt_files

  $shortversion = crypt_version_trim($crypt_version)

  if versioncmp($facts['crypt_version'], $shortversion) > 0  {
    $force_install = true

    # Bin the cached copy of the profile so it gets reinstalled
    exec {"/bin/rm -f ${facts['puppet_vardir']}/mobileconfigs/com.grahamgilbert.crypt":
    }
  } else {
    $force_install = false
  }

  apple_package { 'Crypt':
    source        => $package_source,
    version       => $crypt_version,
    receipt       => 'com.grahamgilbert.Crypt',
    installs      => $crypt_files,
    force_install => $force_install
  }

}
