# crypt_version.rb

require "puppet/util/plist" if Puppet.features.cfpropertylist?

crypt_info_plist = "/Library/Security/SecurityAgentPlugins/Crypt.bundle/Contents/Info.plist"

Facter.add(:crypt_version) do
  confine kernel: "Darwin"
  setcode do
    version = "0"
    if File.exist?(crypt_info_plist)
      plist = Puppet::Util::Plist.read_plist_file(crypt_info_plist)
      if plist.include? "CFBundleShortVersionString"
        version = plist["CFBundleShortVersionString"]
      end
    end
    version
  end
end
