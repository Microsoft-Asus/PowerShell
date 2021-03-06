<#
.SYNOPSIS

Will carry out all stages of Domain Controller promotion including modification of default sites and site 
connectors and creation of default OU's
.DESCRIPTION

This script will install the ADDS Role and DNS Role if required.
Change domain zone in a new forest to be forest integrated
Rename Default Site
Rename Default IP Site Link and change replication interval
Add new sites and subnets from csv
Add new conditional forwarers from csv
Create default OU's

.PARAMETER AddExtras
	STRING Used to provide the location of a CSV file containing additional configuration information
	OPTIONAL Only needed if additional forwarders need to be referenced. In reality this should always be
		needed when creating a new forest as it will allow name resolution to other domains

		Format is single header line containing :--  Type, Name, Location
		For Subnets each data line should contain
			SUBNET, networkAddress, siteName
		Where
			networkAddress is the network address in CIDR notation, eg 192.168.1.0/24
			siteName is the name of the site as seen in sites and services
		example
			SUBNET, 192.168.1.0/24, msl

		For DNS Forwarded Zones each data line should contain
			DNS, dnsZone, DNSServers
		Where
			dnsZone is the name of the zone ie, domain.net or 1.168.192.in-addr.arpa
			DNSServers is a list of quoted, comma seperated servers ie "192.168.1.1,192.168.254.1"
		example
			DNS, mgmt.local, "192.168.1.1,192.168.1.2"
		For New DNS Hosted Zones each data line should contain
			DNS, dnsZone, SELF
		example
			DNS, 1.168.192.in-addr.arpa, SELF


.PARAMETER LogOutput
	STRING Used to provide the location of a file to write a log of activity to
	OPTIONAL Only needed if you want a log file creating


.PARAMETER CreateForest
	BOOLEAN parameter to specify if a new forest is to be created
	OPTIONAL Use either -CreateForest | -CreateDomain | -JoinDomain

.PARAMETER CreateDomain
	BOOLEAN parameter to specify if a new domain is to be created in an existing forest
	OPTIONAL Use either -CreateForest | -CreateDomain | -JoinDomain

.PARAMETER JoinDomain
	BOOLEAN parameter to specify if an existing domain is to be joined
	OPTIONAL Use either -CreateForest | -CreateDomain | -JoinDomain

.PARAMETER Forest
	STRING parameter used to specify the name of a forest.
	OPTIONAL, Only used if using -CreateDomain
	
.PARAMETER Domain
	STRING parameter used to provide the domain name.
	MANDATORY for all options.
	
.PARAMETER RecoveryPwd
	STRING parameter used to provide the AD recovery password.
	MANDATORY for all options.
	
.PARAMETER UserName
	STRING parameter used to pass username of an account in the domain/forest you intend to join
	MANDATORY if using -CreateDomain or -JoinDomain
	
.PARAMETER Password
	STRING parameter used to pass password of an account in the domain/forest you intend to join
	MANDATORY if using -CreateDomain or -JoinDomain
	

.EXAMPLE
configure-ActiveDirectory.ps1 -CreateForest -Domain Newdomain.local -RecoveryPwd MyPassword01 -AddExtras e:\extras.csv -LogOutput e:\logfile.txt

.EXAMPLE
configure-ActiveDirectory.ps1 -JoinDomain -Domain Newdomain.local -RecoveryPwd MyPassword01 -Username EnterpriseAdmin -Password SuperSafePwd -AddExtras e:\extras.csv -LogOutput e:\logfile.txt

.EXAMPLE
configure-ActiveDirectory.ps1 -CreateDomain -Forest NewDomain.local -Domain Sub.Newdomain.local -RecoveryPwd MyPassword01 -Username EnterpriseAdmin -Password SuperSafePwd -AddExtras e:\extras.csv -LogOutput e:\logfile.txt

.EXAMPLE
configure-ActiveDirectory.ps1 -CreateDomain -Forest NewDomain.local -Domain Random.local -RecoveryPwd MyPassword01 -Username EnterpriseAdmin -Password SuperSafePwd -AddExtras e:\extras.csv -LogOutput e:\logfile.txt


