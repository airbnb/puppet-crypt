# Configures a Crypt client

class crypt::config {
  $server_url = $crypt::server_url
  $remove_plist = $crypt::remove_plist
  $payload_organization = $crypt::payload_organization

  $profile = {
    'PayloadContent' => [
      {
        'PayloadContent' => {
          'com.grahamgilbert.crypt' => {
            'Forced' => [
              {
                'mcx_preference_settings' => {
                  'ServerURL' => $server_url,
                  'RemovePlist' => $remove_plist,
                }
              }
            ]
          }
        },
        'PayloadEnabled' => true,
        'PayloadIdentifier' => 'MCXToProfile.a8b8246c-493e-4cc8-940c-a6d729c25702.alacarte.customsettings.4e3aa31e-3a75-4f16-a00b-785dab770530', # lint:ignore:140chars
        'PayloadType' => 'com.apple.ManagedClient.preferences',
        'PayloadUUID' => '4e3aa31e-3a75-4f16-a00b-785dab770530',
        'PayloadVersion' => 1
      }
    ],
    'PayloadDescription' => "Included custom settings:\ncom.grahamgilbert.crypt",
    'PayloadDisplayName' => 'Settings for Crypt',
    'PayloadIdentifier' => 'com.grahamgilbert.crypt',
    'PayloadOrganization' => $payload_organization,
    'PayloadRemovalDisallowed' => true,
    'PayloadScope' => 'System',
    'PayloadType' => 'Configuration',
    'PayloadUUID' => 'a8b8246c-493e-4cc8-940c-a6d729c25702',
    'PayloadVersion' => 1
  }

  mac_profiles_handler::manage { 'com.grahamgilbert.crypt':
    ensure      => present,
    file_source => plist($profile),
    type        => 'template',
  }

  if versioncmp($facts['os']['macosx']['version']['major'], '10.11') > 0 {
    $insert_after = 'CryptoTokenKit:login'
  } else {
    $insert_after = 'MCXMechanism:login'
  }

  if $crypt::wait_for_user == false {
    $manage_mechs = true
  } elsif $crypt::wait_for_user == true and $facts['crypt_user_exists'] == true {
    $manage_mechs = true
  } else {
    $manage_mechs = false
  }

  if $manage_mechs == true {
    authpluginmech { 'Crypt:Check,privileged':
      ensure       => present,
      insert_after => $insert_after
    }
    -> authpluginmech { 'Crypt:CryptGUI':
      ensure       => present,
      insert_after => 'Crypt:Check,privileged'
    }
    -> authpluginmech { 'Crypt:Enablement,privileged':
      ensure       => present,
      insert_after => 'Crypt:CryptGUI'
    }
  }

}
