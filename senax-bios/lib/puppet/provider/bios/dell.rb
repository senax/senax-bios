Puppet::Type.type(:bios).provide(:dell) do
  desc "dell omconfig bios provider"

  confine :osfamily => :redhat
  defaultfor :osfamily => :redhat

  commands :omconfig => "/opt/dell/srvadmin/bin/omconfig"
  commands :omreport => "/opt/dell/srvadmin/bin/ompreport"


  def create
#p "called create with resource:"
#p resource
#puts "puts test"
#p "p test"
  end

  def destroy
#p "called destroy with resource:"
#p resource
  end

  def value
#p "value"
#p "return current value of resource[:name]#{resource[:name]}"
#p @property_hash
  output=omreport('chassis','biossetup','display=shortnames','-fmt','ssv').split("\n")
  [output].flatten.each {|line|
    line_arguments = line.strip.split(';')
#    p line_arguments
    if resource[:name].to_s.eql?(line_arguments[0])
      return line_arguments[1]
    end
  }
  nil
  end

 def value=(newvalue)
#p "value="
#   p "value=#{newvalue}"
   output=omconfig('chassis','biossetup',"attribute=#{resource[:name]}","setting=#{newvalue}")
   p output
 end

  def exists?
#p "called exists? with resource:"
#p resource
#    output = IO.popen('echo abc')
  end

  def self.instances
    # display its output.
#    puts "self.instances"
    biossettings = self.bioslist
#p biossettings
    biossettings.collect do |bios|
      self.new(bios) # create new object for each bios
    end
  end

def self.bioslist

  biossetup = ['AssetTag;foo','nextboot;pxe',]
  biossettings = []

  biossetup.each do |bios|
    res = {}
    setting=bios.split(';')
#    res[:ensure] = :present
    res[:name] = setting[0].strip
    res[:value] = setting[1].strip

    biossettings << res
  end
  biossettings
end

end # end of class