#>
[CmdletBinding()]
Param(
        [string]$ExecutionPhase = "DCPROMO",
		[string]$AddExtras,
   		[string]$LogOutput,
   
   		[switch]$CreateForest,
		[switch]$CreateDomain,
		[switch]$JoinDomain,
		
		[string]$Forest,
		[string]$Domain,
        [string]$RecoveryPwd,
   		[string]$UserName,
		[string]$Password
)


#--------------------------------------------------------------------------------------------------
#####################################     Configure Default Values     ############################
#--------------------------------------------------------------------------------------------------
#New Name for DEFAULTIPSITELINK
$NewDefaultSiteLinkName = "Default-15Min-Site-Link"

#New Name for DEFAULT-FIRST-SITE-NAME - By default sets to location in server name
#                                        assumes servername is XXX-YYY-ZZZ-nnn
#                                        where YYY is the site code
$NewDefaultSiteName = $env:COMPUTERNAME.split("-")[1].ToUpper()

# Location of AD Database
$DBPath="E:\Windows\NTDS"

# Location of AD Database Log
$LogPath="F:\Windows\NTDS"

# Location of Sysvol
$SysvolPath="G:\Windows\NTDS"


#--------------------------------------------------------------------------------------------------
#####################################     Define Functions     ####################################
#--------------------------------------------------------------------------------------------------
#

function Write-Logfile($text) { 
#--------------------------------------------------------------------------------------------------
# Function to write any output to logfile if specified and to console
#--------------------------------------------------------------------------------------------------
	if ($LogOutput) {
		if (test-path (Split-Path $LogOutput -Parent)) {
			$text | Out-File $LogOutput -Append
		}
	}
	Write-Host $text
}


function Execute-DCPromo($DNSDomainName,$SafeModePassword) { 
#--------------------------------------------------------------------------------------------------
# Function to run DCPromo with correct options for type of request
#--------------------------------------------------------------------------------------------------
    $W2K0Function=0
    $W2K3Function=2
    $W2K8Function=3
    $W2K8R2Function=4

    $RebootAfterInstall="No"
    $InstallDNS="Yes"
    $LeaveDNSSettings="Yes"
	$InstallAsGC="Yes"
    $ForestLevel=$W2K8R2Function
    
    $command="dcpromo /unattend "
    $InstallDNSText=" /InstallDns:"
    $SetDNSToLocalHostText=" /dnsOnNetwork:"
    $NewOrJoinText=" /replicaOrNewDomain:"
    $NewDomainTypeText=" /newDomain:"
    $DNSDomainNameText=" /newDomainDnsName:"
    $NetBiosDomainNameText=" /DomainNetbiosName:"
    $DBPathText=" /databasePath:"
    $LogPathText=" /logPath:"
    $SysvolPathText=" /sysvolpath:"
    $SafeModePwdText=" /safeModeAdminPassword:"
    $ForestLevelText=" /forestLevel:"
    $DomainLevelText=" /domainLevel:"
    $RebootText=" /rebootOnCompletion:"
	$UserNameText=" /Username:"
	$PasswordText=" /Password:"
	
	$GCText=" /confirmGC:"
	
	$NetBOISName=[string]$DNSDomainName.Split(".")[0]
	$ParentDNSDomainText=""
	$ParentDNSDomain=""
	if ($CreateForest) {
		$NewDomainType="forest"
		$NewDomain=$true
        $DCType="domain"
		$UserNameText=""
		$PasswordText=""
		$UserDomainText=""

	}
	elseif ($CreateDomain) {
		if ($Domain -match $Forest) {
			$NewDomainType = "child /childName:"+$NetBOISName
		}
		else {
			$NewDomainType = "tree"
		}
        $DCType="domain"
		$ParentDNSDomainText=" /ParentDomainDNSName:"
		$ParentDNSDomain=$Forest
		$UserDomainText=" /UserDomain:" + $Forest
	}
	elseif ($JoinDomain) {
        $DCType="replica"
		$DNSDomainNameText=" /replicaDomainDNSName:"
		$NewDomainTypeText=""
		$NewDomainType=""
		$NetBiosDomainNameText=""
		$NetBOISName=""
		$UserDomainText=" /UserDomain:" + $Domain
	}
	else {
        throw New-Object System.Management.Automation.RuntimeException("No Valid Options Provided for DCPromo.")
	}
    if ($NewDomain){
    }
    else {
    }
    
    # Check to see if our server already has DNS configured. If we do, don't change the settings otherwise allow 
    #   dcpromo to set the to localhost after installing dns.
    if ((Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE | Where-Object {$_.DNSServerSearchOrder} | measure).count -eq 0) {
        $LeaveDNSSettings="No"
    }
    $command=$command + $InstallDNSText + $InstallDNS + $SetDNSToLocalHostText + $LeaveDNSSettings + $GCText + $InstallAsGC
    $command=$command + $NewOrJoinText + $DCType + $NewDomainTypeText + $NewDomainType + $DNSDomainNameText + $DNSDomainName 
    $command=$command + $NetBiosDomainNameText + $NetBOISName + $SafeModePwdText + $SafeModePassword 
	$command=$command + $ParentDNSDomainText + $ParentDNSDomain
    $command=$command + $DBPathText + """" + $DBPath+ """" + $LogPathText+ """" + $LogPath+ """" + $SysvolPathText+ """" + $SysvolPath+ """" 
    $command=$command + $ForestLevelText + $ForestLevel + $DomainLevelText + $ForestLevel + $RebootText + $RebootAfterInstall
	$command=$command + $UserDomainText + $UserNameText + $UserName + $PasswordText + $Password

    Write-Debug "Run $command ???"            
    invoke-expression -Command $command
	Write-Debug $LastExitCode
}


