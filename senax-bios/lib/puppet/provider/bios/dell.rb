Puppet::Type.type(:bios).provide(:dell) do
  desc "dell omconfig bios provider"
  # http://permalink.gmane.org/gmane.comp.sysutils.puppet.devel/18648

  confine    :osfamily => :redhat
  defaultfor :osfamily => :redhat

  commands :omconfig => "/opt/dell/srvadmin/bin/omconfig"
  commands :omreport => "/opt/dell/srvadmin/bin/omreport"


  def self.bioslist
    biossettings = []
    output=omreport('chassis','biossetup','display=shortnames','-fmt','ssv').split("\n")

    [output].flatten.each do |line|
      res = {}
      setting=line.split(';')
      unless setting[1].nil? || setting[0].eql?('') || setting[0].nil?
        res[:name] = setting[0].to_s.strip
        res[:value] = setting[1].to_s.strip
        biossettings << res
      end
    end
    biossettings
  end

  def value
    @property_hash[:value]
  end

  def value=(newvalue)
    output=omconfig('chassis','biossetup',"attribute=#{resource[:name]}","setting=#{newvalue}")
    @property_hash[:value]=newvalue
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if bios = resources[prov.name]
        bios.provider = prov
      end
    end
  end

  def self.instances
    bioses = []
    biossettings = self.bioslist
    biossettings.collect do |bios|
      bioses << new(:name => bios[:name], :value => bios[:value])
    end
    bioses
  end

end # end of class

