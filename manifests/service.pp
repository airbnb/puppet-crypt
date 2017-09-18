# Managed Crypt's serivce
class crypt::service {
  service { 'com.grahamgilbert.crypt':
    ensure => 'running',
    enable => true,
  }
}