function Create-RunAfterReboot() {
#--------------------------------------------------------------------------------------------------
# Create a new scheduled task to run at next system reboot.
# This allows us to resume AD Configuration after DC promo needs to restart
#--------------------------------------------------------------------------------------------------
    $TaskScheduler = new-object -com("Schedule.Service")
    $TaskScheduler.connect()
    $RootFolder = $TaskScheduler.getfolder("\")
    $TaskDef = $TaskScheduler.NewTask(0)

    $RegInfo = $TaskDef.RegistrationInfo
    $RegInfo.Description = "Run Domain Configuration script after server restarts"
    $RegInfo.Author = "DCPromo Script"

    $Settings = $TaskDef.Settings
    $Settings.StartWhenAvailable = $True

    $Triggers = $TaskDef.Triggers
    $Trigger = $Triggers.Create(8) # 8 is TASK_TRIGGER_BOOT
    $Trigger.StartBoundary = "2012-11-11T00:00:00"
    $Trigger.EndBoundary = "2022-11-11T00:00:00"
    $Trigger.ExecutionTimeLimit = "PT60M" # time out in 60 minutes
    $Trigger.Id = "BootTriggerId"
    $Trigger.Delay = "PT120S"              # 120 Seconds Delay

    $Action = $TaskDef.Actions.Create(0)  # 0 is executable
    $Action.Path = "powershell"
	$Action.WorkingDirectory = Split-Path -Path $Script:MyInvocation.MyCommand.Path -Parent
	if ($CreateForest)	{$NextPhase="CREATEFOREST"}
	if ($CreateDomain)	{$NextPhase="CREATEDOMAIN"}
	if ($JoinDomain)	{$NextPhase="JOINDOMAIN"}
	$Action.Arguments = "-command ""&'" + $Script:MyInvocation.MyCommand.Path + "' '-ExecutionPhase CONFIGURE " + $NextPhase + "' "
	If ($AddExtras) {$ExtraText = "-AddExtras "+$AddExtras}
	If ($LogOutput) {$LogOutText = "-LogOutPut "+$LogOutput}
	$Action.Arguments = $Action.Arguments + "'" + $ExtraText + "' '" + $LogOutText + "'"""
	
	Write-Debug $Action.Arguments
	

    $RootFolder.RegisterTaskDefinition("Run AD Post Config", $TaskDef, 6, "SYSTEM",$null, 5)
}


function Remove-RunAfterReboot() {
#--------------------------------------------------------------------------------------------------
# Removes the Scheduled Task we created to configure AD. This is removed as last step of the script
#--------------------------------------------------------------------------------------------------
    $TaskScheduler = new-object -com("Schedule.Service")
    $TaskScheduler.connect()
    $RootFolder = $TaskScheduler.getfolder("\")
    $Task = $RootFolder.GetTasks(0)| ? {$_.Name -eq "Run AD Post Config"}
    $RootFolder.DeleteTask($Task.Name,0)
}


function Get-IPNetwork($IPAddress,$SubnetMask) {
#--------------------------------------------------------------------------------------------------
# Function to derive Network Address given IP Address and Subnet Mask
#--------------------------------------------------------------------------------------------------
	If ($IPAddress -eq $null) {Return $IPNetwork=("0.0.0.0").ToString()}
	$IP=$IPAddress.ToString().Split(".")
	$Mask=$SubnetMask.ToString().Split(".")
	$IPNetwork=@()
	for ($i=0;$i -le 3; $i++)
	{        
        $IPNetwork+=@($IP[$i] -band $Mask[$i])
	}
	return [string]::Join(".",$IPNetwork)
}


function Check-ADObject($ADObjectDN) {
#--------------------------------------------------------------------------------------------------
# Function to Check if an AD Object exists. Default behaviour for Get_ADObject is to throw
# an exception if the object does not exists. Here we trap and allow program execution to continue
#--------------------------------------------------------------------------------------------------
    trap [Exception] {
        return $false
    }
    Get-ADObject -Identity $ADObjectDN
    return $true
}


function Get-NetworkBitMask($SubnetMask) {
#--------------------------------------------------------------------------------------------------
# Function to calculate length of sunet mask for CIDR notation
#--------------------------------------------------------------------------------------------------
	$BitMask=0
	$Mask=$SubnetMask.ToString().Split(".")
	for ($i=0;$i -le 3; $i++)
	{
			$BitMask=$BitMask + [convert]::tostring($Mask[$i],2).replace("0","").length
	}
	
	Return $BitMask.ToString()
}


function Create-ADStructure() {
#--------------------------------------------------------------------------------------------------
# Creates the required OU structure for standard domain
#--------------------------------------------------------------------------------------------------
	$ParentOUs = @("_Global", (Get-ADDomain).Name)
	$GroupOUs = @("Distribution", "Administration", "Resource")
	$UserOUs = @("Service", "Admin", "Contacts", "Standard Users")
	
	foreach ($Parent in $ParentOUs) {
		Write-Logfile "Creating $Parent in $((Get-ADRootDSE).defaultNamingContext)"
		New-ADObject -Name $Parent -Path (Get-ADRootDSE).defaultNamingContext -Type organizationalUnit
		Write-LogFile "Creating $Parent\Groups in $((Get-ADRootDSE).defaultNamingContext)"
		New-ADObject -Name "Groups" -Path ("OU="+$Parent+","+(Get-ADRootDSE).defaultNamingContext) -Type organizationalUnit
		foreach ($OU in $GroupOUs) {
			Write-LogFile "Creating $Parent\Groups\$OU in $((Get-ADRootDSE).defaultNamingContext)"
			New-ADObject -Name $OU -Path ("OU=Groups,OU="+$Parent+","+(Get-ADRootDSE).defaultNamingContext) -Type organizationalUnit
		}	
		
		Write-LogFile "Creating $Parent\User Accounts in $((Get-ADRootDSE).defaultNamingContext)"
		New-ADObject -Name "User Accounts" -Path ("OU="+$Parent+","+(Get-ADRootDSE).defaultNamingContext) -Type organizationalUnit
		foreach ($OU in $UserOUs) {
			Write-LogFile "Creating $Parent\User Accounts\$OU in $((Get-ADRootDSE).defaultNamingContext)"
			New-ADObject -Name $OU -Path ("OU=User Accounts,OU="+$Parent+","+(Get-ADRootDSE).defaultNamingContext) -Type organizationalUnit
		}	
		
			Write-LogFile "Creating $Parent\Servers in $((Get-ADRootDSE).defaultNamingContext)"
		New-ADObject -Name "Servers" -Path ("OU="+$Parent+","+(Get-ADRootDSE).defaultNamingContext) -Type organizationalUnit
	}            
}


function Rename-ADSiteLink($SiteLinkName, $NewName) {
#--------------------------------------------------------------------------------------------------
# Function to rename and AD Site Link
#--------------------------------------------------------------------------------------------------
    # Check that Site Link Exists
    $SiteLinkDN = ("CN=" + $SiteLinkName +"," + $siteLinkContainerDN)
    $siteLinkExists = Check-ADObject $SiteLinkDN
    if ($siteLinkExists -eq $false) {
        throw New-Object System.Management.Automation.RuntimeException("The site link named " + $SiteLinkName + " does not exist. Please check the name and try again.")
    }
    else {
        # Rename Site Link
        Rename-ADObject $SiteLinkDN $NewName
    }
}


function Set-ADSiteLinkReplicationInterval($SiteLinkName, $Interval) {
#--------------------------------------------------------------------------------------------------
# Function to set the Replication interval on a site link
#--------------------------------------------------------------------------------------------------

    # Check that Site Link Exists
    $SiteLinkDN = ("CN=" + $SiteLinkName +"," + $siteLinkContainerDN)
    $siteLinkExists = Check-ADObject $SiteLinkDN
    if ($siteLinkExists -eq $false) {
        throw New-Object System.Management.Automation.RuntimeException("The site link named " + $SiteLinkName + " does not exist. Please check the name and try again.")
    }
    else {
        # Set Replication Interval on Site Link
        Get-ADObject $SiteLinkDN -properties replinterval | Set-ADObject -replace @{replinterval=([string]$Interval)}
    }
}


function Rename-ADSite ($SiteName, $NewName) {
#--------------------------------------------------------------------------------------------------
# Functoin to rename an AD Site
#--------------------------------------------------------------------------------------------------
    # Check that Site Exists
    $SiteDN = ("CN=" + $SiteName + "," + $sitesContainerDN)
    $siteExists = Check-ADObject $SiteDN
    if ($siteExists -eq $false) {
        throw New-Object System.Management.Automation.RuntimeException("The site named " + $SiteName  + " does not exist. Please check the name and try again.")
    }
    else {
        #Rename Site
        Rename-ADObject $SiteDN $NewName
    }
}


function New-ADSite ($NewSiteName, $SiteLinkName) {
#--------------------------------------------------------------------------------------------------
# Function to create a new site and assign a site link
#--------------------------------------------------------------------------------------------------
    $SiteDN = ("CN=" + $NewSiteName + "," + $sitesContainerDN)
    $siteLinkDN = "CN=" + $SiteLinkName + "," + $siteLinkContainerDN
    
    #Check that Site Exists
    $siteExists = Check-ADObject $SiteDN
    if ($siteExists) {
        throw New-Object System.Management.Automation.RuntimeException("The site named " + $NewSiteName  + " already exists. Please check the name and try again.")
    }
    else {
        #Check that Site Link Exists
        $siteLinkExists = Check-ADObject $SiteLinkDN
        if ($siteLinkExists -eq $false) {
            throw New-Object System.Management.Automation.RuntimeException("The site link named " + $SiteLinkName + " does not exist. Please check the name and try again.")
        }
        else {
            # Create the New Site
            $NewSiteDN = ("CN=" + $NewSiteName +"," + $sitesContainerDN)
            New-ADObject -Name $NewSiteName -Path $sitesContainerDN -Type site
            New-ADObject -Name "NTDS Site Settings" -Path $NewSiteDN -Type nTDSSiteSettings
            New-ADObject -Name "Servers" -Path $NewSiteDN -Type serversContainer

            # Link to the Site Link
            $siteLink = Get-ADObject $siteLinkDN -Properties siteList
            $siteLink.siteList.Add($newSiteDN)
            # Write the changes to AD
            Set-ADObject -Instance $siteLink 
        }
    }
}


function New-ADIPSubnet ($IPNetworkAddress, $SiteName, $Force) {
#--------------------------------------------------------------------------------------------------
# Function to create a new AD Subnet and assign to site. If $Force is true then will create site if
# it does not already exist
#--------------------------------------------------------------------------------------------------
    $newSubnetDN = ("CN=" + $IPNetworkAddress +"," + $subnetContainerDN)
    # Check if the subnet already exists
    $subnetExists = Check-ADObject $newSubnetDN
    if ($subnetExists) {
        throw New-Object System.Management.Automation.PSArgumentException("Subnet " + $IPNetworkAddress + " already exists. Please check the name and try again.")
    }
    # Check if Site Exists
    $SiteDN = ("CN=" + $SiteName + "," + $sitesContainerDN)
    $siteExists = Check-ADObject $SiteDN
    if ($siteExists -eq $false) {
        if ($Force) {
            New-ADSite $SiteName $NewDefaultSiteLinkName
        }
        else {
            throw New-Object System.Management.Automation.PSArgumentException("Site " + $SiteName + " does not exist. Please check the name and try again.")
        }
    }

    [Hashtable] $ht = new-object -type hashtable
    $ht.Add("siteObject", $siteDN)
    # Create New Subnet    
    New-ADObject -Name ([string]$IPNetworkAddress) -Path $subnetContainerDN -Type subnet -OtherAttributes $ht
}


function Add-DNSForwarder($DNSZone, $DNSServers) {
#--------------------------------------------------------------------------------------------------
# Function to add a new AD Integrated conditional forwarder. Zones are stored in forest dns zone
#--------------------------------------------------------------------------------------------------
	if ($DNSServers -match ",") {
		$DNSServers = $DNSServers.Split(",")
		for ($i = 0; $i -lt $DNSServers.Length;$i++) {
			$DNSList = $DNSList + " " + $DNSServers[$i]
		}
		$DNSServers = $DNSList
	}
    $command="dnscmd  /zoneadd $DNSZone /DsForwarder $DNSServers /DP /forest"
	Invoke-Expression -Command $command 
}

function Add-DNSZone($DNSZone) {
#--------------------------------------------------------------------------------------------------
# Function to add a new AD Integrated Primary dns zone. Zones are stored in forest dns zone
#--------------------------------------------------------------------------------------------------
    $command = "dnscmd /zoneadd $DNSZone /DsPrimary /DP /forest"
	Invoke-Expression -Command $command 
    $command = "dnscmd /config $DNSZone /AllowUpdate 2"
	Invoke-Expression -Command $command 
}


function Move-DNSZone($DNSZone) {
#--------------------------------------------------------------------------------------------------
# Function to move the newly created AD zone so it can be stored in forest dns zone.
#--------------------------------------------------------------------------------------------------
    $command = "dnscmd /ZoneChangeDirectoryPartition $DNSZone /forest"
	Invoke-Expression -Command $command 
}


function Check-NTP() {
#--------------------------------------------------------------------------------------------------
# Function to verify that on the server we are going to promote NTP is configured
#--------------------------------------------------------------------------------------------------
	$NTPType=Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" | %{$_.Type}
	If ($NTPType -eq "NTP") {
		If (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" | %{$_.NtpServer}) {
			return $true
		}
		else {
			return $false
		}
	}
	else {
		return $false
	}
}


function Check-Disks($Path) { #Checks that the disk exists in a given file path
#--------------------------------------------------------------------------------------------------
# Function to verify that the Disk at the root of a given path exists
#--------------------------------------------------------------------------------------------------
    If ((get-item ($Path.Split("\"))[0]  2> $null | Measure-Object).count -eq 1) {
    	return $true}
	Else {
		return $false
	}	
}


function Check-ServerName() {
#--------------------------------------------------------------------------------------------------
# Function to check servername to make sire that the 3rd part is DC (PRJ-LOC-DC-nnn)
#--------------------------------------------------------------------------------------------------
	if(($env:computername.split("-")[2]).ToUpper() -eq "DC") {
		return $true
	}
	else {
		return $false
	}
}


function Check-BuildSecurity() {
#--------------------------------------------------------------------------------------------------
# Function to check the Cable and Wireless key to make sure we were built with correct Security Settings
#--------------------------------------------------------------------------------------------------
	if((Get-Item "HKLM:\Software\Cable and Wireless\Win2K8Base.Web.Hosting.Security.DC" 2>$null| measure-object).Count -eq 1) {
		return $true
	}
	else {
		return $false
	}
}


function Run-PreRequesites() {
#--------------------------------------------------------------------------------------------------
# Function to check any prerequesites before we attempt dcpromo
#--------------------------------------------------------------------------------------------------
	If ((Check-Disks $DBPath) -eq $false) { Throw New-Object System.Management.Automation.RuntimeException("The Database Disk has not yet been created") }
    If ((Check-Disks $LogPath) -eq $false) { Throw New-Object System.Management.Automation.RuntimeException("The Log Disk has not yet been created") }
    If ((Check-Disks $SysvolPath) -eq $false) { Throw New-Object System.Management.Automation.RuntimeException("The Sysvol Disk has not yet been created") }
	If ((Check-NTP) -eq $false) {Throw New-Object System.Management.Automation.RuntimeException("NTP has not yet been configured.") }
	If ((Check-ServerName) -eq $false) {Throw New-Object System.Management.Automation.RuntimeException("The servername does not follow naming conventions.") }
	If ((Check-BuildSecurity) -eq $false) {Throw New-Object System.Management.Automation.RuntimeException("The server has not been built with the correct security profile.") }
}


function Get-DNSDomainController($Hostname) {
#--------------------------------------------------------------------------------------------------
# Function to see if we have a dns server configured
#--------------------------------------------------------------------------------------------------
    trap [Exception] {
        return $false
	}
	[System.Net.Dns]::GetHostEntry($Hostname)
	return $true
}


function Validate-Parameters() {
#--------------------------------------------------------------------------------------------------
# Function to validate that parameters needed for each option have been provided
#--------------------------------------------------------------------------------------------------
	if ($CreateForest) {
		if (-not($Domain -and $RecoveryPwd )) {
			Throw New-Object System.Management.Automation.RuntimeException("Incorrect Parameters Specified, you must specify domain and recoverypwd") 
		}
	}
	elseif ($CreateDomain) {
		if (-not ($Domain -and $Forest -and $RecoveryPwd -and $UserName -and $Password)) {
			Throw New-Object System.Management.Automation.RuntimeException("Incorrect Parameters Specified, you must specify domain, forest, username, password and recoverypwd") 
		}
	}
	elseif ($JoinDomain) {
		if (-not ($Domain -and $RecoveryPwd -and $UserName -and $Password)) {
			Throw New-Object System.Management.Automation.RuntimeException("Incorrect Parameters Specified, you must specify domain, username, password and recoverypwd") 
		}
	}
}

#--------------------------------------------------------------------------------------------------
#####################################     Main Execution     ######################################
#--------------------------------------------------------------------------------------------------


# Hack to allow the second phase to be submitted by Task Scheduler
# Running powershell with -command does not allow parameter to be named
# so parameter name and valued are passed as single pair
  $ExecutionPhase=$ExecutionPhase.ToUpper().Replace("-EXECUTIONPHASE ","")
  $AddExtras=$AddExtras.ToUpper().Replace("-ADDEXTRAS ","")
  $LogOutput=$LogOutput.ToUpper().Replace("-LOGOUTPUT ","")


Validate-Parameters

switch -wildcard ($ExecutionPhase.ToUpper()) {
	"DCPROMO" {
		if (-not ($CreateForest -or $CreateDomain -or $JoinDomain)) {Throw New-Object System.Management.Automation.RuntimeException("No DCPROMO Options provided.") }
		Run-PreRequesites
		if (-not $CreateForest) {
			if ($CreateDomain) {if (-not (Get-DNSDomainController $Forest)) {Throw New-Object System.Management.Automation.RuntimeException("Unable to resolve domain " + $Domain + " correct dns settings and try again.") }}
			if ($JoinDomain) {if (-not (Get-DNSDomainController $Domain)) {Throw New-Object System.Management.Automation.RuntimeException("Unable to resolve domain " + $Domain + " correct dns settings and try again.") }}
			
	    }
		Write-Logfile "Installing Active Directory"
	    Execute-DCPromo $Domain $RecoveryPwd
		if ([int]$LastExitCode -le 10) {
			Write-Logfile "Scheduling Task for next reboot"
	    	Create-RunAfterReboot
			Write-Logfile "Restarting Server"
	    	restart-Computer -Force -Confirm:$false
		}
		else {
			Write-Logfile "There was an error with dcpromo. The error code was $LastExitCode. Please check $env:Systemroot\debug\dcpromo.log for more details"
		}
	}

	"CONFIGURE*" {
    	Write-LogFile "Performing Post AD Installation Configuration"
    	Import-Module ActiveDirectory
    	$configNCDN = (Get-ADRootDSE).ConfigurationNamingContext
    	$siteLinkContainerDN = ("CN=IP,CN=Inter-Site Transports,CN=Sites," + $configNCDN)
    	$sitesContainerDN = ("CN=Sites," + $configNCDN)
    	$subnetContainerDN = ("CN=Subnets,CN=Sites," + $configNCDN)    #
		switch -wildcard ($ExecutionPhase) {
			"*CREATEFOREST" {
				# Create Default OU Structure
				Write-Logfile "Creating Active Directory OU Structure"
				Create-ADStructure
				
			    # Change Default Site Link Settings
		    	Write-LogFile "Modifying Default Site Link Configuration"
		    	Set-ADSiteLinkReplicationInterval "DEFAULTIPSITELINK" 15
		    	Rename-ADSiteLink "DEFAULTIPSITELINK" $NewDefaultSiteLinkName

			    # Rename Default Site
			    Write-LogFile "Renaming Default Site"
			    Rename-ADSite "Default-First-Site-Name" $NewDefaultSiteName

		    	# Create Subnets in default site for all connected subnets
		    	foreach ($IPAddressPair in (Get-Wmiobject Win32_NetworkAdapterConfiguration | select IPAddress, IPSubnet | ? {-not $_.IPAddress -eq ""})) {    
			        $SubnetCIDRFormat = (Get-IPNetwork ([string]$IPAddressPair.IPAddress) ([string]$IPAddressPair.IPSubnet)) + "/" + (Get-NetworkBitMask ([string]$IPAddressPair.IPSubnet))
		        	Write-LogFile ("Adding Subnet for IP range " + $SubnetCIDRFormat + " to site:" + $NewDefaultSiteName)
		        	New-ADIPSubnet $SubnetCIDRFormat $NewDefaultSiteName 
		    	}
	 
				# Process any items in the File Passed in -AddExtras parameter
				#  Format is SUBNET, IPAddress in CIDR Notation, Site to add to
				#  Will add the Site if it does not exist.
				#  MUST have Header Row :- TYPE,NAME,LOCATION
				#
		    	If ((get-item $AddExtras 2> $null | measure).count -eq 1) {
			        import-csv $AddExtras | where-object {$_.Type.ToUpper() -eq "SUBNET"} | foreach{
					Write-LogFile ("Adding Subnet for IP range " + $_.Name + " to site:" + $_.Location)
			            New-ADIPSubnet $_.Name $_.Location $true
		        	}
		    	}
		    
			    # Make Changes to Domain DNS zone to store in ForestDNSZone rather ath DomainDNSZone
			    Write-LogFile ("Moving " + $((Get-ADDomain).DNSRoot) + " to ForestDNSZone")
			    Move-DNSZone $((Get-ADDomain).DNSRoot)
		    
		    	#
				# Process any items in the File Passed in -AddExtras parameter
				#  Format is DNS, Zone File, IP Addresses of forwarders in quotes if more than 1
				#  MUST have Header Row :- TYPE,NAME,LOCATION
				#
		    
		    	If ((get-item $AddExtras  2> $null | measure).count -eq 1) {
			        import-csv $AddExtras | where-object {$_.Type.ToUpper() -eq "DNS"} | foreach{
						Write-LogFile ("Adding forwarder for zone " + $_.Name + " to " + $_.Location)
						If ($_.Location.ToUpper() -eq "SELF") {
							Add-DNSZone $_.Name
						}
						Else {
							Add-DNSForwarder $_.Name $_.Location
						}
		    		}
		    	}
			}
			"*CREATEDOMAIN" {
				# Create Default OU Structure
				Write-Logfile "Creating Active Directory OU Structure"
				Create-ADStructure
			    # Make Changes to Domain DNS zone to store in ForestDNSZone rather than DomainDNSZone
			    Write-LogFile ("Moving " + $((Get-ADDomain).DNSRoot) + " to ForestDNSZone")
			    Move-DNSZone $((Get-ADDomain).DNSRoot)
			}
			"*JOINDOMAIN" {
				# If we are the 2nd DC in a domain then Infrastructure Master will
				#  still reside on PDC Emulator. If this is the case, move to new DC
				if ((Get-ADDomain).InfrastructureMaster -eq (Get-ADDomain).PDCEmulator) {
					Write-Logfile "Transfering Infrastructure Master"
					Move-ADDirectoryServerOperationMasterRole -Identity $Env:COMPUTERNAME -OperationMasterRole InfrastructureMaster -confirm:$false
				}
			}
		}
		# Delete scheduled task that kicked of the post Config so it does not run again
		Write-Logfile "Removing Scheduled Task"
	    Remove-RunAfterReboot
	}
}