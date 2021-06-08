module Puppet::Parser::Functions
  newfunction(:crypt_version_trim, type: :rvalue, doc: <<-EOS
Returns a trimmed version.
    EOS
  ) do |args|
    raise(Puppet::ParseError, "crypt_version_trim(): " \
    "Wrong number of arguments given (#{args.size} for 1)") if args.size != 1

    # crypt_version = lookupvar('crypt_version')
    crypt_version = args[0]
    if crypt_version.count(".") == 2
      result = crypt_version
    else
      result = crypt_version.gsub(/\.[^.]*\Z/, "")
    end
  end
end
