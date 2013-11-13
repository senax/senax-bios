Puppet::Type.newtype(:bios) do
  @doc = %q{manages bios settings}
  # omreport chassis biossetup -fmt ssv |grep '^Asset Tag;'
  # Asset Tag;somehost
  # omconfig chassis biossetup -? |grep Asset
  # attribute=AssetTag setting=<string value>
  # omconfig chassis biossetup attribute=AssetTag setting=hostabc
  # omreport chassis biossetup -fmt ssv |grep '^Asset Tag;'
  # Asset Tag;hostabc
  #

  newparam(:name, :namevar => true) do
    newvalues(:nextboot,:AssetTag)
    desc 'The name of the bios setting.'
  end

  newproperty(:value) do
    desc 'the value of the bios setting.'
  end

end
