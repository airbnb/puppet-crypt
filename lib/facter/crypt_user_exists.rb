# crypt_user_exists.rb

Facter.add(:crypt_user_exists) do
  confine kernel: 'Darwin'
  setcode do
    uids = (501..1000).to_a
    user_present = false
    uids.each do |uid|
      cmd = '/usr/bin/id ' + uid.to_s
      output = Facter::Util::Resolution.exec(cmd)
      if $CHILD_STATUS.exitstatus === 0
        user_present = true
        break
      end
    end
    user_present
  end
end
