Puppet::Type.newtype(:bios) do
  @doc = %q{manages bios settings}
  desc %q{Synax:

bios{'AssetTag':
  value => 'some hostname',
}

Valid name value pairs can be found by running omconfig chassis biossetup -?

  Serial Communication
  -----------------------------------
  attribute=SerialComm              
setting=<OnNoConRedir><OnConRedirCom1><OnConRedirCom2><Off>
  attribute=SerialPortAddress       
setting=<Serial1Com1Serial2Com2><Serial1Com2Serial2Com1>
  attribute=ExtSerialConnector       setting=<Serial1><Serial2><RemoteAccDevice>
  attribute=FailSafeBaud             setting=<115200><57600><19200><9600>
  attribute=ConTermType              setting=<Vt100Vt220><Ansi>
  attribute=RedirAfterBoot           setting=<Enabled><Disabled>

  System Information
  -----------------------------------

  Memory Settings
  -----------------------------------
  attribute=MemTest                  setting=<Enabled><Disabled>
  attribute=MemOpMode               
setting=<OptimizerMode><MirrorMode><AdvEccMode><FaultResilientMode>
  attribute=NodeInterleave           setting=<Enabled><Disabled>

  Processor Settings
  -----------------------------------
  attribute=LogicalProc              setting=<Enabled><Disabled>
  attribute=QpiSpeed                 setting=<MaxDataRate><8GTps><7GTps><6GTps>
  attribute=RtidSetting              setting=<Enabled><Disabled>
  attribute=ProcVirtualization       setting=<Enabled><Disabled>
  attribute=ProcAdjCacheLine         setting=<Enabled><Disabled>
  attribute=ProcHwPrefetcher         setting=<Enabled><Disabled>
  attribute=DcuStreamerPrefetcher    setting=<Enabled><Disabled>
  attribute=DcuIpPrefetcher          setting=<Enabled><Disabled>
  attribute=ProcExecuteDisable       setting=<Enabled><Disabled>
  attribute=DynamicCoreAllocation    setting=<Enabled><Disabled>
  attribute=ControlledTurbo          setting=<Enabled><Disabled>
  attribute=ProcCores                setting=<All><1><2><4><6><8>

  SATA Settings
  -----------------------------------
  attribute=EmbSata                  setting=<AtaMode><AhciMode><RaidMode><Off>

  Boot Settings
  -----------------------------------
  attribute=BootMode                 setting=<Bios><Uefi>
  attribute=BootSeqRetry             setting=<Enabled><Disabled>

  Integrated Devices
  -----------------------------------
  attribute=IntegratedRaid           setting=<Enabled><Disabled>
  attribute=UsbPorts                 setting=<AllOn><OnlyBackPortsOn><AllOff>
  attribute=InternalUsb              setting=<On><Off>
  attribute=InternalSdCard           setting=<On><Off>
  attribute=IntegratedNetwork1       setting=<Enabled><DisabledOs>
  attribute=IntNic1Port1BootProto    setting=<Unknown><None><Pxe><Iscsi>
  attribute=IntNic1Port2BootProto    setting=<Unknown><None><Pxe><Iscsi>
  attribute=IntNic1Port3BootProto    setting=<Unknown><None><Pxe><Iscsi>
  attribute=IntNic1Port4BootProto    setting=<Unknown><None><Pxe><Iscsi>
  attribute=OsWatchdogTimer          setting=<Enabled><Disabled>
  attribute=IoatEngine               setting=<Enabled><Disabled>
  attribute=SriovGlobalEnable        setting=<Enabled><Disabled>
  attribute=MmioAbove4Gb             setting=<Enabled><Disabled>

  System Profile Settings
  -----------------------------------
  attribute=SysProfile              
setting=<PerfPerWattOptimizedDapc><PerfPerWattOptimizedOs><PerfOptimized><DenseCfgOptimized><Custom>
  attribute=ProcPwrPerf              setting=<SysDbpm><MaxPerf><OsDbpm>
  attribute=MemFrequency            
setting=<MaxPerf><MaxReliability><1866MHz><1600MHz><1333MHz><1067MHz><800MHz>
  attribute=ProcTurboMode            setting=<Enabled><Disabled>
  attribute=ProcC1E                  setting=<Enabled><Disabled>
  attribute=ProcCStates              setting=<Enabled><Disabled>
  attribute=MonitorMwait             setting=<Enabled><Disabled>
  attribute=MemPatrolScrub           setting=<Extended><Standard><Disabled>
  attribute=MemRefreshRate           setting=<1x><2x>
  attribute=MemVolt                  setting=<AutoVolt><Volt15V>
  attribute=CollaborativeCpuPerfCtrl setting=<Disabled><Enabled>

  System Security
  -----------------------------------
  attribute=SysPassword              setting=<string value>
  attribute=SetupPassword            setting=<string value>
  attribute=PasswordStatus           setting=<Unlocked><Locked>
  attribute=TpmSecurity              setting=<Off><OnPbm><OnNoPbm>
  attribute=AcPwrRcvry               setting=<Last><On><Off>
  attribute=AcPwrRcvryDelay          setting=<Immediate><Random><User>

  Miscellaneous Settings
  -----------------------------------
  attribute=AssetTag                 setting=<string value>
  attribute=NumLock                  setting=<On><Off>
  attribute=ReportKbdErr             setting=<Report><NoReport>
  attribute=ErrPrompt                setting=<Enabled><Disabled>
  attribute=InSystemCharacterization setting=<Enabled><Disabled>

  BIOS Boot Settings
  -----------------------------------
  attribute=BootSeq                 
sequence=<NIC.Integrated.1-1-1><HardDisk.List.1-1><Optical.SATAEmbedded.E-1>
  attribute=HddSeq                   sequence=<RAID.Integrated.1-1>

  UEFI Boot Settings
  -----------------------------------

  One-Time Boot
  -----------------------------------
  attribute=OneTimeBootMode         
setting=<Disabled><OneTimeBootSeq><OneTimeHddSeq><OneTimeUefiBootSeq>

  Slot Disablement
  -----------------------------------
  attribute=Slot1                    setting=<Enabled><Disabled><BootDriverDisabled>
  attribute=Slot2                    setting=<Enabled><Disabled><BootDriverDisabled>
  attribute=Slot3                    setting=<Enabled><Disabled><BootDriverDisabled>
  attribute=Slot4                    setting=<Enabled><Disabled><BootDriverDisabled>
  attribute=Slot5                    setting=<Enabled><Disabled><BootDriverDisabled>
  attribute=Slot6                    setting=<Enabled><Disabled><BootDriverDisabled>
  attribute=Slot7                    setting=<Enabled><Disabled><BootDriverDisabled>

  -----------------------------------
  passwd=<string>            This parameter allows to provide the setup password.
  }
  # omreport chassis biossetup -fmt ssv |grep '^Asset Tag;'
  # Asset Tag;somehost
  # omconfig chassis biossetup -? |grep Asset
  # attribute=AssetTag setting=<string value>
  # omconfig chassis biossetup attribute=AssetTag setting=hostabc
  # omreport chassis biossetup -fmt ssv |grep '^Asset Tag;'
  # Asset Tag;hostabc
  #

  newparam(:name, :namevar => true) do
    desc 'the attribute name of the bios setting.'
    validate do |value|
      value.is_a? String
    end
  end

  newproperty(:value) do
    desc 'the value of the bios setting.'
    validate do |value|
      value.is_a? String
    end

  end

end

