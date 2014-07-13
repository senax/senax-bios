# bios type and Dell provider

## Overview

Puppet module developed to manage BIOS settings on Dell servers running RedHat Enterprise Linux.
Tested on Dell R720 servers running RHEL6 and Puppet Enterprise 3.2.x. It provides a generic 'bios' type and currently one provider 'dell.rb'. Support for other providers should be easy to add.

The provider can list current settings 'puppet resource bios' which can be very helpful.

## Requirements

Dell OpenManage needs to be installed on the server to be managed for example from the srvadmin-all meta rpm available from http://linux.dell.com/repo/hardware/

## Examples

To set the server up for OS managed power control:

  bios{'SysProfile':
    value   => 'Custom',
  }
  bios{'ProcPwrPerf':
    value   => 'OsDbpm',
  }

To list all current bios settings:
  puppet resource bios

