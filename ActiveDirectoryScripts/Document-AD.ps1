﻿#Requires -Version 3.0
#requires -Module ActiveDirectory
#This File is in Unicode format.  Do not edit in an ASCII editor.

<#
.SYNOPSIS
	Creates a complete inventory of a Microsoft Active Directory Forest using Microsoft Word 2010 or 2013.
.DESCRIPTION
	Creates a complete inventory of a Microsoft Active Directory Forest using Microsoft Word and PowerShell.
	Creates a Word document named after the Active Directory Forest.
	Document includes a Cover Page, Table of Contents and Footer.
	Includes support for the following language versions of Microsoft Word:
		Catalan
		Danish
		Dutch
		English
		Finnish
		French
		German
		Norwegian
		Portuguese
		Spanish
		Swedish

	While most of the script can be run with a non admin account, there are some features 
	that will not or may not work without domain admin rights.  The Hardware and Services 
	parameters require domain admin privileges.  The count of all users may not be accurate
	if the user running the script doesn't have the necessary permissions on all user
	objects.  In that case, there may be user accounts classified as "unknown".
.PARAMETER CompanyName
	Company Name to use for the Cover Page.  
	Default value is contained in HKCU:\Software\Microsoft\Office\Common\UserInfo\CompanyName or
	HKCU:\Software\Microsoft\Office\Common\UserInfo\Company, whichever is populated on the 
	computer running the script.
	This parameter has an alias of CN.
	If either registry key does not exist and this parameter is not specified, the report will
	not contain a Company Name on the cover page.
.PARAMETER CoverPage
	What Microsoft Word Cover Page to use.
	Only Word 2010 and 2013 are supported.
	(default cover pages in Word en-US)
	Valid input is:
		Alphabet (Word 2010. Works)
		Annual (Word 2010. Doesn't work well for this report)
		Austere (Word 2010. Works)
		Austin (Word 2010/2013. Doesn't work in 2013, mostly works in 2010 but Subtitle/Subject & Author fields need to me moved after title box is moved up)
		Banded (Word 2013. Works)
		Conservative (Word 2010. Works)
		Contrast (Word 2010. Works)
		Cubicles (Word 2010. Works)
		Exposure (Word 2010. Works if you like looking sideways)
		Facet (Word 2013. Works)
		Filigree (Word 2013. Works)
		Grid (Word 2010/2013.Works in 2010)
		Integral (Word 2013. Works)
		Ion (Dark) (Word 2013. Top date doesn't fit, box needs to be manually resized or font changed to 8 point)
		Ion (Light) (Word 2013. Top date doesn't fit, box needs to be manually resized or font changed to 8 point)
		Mod (Word 2010. Works)
		Motion (Word 2010/2013. Works if top date is manually changed to 36 point)
		Newsprint (Word 2010. Works but date is not populated)
		Perspective (Word 2010. Works)
		Pinstripes (Word 2010. Works)
		Puzzle (Word 2010. Top date doesn't fit, box needs to be manually resized or font changed to 14 point)
		Retrospect (Word 2013. Works)
		Semaphore (Word 2013. Works)
		Sideline (Word 2010/2013. Doesn't work in 2013, works in 2010)
		Slice (Dark) (Word 2013. Doesn't work)
		Slice (Light) (Word 2013. Doesn't work)
		Stacks (Word 2010. Works)
		Tiles (Word 2010. Date doesn't fit unless changed to 26 point)
		Transcend (Word 2010. Works)
		ViewMaster (Word 2013. Works)
		Whisp (Word 2013. Works)
	Default value is Sideline.
	This parameter has an alias of CP.
.PARAMETER UserName
	User name to use for the Cover Page and Footer.
	Default value is contained in $env:username
	This parameter has an alias of UN.
.PARAMETER PDF
	SaveAs PDF file instead of DOCX file.
	This parameter is disabled by default.
	The PDF file is roughly 5X to 10X larger than the DOCX file.
.PARAMETER Text
	Creates a formatted text file with a .txt extension.
	This parameter is disabled by default.
.PARAMETER MSWord
	SaveAs DOCX file
	This parameter is set True if no other output format is selected.
.PARAMETER HTML
	Creates an HTML file with an .html extension.
	This parameter is disabled by default.
	This parameter is reserved for a future update and no output is created at this time.
.PARAMETER Hardware
	Use WMI to gather hardware information on: Computer System, Disks, Processor and Network Interface Cards
	Will be used on Domain Controllers only.
	This parameter requires the script be run from an elevated PowerShell session 
	using an account with permission to retrieve hardware information (i.e. Domain Admin).
	Selecting this parameter will add to both the time it takes to run the script and size of the report.
	This parameter is disabled by default.
.PARAMETER ADForest
	Specifies an Active Directory forest object by providing one of the following attribute values. 
	The identifier in parentheses is the LDAP display name for the attribute.

	Fully qualified domain name
		Example: corp.contoso.com
	GUID (objectGUID)
		Example: 599c3d2e-f72d-4d20-8a88-030d99495f20
	DNS host name
		Example: dnsServer.corp.contoso.com
	NetBIOS name
		Example: corp
		
	This parameter is required.
.PARAMETER ComputerName
	Specifies which domain controller to use to run the script against.
	If ADForest is a trusted forest then ComputerName is required to detect the existence of ADForest.
	ComputerName can be entered as the NetBIOS name, FQDN, localhost or IP Address.
	If entered as localhost, the actual computer name is determined and used.
	If entered as an IP address, an attempt is made to determine and use the actual computer name.
.PARAMETER Services
	Gather information on all services running on domain controllers.
	Servers that are configured to automatically start but are not running will be colored in red.
	Will be used on Domain Controllers only.
	This parameters requires the script be run from an elevated PowerShell session
	using an account with permission to retrieve service information (i.e. Domain Admin).
	Selecting this parameter will add to both the time it takes to run the script and size of the report.
	This parameter is disabled by default.
.PARAMETER AddDateTime
	Adds a date time stamp to the end of the file name.
	Time stamp is in the format of yyyy-MM-dd_HHmm.
	June 1, 2014 at 6PM is 2014-06-01_1800.
	Output filename will be ReportName_2014-06-01_1800.docx (or .pdf).
	This parameter is disabled by default.
.EXAMPLE
	PS C:\PSScript > .\ADDS_Inventory_V1_1.ps1 -ADForest company.tld
	
	Will use all default values.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
	$env:username = Administrator

	Carl Webster for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.
	company.tld for the AD Forest
.EXAMPLE
	PS C:\PSScript > .\ADDS_Inventory_V1_1.ps1 -PDF -ADForest corp.carlwebster.com
	
	Will use all default values and save the document as a PDF file.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
	$env:username = Administrator

	Carl Webster for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.
	corp.carlwebster.com for the AD Forest
.EXAMPLE
	PS C:\PSScript > .\ADDS_Inventory_V1_1.ps1 -Text -ADForest corp.carlwebster.com
	
	This parameter is reserved for a future update and no output is created at this time.

	Will use all default values and save the document as a formatted text file.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
	$env:username = Administrator

	Carl Webster for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.
	corp.carlwebster.com for the AD Forest
.EXAMPLE
	PS C:\PSScript > .\ADDS_Inventory_V1_1.ps1 -HTML -ADForest corp.carlwebster.com
	
	This parameter is reserved for a future update and no output is created at this time.

	Will use all default values and save the document as an HTML file.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
	$env:username = Administrator

	Carl Webster for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.
	corp.carlwebster.com for the AD Forest
.EXAMPLE
	PS C:\PSScript > .\ADDS_Inventory_V1_1.ps1 -hardware
	
	Will use all default values and add additional information for each domain controller about its hardware.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
	$env:username = Administrator

	Carl Webster for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.
	The user will be prompted for ADForest.
.EXAMPLE
	PS C:\PSScript .\ADDS_Inventory_V1_1.ps1 -CompanyName "Carl Webster Consulting" -CoverPage "Mod" -UserName "Carl Webster" -ComputerName ADDC01

	Will use:
		Carl Webster Consulting for the Company Name.
		Mod for the Cover Page format.
		Carl Webster for the User Name.
		The user will be prompted for ADForest.
		Domain Controller named ADDC01 for the ComputerName.
.EXAMPLE
	PS C:\PSScript .\ADDS_Inventory_V1_1.ps1 -CN "Carl Webster Consulting" -CP "Mod" -UN "Carl Webster"

	Will use:
		Carl Webster Consulting for the Company Name (alias CN).
		Mod for the Cover Page format (alias CP).
		Carl Webster for the User Name (alias UN).
		The user will be prompted for ADForest.
		The computer running the script for the ComputerName.
.EXAMPLE
	PS C:\PSScript > .\ADDS_Inventory_V1_1.ps1 -ADForest company.tld -AddDateTime
	
	Will use all default values.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
	$env:username = Administrator

	Carl Webster for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.
	company.tld for the AD Forest

	Adds a date time stamp to the end of the file name.
	Time stamp is in the format of yyyy-MM-dd_HHmm.
	June 1, 2014 at 6PM is 2014-06-01_1800.
	Output filename will be company.tld_2014-06-01_1800.docx
.EXAMPLE
	PS C:\PSScript > .\ADDS_Inventory_V1_1.ps1 -PDF -ADForest corp.carlwebster.com -AddDateTime
	
	Will use all default values and save the document as a PDF file.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName="Carl Webster" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Carl Webster"
	$env:username = Administrator

	Carl Webster for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.
	corp.carlwebster.com for the AD Forest

	Adds a date time stamp to the end of the file name.
	Time stamp is in the format of yyyy-MM-dd_HHmm.
	June 1, 2014 at 6PM is 2014-06-01_1800.
	Output filename will be corp.carlwebster.com_2014-06-01_1800.PDF
.INPUTS
	None.  You cannot pipe objects to this script.
.OUTPUTS
	No objects are output from this script.  This script creates a Word or PDF document.
.NOTES
	NAME: ADDS_Inventory_V1_1.ps1
	VERSION: 1.1
	AUTHOR: Carl Webster
	LASTEDIT: August 7, 2014
#>


#thanks to @jeffwouters and Michael B. Smith for helping me with these parameters
[CmdletBinding(SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "Word") ]

Param(
	[parameter(ParameterSetName="Word",Mandatory=$False)] 
	[Switch]$MSWord=$False,

	[parameter(ParameterSetName="PDF",Mandatory=$False)] 
	[Switch]$PDF=$False,

	[parameter(ParameterSetName="Text",Mandatory=$False)] 
	[Switch]$Text=$False,

	[parameter(ParameterSetName="HTML",Mandatory=$False)] 
	[Switch]$HTML=$False,

	[parameter(Mandatory=$False)] 
	[Switch]$Hardware=$False, 

	[parameter(Mandatory=$True)] 
	[string]$ADForest="", 

	[parameter(Mandatory=$False)] 
	[string]$ComputerName="",
	
	[parameter(Mandatory=$False )] 
	[Switch]$Services=$False,
	
	[parameter(Mandatory=$False)] 
	[Switch]$AddDateTime=$False,
	
	[parameter(ParameterSetName="Word",Mandatory=$False)] 
	[parameter(ParameterSetName="PDF",Mandatory=$False)] 
	[Alias("CN")]
	[ValidateNotNullOrEmpty()]
	[string]$CompanyName="",
    
	[parameter(ParameterSetName="Word",Mandatory=$False)] 
	[parameter(ParameterSetName="PDF",Mandatory=$False)] 
	[Alias("CP")]
	[ValidateNotNullOrEmpty()]
	[string]$CoverPage="Sideline", 

	[parameter(ParameterSetName="Word",Mandatory=$False)] 
	[parameter(ParameterSetName="PDF",Mandatory=$False)] 
	[Alias("UN")]
	[ValidateNotNullOrEmpty()]
	[string]$UserName=$env:username

	)

	
#webster@carlwebster.com
#@carlwebster on Twitter
#http://www.CarlWebster.com
#Created on April 10, 2014

#Version 1.0 released to the community on May 31, 2014
#
#Version 1.01
#	Added an AddDateTime parameter
#Version 1.02
#	Fixed the Enterprise Admins and Schema Admins privileged groups tables
#Version 1.1
#	Cleanup the script's parameters section
#	Code cleanup and standardization with the master template script
#	Requires PowerShell V3 or later
#	Removed support for Word 2007
#	Word 2007 references in help text removed
#	Cover page parameter now states only Word 2010 and 2013 are supported
#	Most Word 2007 references in script removed:
#		Function ValidateCoverPage
#		Function SetupWord
#		Function SaveandCloseDocumentandShutdownWord
#	Function CheckWord2007SaveAsPDFInstalled removed
#	If Word 2007 is detected, an error message is now given and the script is aborted
#	Cleanup Word table code for the first row and background color
#	Cleanup retrieving services and service startup type with Iain Brighton's optimization
#	Add Iain Brighton's Word table functions
#	Move Services table to new table functions
#	Add numeric values for ForestMode and DomainMode
#	Removed most of the [gc]::collect() as they are not needed
#	Removed the CheckLoadedModule function
#	Added a Requires activedirectory module statement

Set-StrictMode -Version 2

#force  on
$PSDefaultParameterValues = @{"*:Verbose"=$True}
$SaveEAPreference = $ErrorActionPreference
$ErrorActionPreference = 'SilentlyContinue'

If($PDF -eq $Null)
{
	$PDF = $False
}
If($Text -eq $Null)
{
	$Text = $False
}
If($MSWord -eq $Null)
{
	$MSWord = $False
}
If($HTML -eq $Null)
{
	$HTML = $False
}
If($Services -eq $Null)
{
	$Services = $False
}
If($AddDateTime -eq $Null)
{
	$AddDateTime = $False
}
If($Hardware -eq $Null)
{
	$Hardware = $False
}
If($ComputerName -eq $Null)
{
	$ComputerName = "LocalHost"
}

If(!(Test-Path Variable:PDF))
{
	$PDF = $False
}
If(!(Test-Path Variable:Text))
{
	$Text = $False
}
If(!(Test-Path Variable:MSWord))
{
	$MSWord = $False
}
If(!(Test-Path Variable:HTML))
{
	$HTML = $False
}
If(!(Test-Path Variable:Services))
{
	$Services = $False
}
If(!(Test-Path Variable:AddDateTime))
{
	$AddDateTime = $False
}
If(!(Test-Path Variable:Hardware))
{
	$Hardware = $False
}
If(!(Test-Path Variable:ComputerName))
{
	$ComputerName = "LocalHost"
}

If($MSWord -eq $Null)
{
	If($Text -or $HTML -or $PDF)
	{
		$MSWord = $False
	}
	Else
	{
		$MSWord = $True
	}
}

If($MSWord -eq $False -and $PDF -eq $False -and $Text -eq $False -and $HTML -eq $False)
{
	$MSWord = $True
}

Write-Verbose "$(Get-Date): Testing output parameters"

If($MSWord)
{
	Write-Verbose "$(Get-Date): MSWord is set"
}
ElseIf($PDF)
{
	Write-Verbose "$(Get-Date): PDF is set"
}
ElseIf($Text)
{
	Write-Verbose "$(Get-Date): Text is set"
}
ElseIf($HTML)
{
	Write-Verbose "$(Get-Date): HTML is set"
}
Else
{
	$ErrorActionPreference = $SaveEAPreference
	Write-Verbose "$(Get-Date): Unable to determine output parameter"
	If($MSWord -eq $Null)
	{
		Write-Verbose "$(Get-Date): MSWord is Null"
	}
	ElseIf($PDF -eq $Null)
	{
		Write-Verbose "$(Get-Date): PDF is Null"
	}
	ElseIf($Text -eq $Null)
	{
		Write-Verbose "$(Get-Date): Text is Null"
	}
	ElseIf($HTML -eq $Null)
	{
		Write-Verbose "$(Get-Date): HTML is Null"
	}
	Else
	{
		Write-Verbose "$(Get-Date): MSWord is $($MSWord)"
		Write-Verbose "$(Get-Date): PDF is $($PDF)"
		Write-Verbose "$(Get-Date): Text is $($Text)"
		Write-Verbose "$(Get-Date): HTML is $($HTML)"
	}
	Write-Error "Unable to determine output parameter.  Script cannot continue"
	Exit
}

If($MSWord -or $PDF)
{
	#try and fix the issue with the $CompanyName variable
	$CoName = $CompanyName
	Write-Verbose "$(Get-Date): CoName is $($CoName)"
	
	#the following values were attained from 
	#http://groovy.codehaus.org/modules/scriptom/1.6.0/scriptom-office-2K3-tlb/apidocs/
	#http://msdn.microsoft.com/en-us/library/office/aa211923(v=office.11).aspx
	[int]$wdAlignPageNumberRight = 2
	[long]$wdColorGray15 = 14277081
	[long]$wdColorGray05 = 15987699 
	[int]$wdMove = 0
	[int]$wdSeekMainDocument = 0
	[int]$wdSeekPrimaryFooter = 4
	[int]$wdStory = 6
	[int]$wdColorRed = 255
	[int]$wdColorBlack = 0
	[int]$wdWord2007 = 12
	[int]$wdWord2010 = 14
	[int]$wdWord2013 = 15
	[int]$wdFormatDocumentDefault = 16
	[int]$wdSaveFormatPDF = 17
	#http://blogs.technet.com/b/heyscriptingguy/archive/2006/03/01/how-can-i-right-align-a-single-column-in-a-word-table.aspx
	#http://msdn.microsoft.com/en-us/library/office/ff835817%28v=office.15%29.aspx
	[int]$wdAlignParagraphLeft = 0
	[int]$wdAlignParagraphCenter = 1
	[int]$wdAlignParagraphRight = 2
	#http://msdn.microsoft.com/en-us/library/office/ff193345%28v=office.15%29.aspx
	[int]$wdCellAlignVerticalTop = 0
	[int]$wdCellAlignVerticalCenter = 1
	[int]$wdCellAlignVerticalBottom = 2
	#http://msdn.microsoft.com/en-us/library/office/ff844856%28v=office.15%29.aspx
	[int]$wdAutoFitFixed = 0
	[int]$wdAutoFitContent = 1
	[int]$wdAutoFitWindow = 2
	#http://msdn.microsoft.com/en-us/library/office/ff821928%28v=office.15%29.aspx
	[int]$wdAdjustNone = 0
	[int]$wdAdjustProportional = 1
	[int]$wdAdjustFirstColumn = 2
	[int]$wdAdjustSameWidth = 3

	[int]$PointsPerTabStop = 36
	[int]$Indent0TabStops = 0 * $PointsPerTabStop
	[int]$Indent1TabStops = 1 * $PointsPerTabStop
	[int]$Indent2TabStops = 2 * $PointsPerTabStop
	[int]$Indent3TabStops = 3 * $PointsPerTabStop
	[int]$Indent4TabStops = 4 * $PointsPerTabStop

	# http://www.thedoctools.com/index.php?show=wt_style_names_english_danish_german_french
	[int]$wdStyleHeading1 = -2
	[int]$wdStyleHeading2 = -3
	[int]$wdStyleHeading3 = -4
	[int]$wdStyleHeading4 = -5
	[int]$wdStyleNoSpacing = -158
	[int]$wdTableGrid = -155

	#http://groovy.codehaus.org/modules/scriptom/1.6.0/scriptom-office-2K3-tlb/apidocs/org/codehaus/groovy/scriptom/tlb/office/word/WdLineStyle.html
	[int]$wdLineStyleNone = 0
	[int]$wdLineStyleSingle = 1

	[int]$wdHeadingFormatTrue = -1
	[int]$wdHeadingFormatFalse = 0 

	[string]$RunningOS = (Get-WmiObject -class Win32_OperatingSystem -EA 0).Caption
}

Function GetComputerWMIInfo
{
	Param([string]$RemoteComputerName)
	
	# original work by Kees Baggerman, 
	# Senior Technical Consultant @ Inter Access
	# k.baggerman@myvirtualvision.com
	# @kbaggerman on Twitter
	# http://blog.myvirtualvision.com
	# modified 1-May-2014 to work in trusted AD Forests and using different domain admin credentials	

	#Get Computer info
	Write-Verbose "$(Get-Date): `t`tProcessing WMI Computer information"
	Write-Verbose "$(Get-Date): `t`t`tHardware information"
	If($MSWord -or $PDF)
	{
		WriteWordLine 3 0 "Computer Information"
		WriteWordLine 0 1 "General Computer"
	}
	ElseIf($Text)
	{
		Line 0 "Computer Information"
		Line 1 "General Computer"
	}
	ElseIf($HTML)
	{
	}
	
	[bool]$GotComputerItems = $True
	
	Try
	{
		$Results = Get-WmiObject -computername $RemoteComputerName win32_computersystem
	}
	
	Catch
	{
		$Results = $Null
	}
	
	If($? -and $Results -ne $Null)
	{
		$ComputerItems = $Results | Select Manufacturer, Model, Domain, @{N="TotalPhysicalRam"; E={[math]::round(($_.TotalPhysicalMemory / 1GB),0)}}
		$Results = $Null

		ForEach($Item in $ComputerItems)
		{
			OutputComputerItem $Item
		}
	}
	ElseIf(!$?)
	{
		Write-Verbose "$(Get-Date): Get-WmiObject win32_computersystem failed for $($RemoteComputerName)"
		Write-Warning "Get-WmiObject win32_computersystem failed for $($RemoteComputerName)"
		If($MSWORD -or $PDF)
		{
			WriteWordLine 0 2 "Get-WmiObject win32_computersystem failed for $($RemoteComputerName)" "" $Null 0 $False $True
			WriteWordLine 0 2 "On $($RemoteComputerName) you may need to run winmgmt /verifyrepository" "" $Null 0 $False $True
			WriteWordLine 0 2 "and winmgmt /salvagerepository.  If this is a trusted Forest, you may" "" $Null 0 $False $True
			WriteWordLine 0 2 "need to rerun the script with Domain Admin credentials from the trusted Forest." "" $Null 0 $False $True
		}
		ElseIf($Text)
		{
			Line 2 "Get-WmiObject win32_computersystem failed for $($RemoteComputerName)"
			Line 2 "On $($RemoteComputerName) you may need to run winmgmt /verifyrepository"
			Line 2 "and winmgmt /salvagerepository.  If this is a trusted Forest, you may"
			Line 2 "need to rerun the script with Domain Admin credentials from the trusted Forest."
			Line 2 ""
		}
		ElseIf($HTML)
		{
		}
	}
	Else
	{
		Write-Verbose "$(Get-Date): No results returned for Computer information"
		If($MSWORD -or $PDF)
		{
			WriteWordLine 0 2 "No results returned for Computer information" "" $Null 0 $False $True
		}
		ElseIf($Text)
		{
			Line 2 "No results returned for Computer information"
		}
		ElseIf($HTML)
		{
		}
	}
	
	#Get Disk info
	Write-Verbose "$(Get-Date): `t`t`tDrive information"

	If($MSWord -or $PDF)
	{
		WriteWordLine 0 1 "Drive(s)"
	}
	ElseIf($Text)
	{
		Line 1 "Drive(s)"
	}
	ElseIf($HTML)
	{
	}

	[bool]$GotDrives = $True
	
	Try
	{
		$Results = Get-WmiObject -computername $RemoteComputerName Win32_LogicalDisk
	}
	
	Catch
	{
		$Results = $Null
	}

	If($? -and $Results -ne $Null)
	{
		$drives = $Results | Select caption, @{N="drivesize"; E={[math]::round(($_.size / 1GB),0)}}, 
		filesystem, @{N="drivefreespace"; E={[math]::round(($_.freespace / 1GB),0)}}, 
		volumename, drivetype, volumedirty, volumeserialnumber
		$Results = $Null
		ForEach($drive in $drives)
		{
			If($drive.caption -ne "A:" -and $drive.caption -ne "B:")
			{
				OutputDriveItem $drive
			}
		}
	}
	ElseIf(!$?)
	{
		Write-Verbose "$(Get-Date): Get-WmiObject Win32_LogicalDisk failed for $($RemoteComputerName)"
		Write-Warning "Get-WmiObject Win32_LogicalDisk failed for $($RemoteComputerName)"
		If($MSWORD -or $PDF)
		{
			WriteWordLine 0 2 "Get-WmiObject Win32_LogicalDisk failed for $($RemoteComputerName)" "" $Null 0 $False $True
			WriteWordLine 0 2 "On $($RemoteComputerName) you may need to run winmgmt /verifyrepository" "" $Null 0 $False $True
			WriteWordLine 0 2 "and winmgmt /salvagerepository.  If this is a trusted Forest, you may" "" $Null 0 $False $True
			WriteWordLine 0 2 "need to rerun the script with Domain Admin credentials from the trusted Forest." "" $Null 0 $False $True
		}
		ElseIf($Text)
		{
			Line 2 "Get-WmiObject Win32_LogicalDisk failed for $($RemoteComputerName)"
			Line 2 "On $($RemoteComputerName) you may need to run winmgmt /verifyrepository"
			Line 2 "and winmgmt /salvagerepository.  If this is a trusted Forest, you may"
			Line 2 "need to rerun the script with Domain Admin credentials from the trusted Forest."
		}
		ElseIf($HTML)
		{
		}
	}
	Else
	{
		Write-Verbose "$(Get-Date): No results returned for Drive information"
		If($MSWORD -or $PDF)
		{
			WriteWordLine 0 2 "No results returned for Drive information" "" $Null 0 $False $True
		}
		ElseIf($Text)
		{
			Line 2 "No results returned for Drive information"
		}
		ElseIf($HTML)
		{
		}
	}
	

	#Get CPU's and stepping
	Write-Verbose "$(Get-Date): `t`t`tProcessor information"

	If($MSWord -or $PDF)
	{
		WriteWordLine 0 1 "Processor(s)"
	}
	ElseIf($Text)
	{
		Line 1 "Processor(s)"
	}
	ElseIf($HTML)
	{
	}

	[bool]$GotProcessors = $True
	
	Try
	{
		$Results = Get-WmiObject -computername $RemoteComputerName win32_Processor
	}
	
	Catch
	{
		$Results = $Null
	}

	If($? -and $Results -ne $Null)
	{
		$Processors = $Results | Select availability, name, description, maxclockspeed, 
		l2cachesize, l3cachesize, numberofcores, numberoflogicalprocessors
		$Results = $Null
		ForEach($processor in $processors)
		{
			OutputProcessorItem $processor
		}
	}
	ElseIf(!$?)
	{
		Write-Verbose "$(Get-Date): Get-WmiObject win32_Processor failed for $($RemoteComputerName)"
		Write-Warning "Get-WmiObject win32_Processor failed for $($RemoteComputerName)"
		If($MSWORD -or $PDF)
		{
			WriteWordLine 0 2 "Get-WmiObject win32_Processor failed for $($RemoteComputerName)" "" $Null 0 $False $True
			WriteWordLine 0 2 "On $($RemoteComputerName) you may need to run winmgmt /verifyrepository" "" $Null 0 $False $True
			WriteWordLine 0 2 "and winmgmt /salvagerepository.  If this is a trusted Forest, you may" "" $Null 0 $False $True
			WriteWordLine 0 2 "need to rerun the script with Domain Admin credentials from the trusted Forest." "" $Null 0 $False $True
		}
		ElseIf($Text)
		{
			Line 2 "Get-WmiObject win32_Processor failed for $($RemoteComputerName)"
			Line 2 "On $($RemoteComputerName) you may need to run winmgmt /verifyrepository"
			Line 2 "and winmgmt /salvagerepository.  If this is a trusted Forest, you may"
			Line 2 "need to rerun the script with Domain Admin credentials from the trusted Forest."
		}
		ElseIf($HTML)
		{
		}
	}
	Else
	{
		Write-Verbose "$(Get-Date): No results returned for Processor information"
		If($MSWORD -or $PDF)
		{
			WriteWordLine 0 2 "No results returned for Processor information" "" $Null 0 $False $True
		}
		ElseIf($Text)
		{
			Line 2 "No results returned for Processor information"
		}
		ElseIf($HTML)
		{
		}
	}

	#Get Nics
	Write-Verbose "$(Get-Date): `t`t`tNIC information"

	If($MSWord -or $PDF)
	{
		WriteWordLine 0 1 "Network Interface(s)"
	}
	ElseIf($Text)
	{
		Line 1 "Network Interface(s)"
	}
	ElseIf($HTML)
	{
	}

	[bool]$GotNics = $True
	
	Try
	{
		$Results = Get-WmiObject -computername $RemoteComputerName win32_networkadapterconfiguration
	}
	
	Catch
	{
		$Results
	}

	If($? -and $Results -ne $Null)
	{
		$Nics = $Results | Where {$_.ipaddress -ne $Null}
		$Results = $Null

		If($Nics -eq $Null ) 
		{ 
			$GotNics = $False 
		} 
		Else 
		{ 
			$GotNics = !($Nics.__PROPERTY_COUNT -eq 0) 
		} 
	
		If($GotNics)
		{
			ForEach($nic in $nics)
			{
				Try
				{
					$ThisNic = Get-WmiObject -computername $RemoteComputerName win32_networkadapter | Where {$_.index -eq $nic.index}
				}
				
				Catch 
				{
					$ThisNic = $Null
				}
				
				If($? -and $ThisNic -ne $Null)
				{
					OutputNicItem $Nic $ThisNic
				}
				ElseIf(!$?)
				{
					Write-Warning "$(Get-Date): Error retrieving NIC information"
					Write-Verbose "$(Get-Date): Get-WmiObject win32_networkadapterconfiguration failed for $($RemoteComputerName)"
					Write-Warning "Get-WmiObject win32_networkadapterconfiguration failed for $($RemoteComputerName)"
					If($MSWORD -or $PDF)
					{
						WriteWordLine 0 2 "Error retrieving NIC information" "" $Null 0 $False $True
						WriteWordLine 0 2 "Get-WmiObject win32_networkadapterconfiguration failed for $($RemoteComputerName)" "" $Null 0 $False $True
						WriteWordLine 0 2 "On $($RemoteComputerName) you may need to run winmgmt /verifyrepository" "" $Null 0 $False $True
						WriteWordLine 0 2 "and winmgmt /salvagerepository.  If this is a trusted Forest, you may" "" $Null 0 $False $True
						WriteWordLine 0 2 "need to rerun the script with Domain Admin credentials from the trusted Forest." "" $Null 0 $False $True
					}
					ElseIf($Text)
					{
						Line 2 "Error retrieving NIC information"
						Line 2 "Get-WmiObject win32_networkadapterconfiguration failed for $($RemoteComputerName)"
						Line 2 "On $($RemoteComputerName) you may need to run winmgmt /verifyrepository"
						Line 2 "and winmgmt /salvagerepository.  If this is a trusted Forest, you may"
						Line 2 "need to rerun the script with Domain Admin credentials from the trusted Forest."
					}
					ElseIf($HTML)
					{
					}
				}
				Else
				{
					Write-Verbose "$(Get-Date): No results returned for NIC information"
					If($MSWORD -or $PDF)
					{
						WriteWordLine 0 2 "No results returned for NIC information" "" $Null 0 $False $True
					}
					ElseIf($Text)
					{
						Line 2 "No results returned for NIC information"
					}
					ElseIf($HTML)
					{
					}
				}
			}
		}	
	}
	ElseIf(!$?)
	{
		Write-Warning "$(Get-Date): Error retrieving NIC configuration information"
		Write-Verbose "$(Get-Date): Get-WmiObject win32_networkadapterconfiguration failed for $($RemoteComputerName)"
		Write-Warning "Get-WmiObject win32_networkadapterconfiguration failed for $($RemoteComputerName)"
		If($MSWORD -or $PDF)
		{
			WriteWordLine 0 2 "Error retrieving NIC configuration information" "" $Null 0 $False $True
			WriteWordLine 0 2 "Get-WmiObject win32_networkadapterconfiguration failed for $($RemoteComputerName)" "" $Null 0 $False $True
			WriteWordLine 0 2 "On $($RemoteComputerName) you may need to run winmgmt /verifyrepository" "" $Null 0 $False $True
			WriteWordLine 0 2 "and winmgmt /salvagerepository.  If this is a trusted Forest, you may" "" $Null 0 $False $True
			WriteWordLine 0 2 "need to rerun the script with Domain Admin credentials from the trusted Forest." "" $Null 0 $False $True
		}
		ElseIf($Text)
		{
			Line 2 "Error retrieving NIC configuration information"
			Line 2 "Get-WmiObject win32_networkadapterconfiguration failed for $($RemoteComputerName)"
			Line 2 "On $($RemoteComputerName) you may need to run winmgmt /verifyrepository"
			Line 2 "and winmgmt /salvagerepository.  If this is a trusted Forest, you may"
			Line 2 "need to rerun the script with Domain Admin credentials from the trusted Forest."
		}
		ElseIf($HTML)
		{
		}
	}
	Else
	{
		Write-Verbose "$(Get-Date): No results returned for NIC configuration information"
		If($MSWORD -or $PDF)
		{
			WriteWordLine 0 2 "No results returned for NIC configuration information" "" $Null 0 $False $True
		}
		ElseIf($Text)
		{
			Line 2 "No results returned for NIC configuration information"
		}
		ElseIf($HTML)
		{
		}
	}
	
	If($MSWORD -or $PDF)
	{
		WriteWordLine 0 0 ""
	}
	ElseIf($Text)
	{
		Line 0 ""
	}
	ElseIf($HTML)
	{
	}

	$Results = $Null
	$ComputerItems = $Null
	$Drives = $Null
	$Processors = $Null
	$Nics = $Null
}

Function OutputComputerItem
{
	Param([object]$Item)
	If($MSWord -or $PDF)
	{
		[System.Collections.Hashtable[]] $ItemInformation = @()
		$ItemInformation += @{ Data = "Manufacturer"; Value = $Item.manufacturer; }
		$ItemInformation += @{ Data = "Model"; Value = $Item.model; }
		$ItemInformation += @{ Data = "Domain"; Value = $Item.domain; }
		$ItemInformation += @{ Data = "Total Ram"; Value = "$($Item.totalphysicalram) GB"; }
		$Table = AddWordTable -Hashtable $ItemInformation -Columns Data,Value -List -AutoFit $wdAutoFitFixed;

		## Set first column format
		SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		## IB - set column widths without recursion
		$Table.Columns.Item(1).Width = 125;
		$Table.Columns.Item(2).Width = 100;

		$Table.Rows.SetLeftIndent($Indent2TabStops,$wdAdjustNone)

		FindWordDocumentEnd
		$Table = $Null
		WriteWordLine 0 2 ""
		
	}
	ElseIf($Text)
	{
		Line 2 "Manufacturer`t: " $Item.manufacturer
		Line 2 "Model`t`t: " $Item.model
		Line 2 "Domain`t`t: " $Item.domain
		Line 2 "Total Ram`t: $($Item.totalphysicalram) GB"
		Line 2 ""
	}
	ElseIf($HTML)
	{
	}
}

Function OutputDriveItem
{
	Param([object]$Drive)
	If($MSWORD -or $PDF)
	{
		[System.Collections.Hashtable[]] $DriveInformation = @()
		$DriveInformation += @{ Data = "Caption"; Value = $Drive.caption; }
		$DriveInformation += @{ Data = "Size"; Value = "$($drive.drivesize) GB"; }
		If(![String]::IsNullOrEmpty($drive.filesystem))
		{
			$DriveInformation += @{ Data = "File System"; Value = $Drive.filesystem; }
		}
		$DriveInformation += @{ Data = "Free Space"; Value = "$($drive.drivefreespace) GB"; }
		If(![String]::IsNullOrEmpty($drive.volumename))
		{
			$DriveInformation += @{ Data = "Volume Name"; Value = $Drive.volumename; }
		}
		If(![String]::IsNullOrEmpty($drive.volumedirty))
		{
			If($drive.volumedirty)
			{
				$tmp = "Yes"
			}
			Else
			{
				$tmp = "No"
			}
			$DriveInformation += @{ Data = "Volume is Dirty"; Value = $tmp; }
		}
		If(![String]::IsNullOrEmpty($drive.volumeserialnumber))
		{
			$DriveInformation += @{ Data = "Volume Serial Number"; Value = $Drive.volumeserialnumber; }
		}
		Switch ($drive.drivetype)
		{
			0	{$tmp = "Unknown"}
			1	{$tmp = "No Root Directory"}
			2	{$tmp = "Removable Disk"}
			3	{$tmp = "Local Disk"}
			4	{$tmp = "Network Drive"}
			5	{$tmp = "Compact Disc"}
			6	{$tmp = "RAM Disk"}
			Default {$tmp = "Unknown"}
		}
		$DriveInformation += @{ Data = "Drive Type"; Value = $tmp; }
		$Table = AddWordTable -Hashtable $DriveInformation -Columns Data,Value -List -AutoFit $wdAutoFitContent;

		## Set first column format
		SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		## IB - set column widths without recursion
		$Table.Columns.Item(1).Width = 125;
		$Table.Columns.Item(2).Width = 100;

		$Table.Rows.SetLeftIndent($Indent2TabStops,$wdAdjustNone)

		FindWordDocumentEnd
		$Table = $Null
		WriteWordLine 0 2 ""
	}
	ElseIf($Text)
	{
		Line 2 "Caption`t`t: " $drive.caption
		Line 2 "Size`t`t: $($drive.drivesize) GB"
		If(![String]::IsNullOrEmpty($drive.filesystem))
		{
			Line 2 "File System`t: " $drive.filesystem
		}
		Line 2 "Free Space`t: $($drive.drivefreespace) GB"
		If(![String]::IsNullOrEmpty($drive.volumename))
		{
			Line 2 "Volume Name`t: " $drive.volumename
		}
		If(![String]::IsNullOrEmpty($drive.volumedirty))
		{
			Line 2 "Volume is Dirty`t: " -nonewline
			If($drive.volumedirty)
			{
				Line 0 "Yes"
			}
			Else
			{
				Line 0 "No"
			}
		}
		If(![String]::IsNullOrEmpty($drive.volumeserialnumber))
		{
			Line 2 "Volume Serial #`t: " $drive.volumeserialnumber
		}
		Line 2 "Drive Type`t: " -nonewline
		Switch ($drive.drivetype)
		{
			0	{Line 0 "Unknown"}
			1	{Line 0 "No Root Directory"}
			2	{Line 0 "Removable Disk"}
			3	{Line 0 "Local Disk"}
			4	{Line 0 "Network Drive"}
			5	{Line 0 "Compact Disc"}
			6	{Line 0 "RAM Disk"}
			Default {Line 0 "Unknown"}
		}
		Line 2 ""
	}
	ElseIf($HTML)
	{
	}
}

Function OutputProcessorItem
{
	Param([object]$Processor)
	If($MSWORD -or $PDF)
	{
		[System.Collections.Hashtable[]] $ProcessorInformation = @()
		$ProcessorInformation += @{ Data = "Name"; Value = $Processor.name; }
		$ProcessorInformation += @{ Data = "Description"; Value = $Processor.description; }
		$ProcessorInformation += @{ Data = "Max Clock Speed"; Value = "$($processor.maxclockspeed) MHz"; }
		If($processor.l2cachesize -gt 0)
		{
			$ProcessorInformation += @{ Data = "L2 Cache Size"; Value = "$($processor.l2cachesize) KB"; }
		}
		If($processor.l3cachesize -gt 0)
		{
			$ProcessorInformation += @{ Data = "L3 Cache Size"; Value = "$($processor.l3cachesize) KB"; }
		}
		If($processor.numberofcores -gt 0)
		{
			$ProcessorInformation += @{ Data = "Number of Cores"; Value = $Processor.numberofcores; }
		}
		If($processor.numberoflogicalprocessors -gt 0)
		{
			$ProcessorInformation += @{ Data = "Number of Logical Processors"; Value = $Processor.numberoflogicalprocessors; }
		}
		Switch ($processor.availability)
		{
			1	{$tmp = "Other"}
			2	{$tmp = "Unknown"}
			3	{$tmp = "Running or Full Power"}
			4	{$tmp = "Warning"}
			5	{$tmp = "In Test"}
			6	{$tmp = "Not Applicable"}
			7	{$tmp = "Power Off"}
			8	{$tmp = "Off Line"}
			9	{$tmp = "Off Duty"}
			10	{$tmp = "Degraded"}
			11	{$tmp = "Not Installed"}
			12	{$tmp = "Install Error"}
			13	{$tmp = "Power Save - Unknown"}
			14	{$tmp = "Power Save - Low Power Mode"}
			15	{$tmp = "Power Save - Standby"}
			16	{$tmp = "Power Cycle"}
			17	{$tmp = "Power Save - Warning"}
			Default	{$tmp = "Unknown"}
		}
		$ProcessorInformation += @{ Data = "Availability"; Value = $tmp; }
		$Table = AddWordTable -Hashtable $ProcessorInformation -Columns Data,Value -List -AutoFit $wdAutoFitFixed;

		## Set first column format
		SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		## IB - set column widths without recursion
		$Table.Columns.Item(1).Width = 150;
		$Table.Columns.Item(2).Width = 200;

		$Table.Rows.SetLeftIndent($Indent2TabStops,$wdAdjustNone)

		FindWordDocumentEnd
		$Table = $Null
		WriteWordLine 0 2 ""
	}
	ElseIf($Text)
	{
		Line 2 "Name`t`t`t: " $processor.name
		Line 2 "Description`t`t: " $processor.description
		Line 2 "Max Clock Speed`t`t: $($processor.maxclockspeed) MHz"
		If($processor.l2cachesize -gt 0)
		{
			Line 2 "L2 Cache Size`t`t: $($processor.l2cachesize) KB"
		}
		If($processor.l3cachesize -gt 0)
		{
			Line 2 "L3 Cache Size`t`t: $($processor.l3cachesize) KB"
		}
		If($processor.numberofcores -gt 0)
		{
			Line 2 "# of Cores`t`t: " $processor.numberofcores
		}
		If($processor.numberoflogicalprocessors -gt 0)
		{
			Line 2 "# of Logical Procs`t: " $processor.numberoflogicalprocessors
		}
		Line 2 "Availability`t`t: " -nonewline
		Switch ($processor.availability)
		{
			1	{Line 0 "Other"}
			2	{Line 0 "Unknown"}
			3	{Line 0 "Running or Full Power"}
			4	{Line 0 "Warning"}
			5	{Line 0 "In Test"}
			6	{Line 0 "Not Applicable"}
			7	{Line 0 "Power Off"}
			8	{Line 0 "Off Line"}
			9	{Line 0 "Off Duty"}
			10	{Line 0 "Degraded"}
			11	{Line 0 "Not Installed"}
			12	{Line 0 "Install Error"}
			13	{Line 0 "Power Save - Unknown"}
			14	{Line 0 "Power Save - Low Power Mode"}
			15	{Line 0 "Power Save - Standby"}
			16	{Line 0 "Power Cycle"}
			17	{Line 0 "Power Save - Warning"}
			Default	{Line 0 "Unknown"}
		}
		Line 2 ""
	}
	ElseIf($HTML)
	{
	}
}

Function OutputNicItem
{
	Param([object]$Nic, [object]$ThisNic)
	If($MSWORD -or $PDF)
	{
		[System.Collections.Hashtable[]] $NicInformation = @()
		If($ThisNic.Name -eq $nic.description)
		{
			$NicInformation += @{ Data = "Name"; Value = $ThisNic.Name; }
		}
		Else
		{
			$NicInformation += @{ Data = "Name"; Value = $ThisNic.Name; }
			$NicInformation += @{ Data = "Description"; Value = $Nic.description; }
		}
		$NicInformation += @{ Data = "Connection ID"; Value = $ThisNic.NetConnectionID; }
		$NicInformation += @{ Data = "Manufacturer"; Value = $Nic.manufacturer; }
		Switch ($ThisNic.availability)
		{
			1	{$tmp = "Other"}
			2	{$tmp = "Unknown"}
			3	{$tmp = "Running or Full Power"}
			4	{$tmp = "Warning"}
			5	{$tmp = "In Test"}
			6	{$tmp = "Not Applicable"}
			7	{$tmp = "Power Off"}
			8	{$tmp = "Off Line"}
			9	{$tmp = "Off Duty"}
			10	{$tmp = "Degraded"}
			11	{$tmp = "Not Installed"}
			12	{$tmp = "Install Error"}
			13	{$tmp = "Power Save - Unknown"}
			14	{$tmp = "Power Save - Low Power Mode"}
			15	{$tmp = "Power Save - Standby"}
			16	{$tmp = "Power Cycle"}
			17	{$tmp = "Power Save - Warning"}
			Default	{$tmp = "Unknown"}
		}
		$NicInformation += @{ Data = "Availability"; Value = $tmp; }
		$NicInformation += @{ Data = "Physical Address"; Value = $Nic.macaddress; }
		$NicInformation += @{ Data = "IP Address"; Value = $Nic.ipaddress; }
		$NicInformation += @{ Data = "Default Gateway"; Value = $Nic.Defaultipgateway; }
		$NicInformation += @{ Data = "Subnet Mask"; Value = $Nic.ipsubnet; }
		If($nic.dhcpenabled)
		{
			$DHCPLeaseObtainedDate = $nic.ConvertToDateTime($nic.dhcpleaseobtained)
			$DHCPLeaseExpiresDate = $nic.ConvertToDateTime($nic.dhcpleaseexpires)
			$NicInformation += @{ Data = "DHCP Enabled"; Value = $Nic.dhcpenabled; }
			$NicInformation += @{ Data = "DHCP Lease Obtained"; Value = $dhcpleaseobtaineddate; }
			$NicInformation += @{ Data = "DHCP Lease Expires"; Value = $dhcpleaseexpiresdate; }
			$NicInformation += @{ Data = "DHCP Server"; Value = $Nic.dhcpserver; }
		}
		If(![String]::IsNullOrEmpty($nic.dnsdomain))
		{
			$NicInformation += @{ Data = "DNS Domain"; Value = $Nic.dnsdomain; }
		}
		If($nic.dnsdomainsuffixsearchorder -ne $Null -and $nic.dnsdomainsuffixsearchorder.length -gt 0)
		{
			[int]$x = 1
			WriteWordLine 0 2 "DNS Search Suffixes`t:" -nonewline
			$nicdnsdomainsuffixsearchorder = $nic.dnsdomainsuffixsearchorder
			$tmp = @()
			ForEach($DNSDomain in $nicdnsdomainsuffixsearchorder)
			{
				$tmp += "$($DNSDomain)`r"
			}
			$NicInformation += @{ Data = "DNS Search Suffixes"; Value = $tmp; }
		}
		If($nic.dnsenabledforwinsresolution)
		{
			$tmp = "Yes"
		}
		Else
		{
			$tmp = "No"
		}
		$NicInformation += @{ Data = "DNS WINS Enabled"; Value = $tmp; }
		If($nic.dnsserversearchorder -ne $Null -and $nic.dnsserversearchorder.length -gt 0)
		{
			$nicdnsserversearchorder = $nic.dnsserversearchorder
			$tmp = @()
			ForEach($DNSServer in $nicdnsserversearchorder)
			{
				$tmp += "$($DNSServer)`r"
			}
			$NicInformation += @{ Data = "DNS Servers"; Value = $tmp; }
		}
		Switch ($nic.TcpipNetbiosOptions)
		{
			0	{$tmp = "Use NetBIOS setting from DHCP Server"}
			1	{$tmp = "Enable NetBIOS"}
			2	{$tmp = "Disable NetBIOS"}
			Default	{$tmp = "Unknown"}
		}
		$NicInformation += @{ Data = "NetBIOS Setting"; Value = $tmp; }
		If($nic.winsenablelmhostslookup)
		{
			$tmp = "Yes"
		}
		Else
		{
			$tmp = "No"
		}
		$NicInformation += @{ Data = "WINS: Enabled LMHosts"; Value = $tmp; }
		If(![String]::IsNullOrEmpty($nic.winshostlookupfile))
		{
			$NicInformation += @{ Data = "Host Lookup File"; Value = $Nic.winshostlookupfile; }
		}
		If(![String]::IsNullOrEmpty($nic.winsprimaryserver))
		{
			$NicInformation += @{ Data = "Primary Server"; Value = $Nic.winsprimaryserver; }
		}
		If(![String]::IsNullOrEmpty($nic.winssecondaryserver))
		{
			$NicInformation += @{ Data = "Secondary Server"; Value = $Nic.winssecondaryserver; }
		}
		If(![String]::IsNullOrEmpty($nic.winsscopeid))
		{
			$NicInformation += @{ Data = "Scope ID"; Value = $Nic.winsscopeid; }
		}
		$Table = AddWordTable -Hashtable $NicInformation -Columns Data,Value -List -AutoFit $wdAutoFitFixed;

		## Set first column format
		SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		## IB - set column widths without recursion
		$Table.Columns.Item(1).Width = 150;
		$Table.Columns.Item(2).Width = 200;

		$Table.Rows.SetLeftIndent($Indent2TabStops,$wdAdjustNone)

		FindWordDocumentEnd
		$Table = $Null
	}
	ElseIf($Text)
	{
		If($ThisNic.Name -eq $nic.description)
		{
			Line 2 "Name`t`t`t: " $ThisNic.Name
		}
		Else
		{
			Line 2 "Name`t`t`t: " $ThisNic.Name
			Line 2 "Description`t`t: " $nic.description
		}
		Line 2 "Connection ID`t`t: " $ThisNic.NetConnectionID
		Line 2 "Manufacturer`t`t: " $ThisNic.manufacturer
		Line 2 "Availability`t`t: " -nonewline
		Switch ($ThisNic.availability)
		{
			1	{Line 0 "Other"}
			2	{Line 0 "Unknown"}
			3	{Line 0 "Running or Full Power"}
			4	{Line 0 "Warning"}
			5	{Line 0 "In Test"}
			6	{Line 0 "Not Applicable"}
			7	{Line 0 "Power Off"}
			8	{Line 0 "Off Line"}
			9	{Line 0 "Off Duty"}
			10	{Line 0 "Degraded"}
			11	{Line 0 "Not Installed"}
			12	{Line 0 "Install Error"}
			13	{Line 0 "Power Save - Unknown"}
			14	{Line 0 "Power Save - Low Power Mode"}
			15	{Line 0 "Power Save - Standby"}
			16	{Line 0 "Power Cycle"}
			17	{Line 0 "Power Save - Warning"}
			Default	{Line 0 "Unknown"}
		}
		Line 2 "Physical Address`t: " $nic.macaddress
		Line 2 "IP Address`t`t: " $nic.ipaddress
		Line 2 "Default Gateway`t`t: " $nic.Defaultipgateway
		Line 2 "Subnet Mask`t`t: " $nic.ipsubnet
		If($nic.dhcpenabled)
		{
			$DHCPLeaseObtainedDate = $nic.ConvertToDateTime($nic.dhcpleaseobtained)
			$DHCPLeaseExpiresDate = $nic.ConvertToDateTime($nic.dhcpleaseexpires)
			Line 2 "DHCP Enabled`t`t: " $nic.dhcpenabled
			Line 2 "DHCP Lease Obtained`t: " $dhcpleaseobtaineddate
			Line 2 "DHCP Lease Expires`t: " $dhcpleaseexpiresdate
			Line 2 "DHCP Server`t`t:" $nic.dhcpserver
		}
		If(![String]::IsNullOrEmpty($nic.dnsdomain))
		{
			Line 2 "DNS Domain`t`t: " $nic.dnsdomain
		}
		If($nic.dnsdomainsuffixsearchorder -ne $Null -and $nic.dnsdomainsuffixsearchorder.length -gt 0)
		{
			[int]$x = 1
			Line 2 "DNS Search Suffixes`t:" -nonewline
			$nicdnsdomainsuffixsearchorder = $nic.dnsdomainsuffixsearchorder
			ForEach($DNSDomain in $nicdnsdomainsuffixsearchorder)
			{
				If($x -eq 1)
				{
					$x = 2
					Line 0 " $($DNSDomain)"
				}
				Else
				{
					Line 5 " $($DNSDomain)"
				}
			}
		}
		Line 2 "DNS WINS Enabled`t: " -nonewline
		If($nic.dnsenabledforwinsresolution)
		{
			Line 0 "Yes"
		}
		Else
		{
			Line 0 "No"
		}
		If($nic.dnsserversearchorder -ne $Null -and $nic.dnsserversearchorder.length -gt 0)
		{
			[int]$x = 1
			Line 2 "DNS Servers`t`t:" -nonewline
			$nicdnsserversearchorder = $nic.dnsserversearchorder
			ForEach($DNSServer in $nicdnsserversearchorder)
			{
				If($x -eq 1)
				{
					$x = 2
					Line 0 " $($DNSServer)"
				}
				Else
				{
					Line 5 " $($DNSServer)"
				}
			}
		}
		Line 2 "NetBIOS Setting`t`t: " -nonewline
		Switch ($nic.TcpipNetbiosOptions)
		{
			0	{Line 0 "Use NetBIOS setting from DHCP Server"}
			1	{Line 0 "Enable NetBIOS"}
			2	{Line 0 "Disable NetBIOS"}
			Default	{Line 0 "Unknown"}
		}
		Line 2 "WINS:"
		Line 3 "Enabled LMHosts`t: " -nonewline
		If($nic.winsenablelmhostslookup)
		{
			Line 0 "Yes"
		}
		Else
		{
			Line 0 "No"
		}
		If(![String]::IsNullOrEmpty($nic.winshostlookupfile))
		{
			Line 3 "Host Lookup File`t: " $nic.winshostlookupfile
		}
		If(![String]::IsNullOrEmpty($nic.winsprimaryserver))
		{
			Line 3 "Primary Server`t`t: " $nic.winsprimaryserver
		}
		If(![String]::IsNullOrEmpty($nic.winssecondaryserver))
		{
			Line 3 "Secondary Server`t: " $nic.winssecondaryserver
		}
		If(![String]::IsNullOrEmpty($nic.winsscopeid))
		{
			Line 3 "Scope ID`t`t: " $nic.winsscopeid
		}
	}
	ElseIf($HTML)
	{
	}
}

Function SetWordHashTable
{
	Param([string]$CultureCode)

	#optimized by Michael B. SMith
	
	# DE and FR translations for Word 2010 by Vladimir Radojevic
	# Vladimir.Radojevic@Commerzreal.com

	# DA translations for Word 2010 by Thomas Daugaard
	# Citrix Infrastructure Specialist at edgemo A/S

	# CA translations by Javier Sanchez 
	# CEO & Founder 101 Consulting

	#ca - Catalan
	#da - Danish
	#de - German
	#en - English
	#es - Spanish
	#fi - Finnish
	#fr - French
	#nb - Norwegian
	#nl - Dutch
	#pt - Portuguese
	#sv - Swedish

	[string]$toc = $(
		Switch ($CultureCode)
		{
			'ca-'	{ 'Taula automática 2' }

			'da-'	{ 'Automatisk tabel 2' }

			'de-'	{ 'Automatische Tabelle 2' }

			'en-'	{ 'Automatic Table 2' }

			'es-'	{ 'Tabla automática 2' }

			'fi-'	{ 'Automaattinen taulukko 2' }

			'fr-'	{ 'Sommaire Automatique 2' }

			'nb-'	{ 'Automatisk tabell 2' }

			'nl-'	{ 'Automatische inhoudsopgave 2' }

			'pt-'	{ 'Sumário Automático 2' }

			'sv-'	{ 'Automatisk innehållsförteckning2' }
		}
	)

	$Script:myHash                      = @{}
	$Script:myHash.Word_TableOfContents = $toc
	$Script:myHash.Word_NoSpacing       = $wdStyleNoSpacing
	$Script:myHash.Word_Heading1        = $wdStyleheading1
	$Script:myHash.Word_Heading2        = $wdStyleheading2
	$Script:myHash.Word_Heading3        = $wdStyleheading3
	$Script:myHash.Word_Heading4        = $wdStyleheading4
	$Script:myHash.Word_TableGrid       = $wdTableGrid
}

Function GetCulture
{
	Param([int]$WordValue)
	
	#codes obtained from http://support.microsoft.com/kb/221435
	#http://msdn.microsoft.com/en-us/library/bb213877(v=office.12).aspx
	$CatalanArray = 1027
	$DanishArray = 1030
	$DutchArray = 2067, 1043
	$EnglishArray = 3081, 10249, 4105, 9225, 6153, 8201, 5129, 13321, 7177, 11273, 2057, 1033, 12297
	$FinnishArray = 1035
	$FrenchArray = 2060, 1036, 11276, 3084, 12300, 5132, 13324, 6156, 8204, 10252, 7180, 9228, 4108
	$GermanArray = 1031, 3079, 5127, 4103, 2055
	$NorwegianArray = 1044, 2068
	$PortugueseArray = 1046, 2070
	$SpanishArray = 1034, 11274, 16394, 13322, 9226, 5130, 7178, 12298, 17418, 4106, 18442, 19466, 6154, 15370, 10250, 20490, 3082, 14346, 8202
	$SwedishArray = 1053, 2077

	#ca - Catalan
	#da - Danish
	#de - German
	#en - English
	#es - Spanish
	#fi - Finnish
	#fr - French
	#nb - Norwegian
	#nl - Dutch
	#pt - Portuguese
	#sv - Swedish

	Switch ($WordValue)
	{
		{$CatalanArray -contains $_} {$CultureCode = "ca-"}
		{$DanishArray -contains $_} {$CultureCode = "da-"}
		{$DutchArray -contains $_} {$CultureCode = "nl-"}
		{$EnglishArray -contains $_} {$CultureCode = "en-"}
		{$FinnishArray -contains $_} {$CultureCode = "fi-"}
		{$FrenchArray -contains $_} {$CultureCode = "fr-"}
		{$GermanArray -contains $_} {$CultureCode = "de-"}
		{$NorwegianArray -contains $_} {$CultureCode = "nb-"}
		{$PortugueseArray -contains $_} {$CultureCode = "pt-"}
		{$SpanishArray -contains $_} {$CultureCode = "es-"}
		{$SwedishArray -contains $_} {$CultureCode = "sv-"}
		Default {$CultureCode = "en-"}
	}
	
	Return $CultureCode
}

Function ValidateCoverPage
{
	Param([int]$xWordVersion, [string]$xCP, [string]$CultureCode)
	
	$xArray = ""
	
	Switch ($CultureCode)
	{
		'ca-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Austin", "En bandes", "Faceta", "Filigrana",
					"Integral", "Ió (clar)", "Ió (fosc)", "Línia lateral",
					"Moviment", "Quadrícula", "Retrospectiu", "Sector (clar)",
					"Sector (fosc)", "Semàfor", "Visualització", "Whisp")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alfabet", "Anual", "Austin", "Conservador",
					"Contrast", "Cubicles", "Diplomàtic", "Exposició",
					"Línia lateral", "Mod", "Mosiac", "Moviment", "Paper de diari",
					"Perspectiva", "Piles", "Quadrícula", "Sobri",
					"Transcendir", "Trencaclosques")
				}
			}

		'da-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("BevægElse", "Brusen", "Ion (lys)", "Filigran",
					"Retro", "Semafor", "Visningsmaster", "Integral",
					"Facet", "Gitter", "Stribet", "Sidelinje", "Udsnit (lys)",
					"Udsnit (mørk)", "Ion (mørk)", "Austin")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("BevægElse", "Moderat", "Perspektiv", "Firkanter",
					"Overskrid", "Alfabet", "Kontrast", "Stakke", "Fliser", "Gåde",
					"Gitter", "Austin", "Eksponering", "Sidelinje", "Enkel",
					"Nålestribet", "Årlig", "Avispapir", "Tradionel")
				}
			}

		'de-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Semaphor", "Segment (hell)", "Ion (hell)",
					"Raster", "Ion (dunkel)", "Filigran", "Rückblick", "Pfiff",
					"ViewMaster", "Segment (dunkel)", "Verbunden", "Bewegung",
					"Randlinie", "Austin", "Integral", "Facette")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alphabet", "Austin", "Bewegung", "Durchscheinend",
					"Herausgestellt", "Jährlich", "Kacheln", "Kontrast", "Kubistisch",
					"Modern", "Nadelstreifen", "Perspektive", "Puzzle", "Randlinie",
					"Raster", "Schlicht", "Stapel", "Traditionell", "Zeitungspapier")
				}
			}

		'en-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Austin", "Banded", "Facet", "Filigree", "Grid",
					"Integral", "Ion (Dark)", "Ion (Light)", "Motion", "Retrospect",
					"Semaphore", "Sideline", "Slice (Dark)", "Slice (Light)", "ViewMaster",
					"Whisp")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alphabet", "Annual", "Austere", "Austin", "Conservative",
					"Contrast", "Cubicles", "Exposure", "Grid", "Mod", "Motion", "Newsprint",
					"Perspective", "Pinstripes", "Puzzle", "Sideline", "Stacks", "Tiles", "Transcend")
				}
			}

		'es-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Whisp", "Vista principal", "Filigrana", "Austin",
					"Slice (luz)", "Faceta", "Semáforo", "Retrospectiva", "Cuadrícula",
					"Movimiento", "Cortar (oscuro)", "Línea lateral", "Ion (oscuro)",
					"Ion (claro)", "Integral", "Con bandas")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alfabeto", "Anual", "Austero", "Austin", "Conservador",
					"Contraste", "Cuadrícula", "Cubículos", "Exposición", "Línea lateral",
					"Moderno", "Mosaicos", "Movimiento", "Papel periódico",
					"Perspectiva", "Pilas", "Puzzle", "Rayas", "Sobrepasar")
				}
			}

		'fi-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Filigraani", "Integraali", "Ioni (tumma)",
					"Ioni (vaalea)", "Opastin", "Pinta", "Retro", "Sektori (tumma)",
					"Sektori (vaalea)", "Vaihtuvavärinen", "ViewMaster", "Austin",
					"Kiehkura", "Liike", "Ruudukko", "Sivussa")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Aakkoset", "Askeettinen", "Austin", "Kontrasti",
					"Laatikot", "Liike", "Liituraita", "Mod", "Osittain peitossa",
					"Palapeli", "Perinteinen", "Perspektiivi", "Pinot", "Ruudukko",
					"Ruudut", "Sanomalehtipaperi", "Sivussa", "Vuotuinen", "Ylitys")
				}
			}

		'fr-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("ViewMaster", "Secteur (foncé)", "Sémaphore",
					"Rétrospective", "Ion (foncé)", "Ion (clair)", "Intégrale",
					"Filigrane", "Facette", "Secteur (clair)", "À bandes", "Austin",
					"Guide", "Whisp", "Lignes latérales", "Quadrillage")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Mosaïques", "Ligne latérale", "Annuel", "Perspective",
					"Contraste", "Emplacements de bureau", "Moderne", "Blocs empilés",
					"Rayures fines", "Austère", "Transcendant", "Classique", "Quadrillage",
					"Exposition", "Alphabet", "Mots croisés", "Papier journal", "Austin", "Guide")
				}
			}

		'nb-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Austin", "BevegElse", "Dempet", "Fasett", "Filigran",
					"Integral", "Ion (lys)", "Ion (mørk)", "Retrospekt", "Rutenett",
					"Sektor (lys)", "Sektor (mørk)", "Semafor", "Sidelinje", "Stripet",
					"ViewMaster")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alfabet", "Årlig", "Avistrykk", "Austin", "Avlukker",
					"BevegElse", "Engasjement", "Enkel", "Fliser", "Konservativ",
					"Kontrast", "Mod", "Perspektiv", "Puslespill", "Rutenett", "Sidelinje",
					"Smale striper", "Stabler", "Transcenderende")
				}
			}

		'nl-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Austin", "Beweging", "Facet", "Filigraan", "Gestreept",
					"Integraal", "Ion (donker)", "Ion (licht)", "Raster",
					"Segment (Light)", "Semafoor", "Slice (donker)", "Spriet",
					"Terugblik", "Terzijde", "ViewMaster")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Aantrekkelijk", "Alfabet", "Austin", "Bescheiden",
					"Beweging", "Blikvanger", "Contrast", "Eenvoudig", "Jaarlijks",
					"Krantenpapier", "Krijtstreep", "Kubussen", "Mod", "Perspectief",
					"Puzzel", "Raster", "Stapels",
					"Tegels", "Terzijde")
				}
			}

		'pt-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Animação", "Austin", "Em Tiras", "Exibição Mestra",
					"Faceta", "Fatia (Clara)", "Fatia (Escura)", "Filete", "Filigrana",
					"Grade", "Integral", "Íon (Claro)", "Íon (Escuro)", "Linha Lateral",
					"Retrospectiva", "Semáforo")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alfabeto", "Animação", "Anual", "Austero", "Austin", "Baias",
					"Conservador", "Contraste", "Exposição", "Grade", "Ladrilhos",
					"Linha Lateral", "Listras", "Mod", "Papel Jornal", "Perspectiva", "Pilhas",
					"Quebra-cabeça", "Transcend")
				}
			}

		'sv-'	{
				If($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Austin", "Band", "Fasett", "Filigran", "Integrerad", "Jon (ljust)",
					"Jon (mörkt)", "Knippe", "Rutnät", "RörElse", "Sektor (ljus)", "Sektor (mörk)",
					"Semafor", "Sidlinje", "VisaHuvudsida", "Återblick")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alfabetmönster", "Austin", "Enkelt", "Exponering", "Konservativt",
					"Kontrast", "Kritstreck", "Kuber", "Perspektiv", "Plattor", "Pussel", "Rutnät",
					"RörElse", "Sidlinje", "Sobert", "Staplat", "Tidningspapper", "Årligt",
					"Övergående")
				}
			}

		Default	{
					If($xWordVersion -eq $wdWord2013)
					{
						$xArray = ("Austin", "Banded", "Facet", "Filigree", "Grid", "Integral",
						"Ion (Dark)", "Ion (Light)", "Motion", "Retrospect", "Semaphore",
						"Sideline", "Slice (Dark)", "Slice (Light)", "ViewMaster", "Whisp")
					}
					ElseIf($xWordVersion -eq $wdWord2010)
					{
						$xArray = ("Alphabet", "Annual", "Austere", "Austin", "Conservative",
						"Contrast", "Cubicles", "Exposure", "Grid", "Mod", "Motion", "Newsprint",
						"Perspective", "Pinstripes", "Puzzle", "Sideline", "Stacks", "Tiles", "Transcend")
					}
				}
	}
	
	If($xArray -contains $xCP)
	{
		$xArray = $Null
		Return $True
	}
	Else
	{
		$xArray = $Null
		Return $False
	}
}

Function GetComputerServices 
{
	Param([string]$RemoteComputerName)
	
	#Get Computer services info
	Write-Verbose "$(Get-Date): `t`tProcessing Computer services information"
	WriteWordLine 3 0 "Services"

	Try
	{
		#Iain Brighton optimization 5-Jun-2014
		#Replaced with a single call to retrieve services via WMI. The repeated
		## "Get-WMIObject Win32_Service -Filter" calls were the major delays in the script.
		## If we need to retrieve the StartUp type might as well just use WMI.
		$Services = Get-WMIObject Win32_Service -ComputerName $RemoteComputerName | Sort DisplayName
	}
	
	Catch
	{
		$Services = $Null
	}
	
	If($? -and $Services -ne $Null)
	{
		If($Services -is [array])
		{
			[int]$NumServices = $Services.count
		}
		Else
		{
			[int]$NumServices = 1
		}
		Write-Verbose "$(Get-Date): `t`t$($NumServices) Services found"

		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "Services ($NumServices Services found)"

			## IB - replacement Services table generation utilising AddWordTable function

			## Create an array of hashtables to store our services
			[System.Collections.Hashtable[]] $ServicesWordTable = @();
			## Create an array of hashtables to store references of cells that we wish to highlight after the table has been added
			[System.Collections.Hashtable[]] $HighlightedCells = @();
			## Seed the $Services row index from the second row
			[int] $CurrentServiceIndex = 2;
		}
		ElseIf($Text)
		{
		}
		ElseIf($HTML)
		{
		}

		ForEach($Service in $Services) 
		{
			#Write-Verbose "$(Get-Date): `t`t`t Processing service $($Service.DisplayName)";

			If($MSWord -or $PDF)
			{

				## Add the required key/values to the hashtable
				$WordTableRowHash = @{ DisplayName = $Service.DisplayName; Status = $Service.State; StartMode = $Service.StartMode; }

				## Add the hash to the array
				$ServicesWordTable += $WordTableRowHash;

				## Store "to highlight" cell references
				If($Service.State -like "Stopped" -and $Service.StartMode -like "Auto") 
				{
					$HighlightedCells += @{ Row = $CurrentServiceIndex; Column = 2; }
				}
				$CurrentServiceIndex++;
			}
			ElseIf($Text)
			{
				Line 0 "Display Name`t: " $Service.DisplayName
				Line 0 "Status`t`t: " $Service.State
				Line 0 "Start Mode`t: " $Service.StartMode
				Line 0 ""
			}
			ElseIf($HTML)
			{
			}
		}

		If($MSWord -or $PDF)
		{
			## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
			$Table = AddWordTable -Hashtable $ServicesWordTable `
			-Columns DisplayName, Status, StartMode `
			-Headers "Display Name", "Status", "Startup Type" `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format after the SetWordTableAlternateRowColor function as it will paint the header row!
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;
			## IB - Set the required highlighted cells
			SetWordCellFormat -Coordinates $HighlightedCells -Table $Table -Bold -BackgroundColor $wdColorRed -Solid;

			#indent the entire table 1 tab stop
			$Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null
		}
		ElseIf($Text)
		{
		}
		ElseIf($HTML)
		{
		}
	}
	ElseIf(!$?)
	{
		Write-Warning "No services were retrieved."
		WriteWordLine 0 0 "Warning: No Services were retrieved" "" $Null 0 $False $True
		WriteWordLine 0 1 "If this is a trusted Forest, you may need to rerun the" "" $Null 0 $False $True
		WriteWordLine 0 1 "script with Domain Admin credentials from the trusted Forest." "" $Null 0 $False $True
	}
	Else
	{
		Write-Warning "Services retrieval was successful but no services were returned."
		WriteWordLine 0 0 "Services retrieval was successful but no services were returned." "" $Null 0 $False $True
	}
	$Services = $Null
}

Function CheckWordPrereq
{
	If((Test-Path  REGISTRY::HKEY_CLASSES_ROOT\Word.Application) -eq $False)
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Host "`n`n`t`tThis script directly outputs to Microsoft Word, please install Microsoft Word`n`n"
		Exit
	}

	#find out our session (usually "1" except on TS/RDC or Citrix)
	$SessionID = (Get-Process -PID $PID).SessionId
	
	#Find out if winword is running in our session
	[bool]$wordrunning = ((Get-Process 'WinWord' -ea 0)|?{$_.SessionId -eq $SessionID}) -ne $Null
	If($wordrunning)
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Host "`n`n`tPlease close all instances of Microsoft Word before running this report.`n`n"
		Exit
	}
}

Function ValidateCompanyName
{
	[bool]$xResult = Test-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "CompanyName"
	If($xResult)
	{
		Return Get-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "CompanyName"
	}
	Else
	{
		$xResult = Test-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "Company"
		If($xResult)
		{
			Return Get-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "Company"
		}
		Else
		{
			Return ""
		}
	}
}

#http://stackoverflow.com/questions/5648931/test-if-registry-value-exists
# This Function just gets $True or $False
Function Test-RegistryValue($path, $name)
{
	$key = Get-Item -LiteralPath $path -EA 0
	$key -and $Null -ne $key.GetValue($name, $Null)
}

# Gets the specified registry value or $Null if it is missing
Function Get-RegistryValue($path, $name)
{
	$key = Get-Item -LiteralPath $path -EA 0
	If($key)
	{
		$key.GetValue($name, $Null)
	}
	Else
	{
		$Null
	}
}
	
Function line
#function created by Michael B. Smith, Exchange MVP
#@essentialexchange on Twitter
#http://TheEssentialExchange.com
#for creating the formatted text report
#created March 2011
#updated March 2014
{
	Param( [int]$tabs = 0, [string]$name = '', [string]$value = '', [string]$newline = "`r`n", [switch]$nonewline )
	While( $tabs -gt 0 ) { $Global:Output += "`t"; $tabs--; }
	If( $nonewline )
	{
		$Global:Output += $name + $value
	}
	Else
	{
		$Global:Output += $name + $value + $newline
	}
}

Function WriteWordLine
#Function created by Ryan Revord
#@rsrevord on Twitter
#Function created to make output to Word easy in this script
#updated 27-Mar-2014 to include font name, font size, italics and bold options
{
	Param([int]$style=0, 
	[int]$tabs = 0, 
	[string]$name = '', 
	[string]$value = '', 
	[string]$fontName=$Null,
	[int]$fontSize=0,
	[bool]$italics=$False,
	[bool]$boldface=$False,
	[Switch]$nonewline)
	
	#Build output style
	[string]$output = ""
	Switch ($style)
	{
		0 {$Selection.Style = $Script:MyHash.Word_NoSpacing}
		1 {$Selection.Style = $Script:MyHash.Word_Heading1}
		2 {$Selection.Style = $Script:MyHash.Word_Heading2}
		3 {$Selection.Style = $Script:MyHash.Word_Heading3}
		4 {$Selection.Style = $Script:MyHash.Word_Heading4}
		Default {$Selection.Style = $Script:MyHash.Word_NoSpacing}
	}
	
	#build # of tabs
	While($tabs -gt 0)
	{ 
		$output += "`t"; $tabs--; 
	}
 
	If(![String]::IsNullOrEmpty($fontName)) 
	{
		$Selection.Font.name = $fontName
	} 

	If($fontSize -ne 0) 
	{
		$Selection.Font.size = $fontSize
	} 
 
	If($italics -eq $True) 
	{
		$Selection.Font.Italic = $True
	} 
 
	If($boldface -eq $True) 
	{
		$Selection.Font.Bold = $True
	} 

	#output the rest of the parameters.
	$output += $name + $value
	$Selection.TypeText($output)
 
	#test for new WriteWordLine 0.
	If($nonewline)
	{
		# Do nothing.
	} 
	Else 
	{
		$Selection.TypeParagraph()
	}
}

Function _SetDocumentProperty 
{
	#jeff hicks
	Param([object]$Properties,[string]$Name,[string]$Value)
	#get the property object
	$prop = $properties | ForEach { 
		$propname=$_.GetType().InvokeMember("Name","GetProperty",$Null,$_,$Null)
		If($propname -eq $Name) 
		{
			Return $_
		}
	} #ForEach

	#set the value
	$Prop.GetType().InvokeMember("Value","SetProperty",$Null,$prop,$Value)
}

Function AbortScript
{
	$Script:Word.quit()
	Write-Verbose "$(Get-Date): System Cleanup"
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Script:Word) | Out-Null
	If(Test-Path variable:global:word)
	{
		Remove-Variable -Name word -Scope Global
	}
	[gc]::collect() 
	[gc]::WaitForPendingFinalizers()
	Write-Verbose "$(Get-Date): Script has been aborted"
	$ErrorActionPreference = $SaveEAPreference
	Exit
}

Function FindWordDocumentEnd
{
	#return focus to main document    
	$Script:Doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument
	#move to the end of the current document
	$Script:Selection.EndKey($wdStory,$wdMove) | Out-Null
}

<#
.Synopsis
	Add a table to a Microsoft Word document
.DESCRIPTION
	This function adds a table to a Microsoft Word document from either an array of
	Hashtables or an array of PSCustomObjects.

	Using this function is quicker than setting each table cell individually but can
	only utilise the built-in MS Word table autoformats. Individual tables cells can
	be altered after the table has been appended to the document (a table reference
	is returned).
.EXAMPLE
	AddWordTable -Hashtable $HashtableArray

	This example adds table to the MS Word document, utilising all key/value pairs in
	the array of hashtables. Column headers will display the key names as defined.
	Note: the columns might not be displayed in the order that they were defined. To
	ensure columns are displayed in the required order utilise the -Columns parameter.
.EXAMPLE
	AddWordTable -Hashtable $HashtableArray -List

	This example adds table to the MS Word document, utilising all key/value pairs in
	the array of hashtables. No column headers will be added, in a ListView format.
	Note: the columns might not be displayed in the order that they were defined. To
	ensure columns are displayed in the required order utilise the -Columns parameter.
.EXAMPLE
	AddWordTable -CustomObject $PSCustomObjectArray

	This example adds table to the MS Word document, utilising all note property names
	the array of PSCustomObjects. Column headers will display the note property names.
	Note: the columns might not be displayed in the order that they were defined. To
	ensure columns are displayed in the required order utilise the -Columns parameter.
.EXAMPLE
	AddWordTable -Hashtable $HashtableArray -Columns FirstName,LastName,EmailAddress

	This example adds a table to the MS Word document, but only using the specified
	key names: FirstName, LastName and EmailAddress. If other keys are present in the
	array of Hashtables they will be ignored.
.EXAMPLE
	AddWordTable -CustomObject $PSCustomObjectArray -Columns FirstName,LastName,EmailAddress -Headers "First Name","Last Name","Email Address"

	This example adds a table to the MS Word document, but only using the specified
	PSCustomObject note properties: FirstName, LastName and EmailAddress. If other note
	properties are present in the array of PSCustomObjects they will be ignored. The
	display names for each specified column header has been overridden to display a
	custom header. Note: the order of the header names must match the specified columns.
#>
Function AddWordTable
{
	[CmdletBinding()]
	Param
	(
		# Array of Hashtable (including table headers)
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='Hashtable', Position=0)]
		[ValidateNotNullOrEmpty()] [System.Collections.Hashtable[]] $Hashtable,
		# Array of PSCustomObjects
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='CustomObject', Position=0)]
		[ValidateNotNullOrEmpty()] [PSCustomObject[]] $CustomObject,
		# Array of Hashtable key names or PSCustomObject property names to include, in display order.
		# If not supplied then all Hashtable keys or all PSCustomObject properties will be displayed.
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [string[]] $Columns = $null,
		# Array of custom table header strings in display order.
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [string[]] $Headers = $null,
		# AutoFit table behavior.
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [int] $AutoFit = -1,
		# List view (no headers)
		[Switch] $List,
		# Grid lines
		[Switch] $NoGridLines,
		# Built-in Word table formatting style constant
		# Would recommend only $wdTableFormatContempory for normal usage (possibly $wdTableFormatList5 for List view)
		[Parameter(ValueFromPipelineByPropertyName=$true)] [int] $Format = 0
	)

	Begin 
	{
		Write-Debug ("Using parameter set '{0}'" -f $PSCmdlet.ParameterSetName);
		## Check if -Columns wasn't specified but -Headers were (saves some additional parameter sets!)
		If(($Columns -eq $null) -and ($Headers -ne $null)) 
		{
			Write-Warning "No columns specified and therefore, specified headers will be ignored.";
			$Columns = $null;
		}
		ElseIf(($Columns -ne $null) -and ($Headers -ne $null)) 
		{
			## Check if number of specified -Columns matches number of specified -Headers
			If($Columns.Length -ne $Headers.Length) 
			{
				Write-Error "The specified number of columns does not match the specified number of headers.";
			}
		} ## end elseif
	} ## end Begin

	Process
	{
		## Build the Word table data string to be converted to a range and then a table later.
        [System.Text.StringBuilder] $WordRangeString = New-Object System.Text.StringBuilder;

		Switch ($PSCmdlet.ParameterSetName) 
		{
			'CustomObject' 
			{
				If($Columns -eq $null) 
				{
					## Build the available columns from all availble PSCustomObject note properties
					[string[]] $Columns = @();
					## Add each NoteProperty name to the array
					ForEach($Property in ($CustomObject | Get-Member -MemberType NoteProperty)) 
					{ 
						$Columns += $Property.Name; 
					}
				}

				## Add the table headers from -Headers or -Columns (except when in -List(view)
				If(-not $List) 
				{
					Write-Debug ("$(Get-Date): `t`tBuilding table headers");
					If($Headers -ne $null) 
					{
                        [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Headers));
					}
					Else 
					{ 
                        [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Columns));
					}
				}

				## Iterate through each PSCustomObject
				Write-Debug ("$(Get-Date): `t`tBuilding table rows");
				ForEach($Object in $CustomObject) 
				{
					$OrderedValues = @();
					## Add each row item in the specified order
					ForEach($Column in $Columns) 
					{ 
						$OrderedValues += $Object.$Column; 
					}
					## Use the ordered list to add each column in specified order
                    [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $OrderedValues));
				} ## end foreach
				Write-Debug ("$(Get-Date): `t`t`tAdded '{0}' table rows" -f ($CustomObject.Count));
			} ## end CustomObject

			Default 
			{   ## Hashtable
				If($Columns -eq $null) 
				{
					## Build the available columns from all available hashtable keys. Hopefully
					## all Hashtables have the same keys (they should for a table).
					$Columns = $Hashtable[0].Keys;
				}

				## Add the table headers from -Headers or -Columns (except when in -List(view)
				If(-not $List) 
				{
					Write-Debug ("$(Get-Date): `t`tBuilding table headers");
					If($Headers -ne $null) 
					{ 
                        [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Headers));
					}
					Else 
					{
                        [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Columns));
					}
				}
                
				## Iterate through each Hashtable
				Write-Debug ("$(Get-Date): `t`tBuilding table rows");
				ForEach($Hash in $Hashtable) 
				{
					$OrderedValues = @();
					## Add each row item in the specified order
					ForEach($Column in $Columns) 
					{ 
						$OrderedValues += $Hash.$Column; 
					}
					## Use the ordered list to add each column in specified order
                    [ref] $null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $OrderedValues));
				} ## end foreach

				Write-Debug ("$(Get-Date): `t`t`tAdded '{0}' table rows" -f $Hashtable.Count);
			} ## end default
		} ## end switch

		## Create a MS Word range and set its text to our tab-delimited, concatenated string
		Write-Debug ("$(Get-Date): `t`tBuilding table range");
		$WordRange = $Script:Doc.Application.Selection.Range;
		$WordRange.Text = $WordRangeString.ToString();

		## Create hash table of named arguments to pass to the ConvertToTable method
		$ConvertToTableArguments = @{ Separator = [Microsoft.Office.Interop.Word.WdTableFieldSeparator]::wdSeparateByTabs; }

		## Negative built-in styles are not supported by the ConvertToTable method
		If($Format -ge 0) 
		{
			$ConvertToTableArguments.Add("Format", $Format);
			$ConvertToTableArguments.Add("ApplyBorders", $true);
			$ConvertToTableArguments.Add("ApplyShading", $true);
			$ConvertToTableArguments.Add("ApplyFont", $true);
			$ConvertToTableArguments.Add("ApplyColor", $true);
			If(!$List) 
			{ 
				$ConvertToTableArguments.Add("ApplyHeadingRows", $true); 
			}
			$ConvertToTableArguments.Add("ApplyLastRow", $true);
			$ConvertToTableArguments.Add("ApplyFirstColumn", $true);
			$ConvertToTableArguments.Add("ApplyLastColumn", $true);
		}

		## Invoke ConvertToTable method - with named arguments - to convert Word range to a table
		## See http://msdn.microsoft.com/en-us/library/office/aa171893(v=office.11).aspx
		Write-Debug ("$(Get-Date): `t`tConverting range to table");
		## Store the table reference just in case we need to set alternate row coloring
		$WordTable = $WordRange.GetType().InvokeMember(
			"ConvertToTable",                               # Method name
			[System.Reflection.BindingFlags]::InvokeMethod, # Flags
			$null,                                          # Binder
			$WordRange,                                     # Target (self!)
			([Object[]]($ConvertToTableArguments.Values)),  ## Named argument values
			$null,                                          # Modifiers
			$null,                                          # Culture
			([String[]]($ConvertToTableArguments.Keys))     ## Named argument names
		);

		## Implement grid lines (will wipe out any existing formatting
		If($Format -lt 0) 
		{
			Write-Debug ("$(Get-Date): `t`tSetting table format");
			$WordTable.Style = $Format;
		}

		## Set the table autofit behavior
		If($AutoFit -ne -1) 
		{ 
			$WordTable.AutoFitBehavior($AutoFit); 
		}

		#the next line causes the heading row to flow across page breaks
		$WordTable.Rows.First.Headingformat = $wdHeadingFormatTrue;

		If(!$NoGridLines) 
		{
			$WordTable.Borders.InsideLineStyle = $wdLineStyleSingle;
			$WordTable.Borders.OutsideLineStyle = $wdLineStyleSingle;
		}

		Return $WordTable;

	} ## end Process
}

<#
.Synopsis
	Sets the format of one or more Word table cells
.DESCRIPTION
	This function sets the format of one or more table cells, either from a collection
	of Word COM object cell references, an individual Word COM object cell reference or
	a hashtable containing Row and Column information.

	The font name, font size, bold, italic , underline and shading values can be used.
.EXAMPLE
	SetWordCellFormat -Hashtable $Coordinates -Table $TableReference -Bold

	This example sets all text to bold that is contained within the $TableReference
	Word table, using an array of hashtables. Each hashtable contain a pair of co-
	ordinates that is used to select the required cells. Note: the hashtable must
	contain the .Row and .Column key names. For example:
	@ { Row = 7; Column = 3 } to set the cell at row 7 and column 3 to bold.
.EXAMPLE
	$RowCollection = $Table.Rows.First.Cells
	SetWordCellFormat -Collection $RowCollection -Bold -Size 10

	This example sets all text to size 8 and bold for all cells that are contained
	within the first row of the table.
	Note: the $Table.Rows.First.Cells returns a collection of Word COM cells objects
	that are in the first table row.
.EXAMPLE
	$ColumnCollection = $Table.Columns.Item(2).Cells
	SetWordCellFormat -Collection $ColumnCollection -BackgroundColor 255

	This example sets the background (shading) of all cells in the table's second
	column to red.
	Note: the $Table.Columns.Item(2).Cells returns a collection of Word COM cells objects
	that are in the table's second column.
.EXAMPLE
	SetWordCellFormat -Cell $Table.Cell(17,3) -Font "Tahoma" -Color 16711680

	This example sets the font to Tahoma and the text color to blue for the cell located
	in the table's 17th row and 3rd column.
	Note: the $Table.Cell(17,3) returns a single Word COM cells object.
#>
Function SetWordCellFormat 
{
	[CmdletBinding(DefaultParameterSetName='Collection')]
	Param (
		# Word COM object cell collection reference
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, ParameterSetName='Collection', Position=0)] [ValidateNotNullOrEmpty()] $Collection,
		# Word COM object individual cell reference
		[Parameter(Mandatory=$true, ParameterSetName='Cell', Position=0)] [ValidateNotNullOrEmpty()] $Cell,
		# Hashtable of cell co-ordinates
		[Parameter(Mandatory=$true, ParameterSetName='Hashtable', Position=0)] [ValidateNotNullOrEmpty()] [System.Collections.Hashtable[]] $Coordinates,
		# Word COM object table reference
		[Parameter(Mandatory=$true, ParameterSetName='Hashtable', Position=1)] [ValidateNotNullOrEmpty()] $Table,
		# Font name
		[Parameter()] [AllowNull()] [string] $Font = $null,
		# Font color
		[Parameter()] [AllowNull()] $Color = $null,
		# Font size
		[Parameter()] [ValidateNotNullOrEmpty()] [int] $Size = 0,
		# Cell background color
		[Parameter()] [AllowNull()] $BackgroundColor = $null,
		# Force solid background color
		[Switch] $Solid,
		[Switch] $Bold,
		[Switch] $Italic,
		[Switch] $Underline
	)

	Begin 
	{
		Write-Debug ("Using parameter set '{0}'." -f $PSCmdlet.ParameterSetName);
	}

	Process 
	{
		Switch ($PSCmdlet.ParameterSetName) 
		{
			'Collection' {
				ForEach($Cell in $Collection) 
				{
					If($BackgroundColor -ne $null) { $Cell.Shading.BackgroundPatternColor = $BackgroundColor; }
					If($Bold) { $Cell.Range.Font.Bold = $true; }
					If($Italic) { $Cell.Range.Font.Italic = $true; }
					If($Underline) { $Cell.Range.Font.Underline = 1; }
					If($Font -ne $null) { $Cell.Range.Font.Name = $Font; }
					If($Color -ne $null) { $Cell.Range.Font.Color = $Color; }
					If($Size -ne 0) { $Cell.Range.Font.Size = $Size; }
					If($Solid) { $Cell.Shading.Texture = 0; } ## wdTextureNone
				} # end foreach
			} # end Collection
			'Cell' 
			{
				If($Bold) { $Cell.Range.Font.Bold = $true; }
				If($Italic) { $Cell.Range.Font.Italic = $true; }
				If($Underline) { $Cell.Range.Font.Underline = 1; }
				If($Font -ne $null) { $Cell.Range.Font.Name = $Font; }
				If($Color -ne $null) { $Cell.Range.Font.Color = $Color; }
				If($Size -ne 0) { $Cell.Range.Font.Size = $Size; }
				If($BackgroundColor -ne $null) { $Cell.Shading.BackgroundPatternColor = $BackgroundColor; }
				If($Solid) { $Cell.Shading.Texture = 0; } ## wdTextureNone
			} # end Cell
			'Hashtable' 
			{
				ForEach($Coordinate in $Coordinates) 
				{
					$Cell = $Table.Cell($Coordinate.Row, $Coordinate.Column);
					If($Bold) { $Cell.Range.Font.Bold = $true; }
					If($Italic) { $Cell.Range.Font.Italic = $true; }
					If($Underline) { $Cell.Range.Font.Underline = 1; }
					If($Font -ne $null) { $Cell.Range.Font.Name = $Font; }
					If($Color -ne $null) { $Cell.Range.Font.Color = $Color; }
					If($Size -ne 0) { $Cell.Range.Font.Size = $Size; }
					If($BackgroundColor -ne $null) { $Cell.Shading.BackgroundPatternColor = $BackgroundColor; }
					If($Solid) { $Cell.Shading.Texture = 0; } ## wdTextureNone
				}
			} # end Hashtable
		} # end switch
	} # end process
}

<#
.Synopsis
	Sets alternate row colors in a Word table
.DESCRIPTION
	This function sets the format of alternate rows within a Word table using the
	specified $BackgroundColor. This function is expensive (in performance terms) as
	it recursively sets the format on alternate rows. It would be better to pick one
	of the predefined table formats (if one exists)? Obviously the more rows, the
	longer it takes :'(

	Note: this function is called by the AddWordTable function if an alternate row
	format is specified.
.EXAMPLE
	SetWordTableAlternateRowColor -Table $TableReference -BackgroundColor 255

	This example sets every-other table (starting with the first) row and sets the
	background color to red (wdColorRed).
.EXAMPLE
	SetWordTableAlternateRowColor -Table $TableReference -BackgroundColor 39423 -Seed Second

	This example sets every other table (starting with the second) row and sets the
	background color to light orange (weColorLightOrange).
#>
Function SetWordTableAlternateRowColor 
{
	[CmdletBinding()]
	Param (
		# Word COM object table reference
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)] [ValidateNotNullOrEmpty()] $Table,
		# Alternate row background color
		[Parameter(Mandatory=$true, Position=1)] [ValidateNotNull()] [int] $BackgroundColor,
		# Alternate row starting seed
		[Parameter(ValueFromPipelineByPropertyName=$true, Position=2)] [ValidateSet('First','Second')] [string] $Seed = 'First'
	)

	Process 
	{
		$StartDateTime = Get-Date;
		Write-Debug ("{0}: `t`tSetting alternate table row colors.." -f $StartDateTime);

		## Determine the row seed (only really need to check for 'Second' and default to 'First' otherwise
		If($Seed.ToLower() -eq 'second') 
		{ 
			$StartRowIndex = 2; 
		}
		Else 
		{ 
			$StartRowIndex = 1; 
		}

		For($AlternateRowIndex = $StartRowIndex; $AlternateRowIndex -lt $Table.Rows.Count; $AlternateRowIndex += 2) 
		{ 
			$Table.Rows.Item($AlternateRowIndex).Shading.BackgroundPatternColor = $BackgroundColor;
		}

		## I've put verbose calls in here we can see how expensive this functionality actually is.
		$EndDateTime = Get-Date;
		$ExecutionTime = New-TimeSpan -Start $StartDateTime -End $EndDateTime;
		Write-Debug ("{0}: `t`tDone setting alternate row style color in '{1}' seconds" -f $EndDateTime, $ExecutionTime.TotalSeconds);
	}
}

Function validStateProp( [object] $object, [string] $topLevel, [string] $secondLevel )
{
	#function created 8-jan-2014 by Michael B. Smith
	if( $object )
	{
		If( ( gm -Name $topLevel -InputObject $object ) )
		{
			If( ( gm -Name $secondLevel -InputObject $object.$topLevel ) )
			{
				Return $True
			}
		}
	}
	Return $False
}

Function SetupWord
{
	Write-Verbose "$(Get-Date): Setting up Word"
    
	# Setup word for output
	Write-Verbose "$(Get-Date): Create Word comObject.  Ignore the next message."
	$Script:Word = New-Object -comobject "Word.Application" -EA 0
	
	If(!$? -or $Script:Word -eq $Null)
	{
		Write-Warning "The Word object could not be created.  You may need to repair your Word installation."
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "`n`n`t`tThe Word object could not be created.  You may need to repair your Word installation.`n`n`t`tScript cannot continue.`n`n"
		Exit
	}

	Write-Verbose "$(Get-Date): Determine Word language value"
	If( ( validStateProp $Script:Word Language Value__ ) )
	{
		[int]$Script:WordLanguageValue = [int]$Script:Word.Language.Value__
	}
	Else
	{
		[int]$Script:WordLanguageValue = [int]$Script:Word.Language
	}

	If(!($Script:WordLanguageValue -gt -1))
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "`n`n`t`tUnable to determine the Word language value.`n`n`t`tScript cannot continue.`n`n"
		AbortScript
	}
	Write-Verbose "$(Get-Date): Word language value is $($Script:WordLanguageValue)"
	
	$Script:WordCultureCode = GetCulture $Script:WordLanguageValue
	
	SetWordHashTable $Script:WordCultureCode
	
	[int]$Script:WordVersion = [int]$Script:Word.Version
	If($Script:WordVersion -eq $wdWord2013)
	{
		$Script:WordProduct = "Word 2013"
	}
	ElseIf($Script:WordVersion -eq $wdWord2010)
	{
		$Script:WordProduct = "Word 2010"
	}
	ElseIf($Script:WordVersion -eq $wdWord2007)
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "`n`n`t`tMicrosoft Word 2007 is no longer supported.`n`n`t`tScript will end.`n`n"
		AbortScript
	}
	Else
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "`n`n`t`tYou are running an untested or unsupported version of Microsoft Word.`n`n`t`tScript will end.`n`n`t`tPlease send info on your version of Word to webster@carlwebster.com`n`n"
		AbortScript
	}

	#only validate CompanyName if the field is blank
	If([String]::IsNullOrEmpty($CoName))
	{
		Write-Verbose "$(Get-Date): Company name is blank.  Retrieve company name from registry."
		$TmpName = ValidateCompanyName
		
		If([String]::IsNullOrEmpty($TmpName))
		{
			Write-Warning "`n`n`t`tCompany Name is blank so Cover Page will not show a Company Name."
			Write-Warning "`n`t`tCheck HKCU:\Software\Microsoft\Office\Common\UserInfo for Company or CompanyName value."
			Write-Warning "`n`t`tYou may want to use the -CompanyName parameter if you need a Company Name on the cover page.`n`n"
		}
		Else
		{
			$Script:CoName = $TmpName
			Write-Verbose "$(Get-Date): Updated company name to $($Script:CoName)"
		}
	}

	If($Script:WordCultureCode -ne "en-")
	{
		Write-Verbose "$(Get-Date): Check Default Cover Page for $($WordCultureCode)"
		[bool]$CPChanged = $False
		Switch ($Script:WordCultureCode)
		{
			'ca-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Línia lateral"
						$CPChanged = $True
					}
				}

			'da-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Sidelinje"
						$CPChanged = $True
					}
				}

			'de-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Randlinie"
						$CPChanged = $True
					}
				}

			'es-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Línea lateral"
						$CPChanged = $True
					}
				}

			'fi-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Sivussa"
						$CPChanged = $True
					}
				}

			'fr-'	{
					If($CoverPage -eq "Sideline")
					{
						If($Script:WordVersion -eq $wdWord2013)
						{
							$CoverPage = "Lignes latérales"
							$CPChanged = $True
						}
						Else
						{
							$CoverPage = "Ligne latérale"
							$CPChanged = $True
						}
					}
				}

			'nb-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Sidelinje"
						$CPChanged = $True
					}
				}

			'nl-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Terzijde"
						$CPChanged = $True
					}
				}

			'pt-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Linha Lateral"
						$CPChanged = $True
					}
				}

			'sv-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Sidlinje"
						$CPChanged = $True
					}
				}
		}

		If($CPChanged)
		{
			Write-Verbose "$(Get-Date): Changed Default Cover Page from Sideline to $($CoverPage)"
		}
	}

	Write-Verbose "$(Get-Date): Validate cover page $($CoverPage) for culture code $($Script:WordCultureCode)"
	[bool]$ValidCP = $False
	
	$ValidCP = ValidateCoverPage $Script:WordVersion $CoverPage $Script:WordCultureCode
	
	If(!$ValidCP)
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Verbose "$(Get-Date): Word language value $($Script:WordLanguageValue)"
		Write-Verbose "$(Get-Date): Culture code $($Script:WordCultureCode)"
		Write-Error "`n`n`t`tFor $($Script:WordProduct), $($CoverPage) is not a valid Cover Page option.`n`n`t`tScript cannot continue.`n`n"
		AbortScript
	}

	ShowScriptOptions

	$Script:Word.Visible = $False

	#http://jdhitsolutions.com/blog/2012/05/san-diego-2012-powershell-deep-dive-slides-and-demos/
	#using Jeff's Demo-WordReport.ps1 file for examples
	Write-Verbose "$(Get-Date): Load Word Templates"

	[bool]$Script:CoverPagesExist = $False
	[bool]$BuildingBlocksExist = $False

	$Script:Word.Templates.LoadBuildingBlocks()
	#word 2010/2013
	$BuildingBlocksCollection = $Script:Word.Templates | Where {$_.name -eq "Built-In Building Blocks.dotx"}

	Write-Verbose "$(Get-Date): Attempt to load cover page $($CoverPage)"
	$part = $Null

	$BuildingBlocksCollection | 
	ForEach{
		If ($_.BuildingBlockEntries.Item($CoverPage).Name -eq $CoverPage) 
		{
			$BuildingBlocks = $_
		}
	}        

	If($BuildingBlocks -ne $Null)
	{
		$BuildingBlocksExist = $True

		Try 
		{
			$part = $BuildingBlocks.BuildingBlockEntries.Item($CoverPage)
		}

		Catch
		{
			$part = $Null
		}

		If($part -ne $Null)
		{
			$Script:CoverPagesExist = $True
		}
	}

	If(!$Script:CoverPagesExist)
	{
		Write-Verbose "$(Get-Date): Cover Pages are not installed or the Cover Page $($CoverPage) does not exist."
		Write-Warning "Cover Pages are not installed or the Cover Page $($CoverPage) does not exist."
		Write-Warning "This report will not have a Cover Page."
	}

	Write-Verbose "$(Get-Date): Create empty word doc"
	$Script:Doc = $Script:Word.Documents.Add()
	If($Script:Doc -eq $Null)
	{
		Write-Verbose "$(Get-Date): "
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "`n`n`t`tAn empty Word document could not be created.`n`n`t`tScript cannot continue.`n`n"
		AbortScript
	}

	$Script:Selection = $Script:Word.Selection
	If($Script:Selection -eq $Null)
	{
		Write-Verbose "$(Get-Date): "
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "`n`n`t`tAn unknown error happened selecting the entire Word document for default formatting options.`n`n`t`tScript cannot continue.`n`n"
		AbortScript
	}

	#set Default tab stops to 1/2 inch (this line is not from Jeff Hicks)
	#36 = .50"
	$Script:Word.ActiveDocument.DefaultTabStop = 36

	#Disable Spell and Grammar Check to resolve issue and improve performance (from Pat Coughlin)
	Write-Verbose "$(Get-Date): Disable grammar and spell checking"
	#bug reported 1-Apr-2014 by Tim Mangan
	#save current options first before turning them off
	$Script:CurrentGrammarOption = $Script:Word.Options.CheckGrammarAsYouType
	$Script:CurrentSpellingOption = $Script:Word.Options.CheckSpellingAsYouType
	$Script:Word.Options.CheckGrammarAsYouType = $False
	$Script:Word.Options.CheckSpellingAsYouType = $False

	If($BuildingBlocksExist)
	{
		#insert new page, getting ready for table of contents
		Write-Verbose "$(Get-Date): Insert new page, getting ready for table of contents"
		$part.Insert($Script:Selection.Range,$True) | Out-Null
		$Script:Selection.InsertNewPage()

		#table of contents
		Write-Verbose "$(Get-Date): Table of Contents - $($Script:MyHash.Word_TableOfContents)"
		$toc = $BuildingBlocks.BuildingBlockEntries.Item($Script:MyHash.Word_TableOfContents)
		If($toc -eq $Null)
		{
			Write-Verbose "$(Get-Date): "
			Write-Verbose "$(Get-Date): Table of Content - $($Script:MyHash.Word_TableOfContents) could not be retrieved."
			Write-Warning "This report will not have a Table of Contents."
		}
		Else
		{
			$toc.insert($Script:Selection.Range,$True) | Out-Null
		}
	}
	Else
	{
		Write-Verbose "$(Get-Date): Table of Contents are not installed."
		Write-Warning "Table of Contents are not installed so this report will not have a Table of Contents."
	}

	#set the footer
	Write-Verbose "$(Get-Date): Set the footer"
	[string]$footertext = "Report created by $username"

	#get the footer
	Write-Verbose "$(Get-Date): Get the footer and format font"
	$Script:Doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekPrimaryFooter
	#get the footer and format font
	$footers = $Script:Doc.Sections.Last.Footers
	ForEach ($footer in $footers) 
	{
		If($footer.exists) 
		{
			$footer.range.Font.name = "Calibri"
			$footer.range.Font.size = 8
			$footer.range.Font.Italic = $True
			$footer.range.Font.Bold = $True
		}
	} #end ForEach
	Write-Verbose "$(Get-Date): Footer text"
	$Script:Selection.HeaderFooter.Range.Text = $footerText

	#add page numbering
	Write-Verbose "$(Get-Date): Add page numbering"
	$Script:Selection.HeaderFooter.PageNumbers.Add($wdAlignPageNumberRight) | Out-Null

	FindWordDocumentEnd
	Write-Verbose "$(Get-Date):"
	#end of Jeff Hicks 
}

Function UpdateDocumentProperties
{
	Param([string]$AbstractTitle, [string]$SubjectTitle)
	#Update document properties
	If($MSWORD -or $PDF)
	{
		If($Script:CoverPagesExist)
		{
			Write-Verbose "$(Get-Date): Set Cover Page Properties"
			_SetDocumentProperty $Script:Doc.BuiltInDocumentProperties "Company" $Script:CoName
			_SetDocumentProperty $Script:Doc.BuiltInDocumentProperties "Title" $Script:title
			_SetDocumentProperty $Script:Doc.BuiltInDocumentProperties "Author" $username

			_SetDocumentProperty $Script:Doc.BuiltInDocumentProperties "Subject" $SubjectTitle

			#Get the Coverpage XML part
			$cp = $Script:Doc.CustomXMLParts | Where {$_.NamespaceURI -match "coverPageProps$"}

			#get the abstract XML part
			$ab = $cp.documentelement.ChildNodes | Where {$_.basename -eq "Abstract"}

			#set the text
			If([String]::IsNullOrEmpty($Script:CoName))
			{
				[string]$abstract = $AbstractTitle
			}
			Else
			{
				[string]$abstract = "$($AbstractTitle) for $Script:CoName"
			}

			$ab.Text = $abstract

			$ab = $cp.documentelement.ChildNodes | Where {$_.basename -eq "PublishDate"}
			#set the text
			[string]$abstract = (Get-Date -Format d).ToString()
			$ab.Text = $abstract

			Write-Verbose "$(Get-Date): Update the Table of Contents"
			#update the Table of Contents
			$Script:Doc.TablesOfContents.item(1).Update()
			$cp = $Null
			$ab = $Null
			$abstract = $Null
		}
	}
}

Function SaveandCloseDocumentandShutdownWord
{
	#bug fix 1-Apr-2014
	#reset Grammar and Spelling options back to their original settings
	$Script:Word.Options.CheckGrammarAsYouType = $Script:CurrentGrammarOption
	$Script:Word.Options.CheckSpellingAsYouType = $Script:CurrentSpellingOption

	Write-Verbose "$(Get-Date): Save and Close document and Shutdown Word"
	If($Script:WordVersion -eq $wdWord2010)
	{
		#the $saveFormat below passes StrictMode 2
		#I found this at the following two links
		#http://blogs.technet.com/b/bshukla/archive/2011/09/27/3347395.aspx
		#http://msdn.microsoft.com/en-us/library/microsoft.office.interop.word.wdsaveformat(v=office.14).aspx
		If($PDF)
		{
			Write-Verbose "$(Get-Date): Saving as DOCX file first before saving to PDF"
		}
		Else
		{
			Write-Verbose "$(Get-Date): Saving DOCX file"
		}
		If($AddDateTime)
		{
			$Script:FileName1 += "_$(Get-Date -f yyyy-MM-dd_HHmm).docx"
			If($PDF)
			{
				$Script:FileName2 += "_$(Get-Date -f yyyy-MM-dd_HHmm).pdf"
			}
		}
		Write-Verbose "$(Get-Date): Running Word 2010 and detected operating system $($RunningOS)"
		$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatDocumentDefault")
		$Script:Doc.SaveAs([REF]$Script:FileName1, [ref]$SaveFormat)
		If($PDF)
		{
			Write-Verbose "$(Get-Date): Now saving as PDF"
			$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatPDF")
			$Script:Doc.SaveAs([REF]$Script:FileName2, [ref]$saveFormat)
		}
	}
	ElseIf($Script:WordVersion -eq $wdWord2013)
	{
		If($PDF)
		{
			Write-Verbose "$(Get-Date): Saving as DOCX file first before saving to PDF"
		}
		Else
		{
			Write-Verbose "$(Get-Date): Saving DOCX file"
		}
		If($AddDateTime)
		{
			$Script:FileName1 += "_$(Get-Date -f yyyy-MM-dd_HHmm).docx"
			If($PDF)
			{
				$Script:FileName2 += "_$(Get-Date -f yyyy-MM-dd_HHmm).pdf"
			}
		}
		Write-Verbose "$(Get-Date): Running Word 2013 and detected operating system $($RunningOS)"
		$Script:Doc.SaveAs2([REF]$Script:FileName1, [ref]$wdFormatDocumentDefault)
		If($PDF)
		{
			Write-Verbose "$(Get-Date): Now saving as PDF"
			$Script:Doc.SaveAs([REF]$Script:FileName2, [ref]$wdFormatPDF)
		}
	}

	Write-Verbose "$(Get-Date): Closing Word"
	$Script:Doc.Close()
	$Script:Word.Quit()
	If($PDF)
	{
		Write-Verbose "$(Get-Date): Deleting $($Script:FileName1) since only $($Script:FileName2) is needed"
		Remove-Item $Script:FileName1
	}
	Write-Verbose "$(Get-Date): System Cleanup"
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Script:Word) | Out-Null
	If(Test-Path variable:global:word)
	{
		Remove-Variable -Name word -Scope Global
	}
	$SaveFormat = $Null
	[gc]::collect() 
	[gc]::WaitForPendingFinalizers()
}

Function SaveandCloseTextDocument
{
	If($AddDateTime)
	{
		$Script:FileName1 += "_$(Get-Date -f yyyy-MM-dd_HHmm).txt"
	}

	Write-Output $Global:Output | Out-File $Script:Filename1
}

Function SaveandCloseHTMLDocument
{
	If($AddDateTime)
	{
		$Script:FileName1 += "_$(Get-Date -f yyyy-MM-dd_HHmm).html"
	}
}

Function SetFileName1andFileName2
{
	Param([string]$OutputFileName)
	$pwdpath = $pwd.Path

	If($pwdpath.EndsWith("\"))
	{
		#remove the trailing \
		$pwdpath = $pwdpath.SubString(0, ($pwdpath.Length - 1))
	}

	#set $filename1 and $filename2 with no file extension
	If($AddDateTime)
	{
		[string]$Script:FileName1 = "$($pwdpath)\$($OutputFileName)"
		If($PDF)
		{
			[string]$Script:FileName2 = "$($pwdpath)\$($OutputFileName)"
		}
	}

	If($MSWord -or $PDF)
	{
		CheckWordPreReq

		If(!$AddDateTime)
		{
			[string]$Script:FileName1 = "$($pwdpath)\$($OutputFileName).docx"
			If($PDF)
			{
				[string]$Script:FileName2 = "$($pwdpath)\$($OutputFileName).pdf"
			}
		}

		SetupWord
	}
	ElseIf($Text)
	{
		If(!$AddDateTime)
		{
			[string]$Script:FileName1 = "$($pwdpath)\$($OutputFileName).txt"
		}
	}
	ElseIf($HTML)
	{
		If(!$AddDateTime)
		{
			[string]$Script:FileName1 = "$($pwdpath)\$($OutputFileName).html"
		}
	}
}

Function BuildMultiColumnTable
{
	Param([Array]$xArray, [String]$xType)
	
	#divide by 0 bug reported 9-Apr-2014 by Lee Dehmer 
	#if security group name or OU name was longer than 60 characters it caused a divide by 0 error
	
	#added a second parameter to the function so the verbose message would say whether 
	#the function is processing servers, security groups or OUs.
	
	If(-not ($xArray -is [Array]))
	{
		$xArray = (,$xArray)
	}
	[int]$MaxLength = 0
	[int]$TmpLength = 0
	#remove 60 as a hard-coded value
	#60 is the max width the table can be when indented 36 points
	[int]$MaxTableWidth = 60
	ForEach($xName in $xArray)
	{
		$TmpLength = $xName.Length
		If($TmpLength -gt $MaxLength)
		{
			$MaxLength = $TmpLength
		}
	}
	$TableRange = $doc.Application.Selection.Range
	#removed hard-coded value of 60 and replace with MaxTableWidth variable
	[int]$Columns = [Math]::Floor($MaxTableWidth / $MaxLength)
	If($xArray.count -lt $Columns)
	{
		[int]$Rows = 1
		#not enough array items to fill columns so use array count
		$MaxCells  = $xArray.Count
		#reset column count so there are no empty columns
		$Columns   = $xArray.Count 
	}
	ElseIf($Columns -eq 0)
	{
		#divide by 0 bug if this condition is not handled
		#number was larger than $MaxTableWidth so there can only be one column
		#with one cell per row
		[int]$Rows = $xArray.count
		$Columns   = 1
		$MaxCells  = 1
	}
	Else
	{
		[int]$Rows = [Math]::Floor( ( $xArray.count + $Columns - 1 ) / $Columns)
		#more array items than columns so don't go past last column
		$MaxCells  = $Columns
	}
	$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
	$Table.Style = $Script:MyHash.Word_TableGrid
	
	$Table.Borders.InsideLineStyle = $wdLineStyleSingle
	$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
	[int]$xRow = 1
	[int]$ArrayItem = 0
	While($xRow -le $Rows)
	{
		For($xCell=1; $xCell -le $MaxCells; $xCell++)
		{
			$Table.Cell($xRow,$xCell).Range.Text = $xArray[$ArrayItem]
			$ArrayItem++
		}
		$xRow++
	}
	$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
	$Table.AutoFitBehavior($wdAutoFitContent)

	#return focus back to document
	$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

	#move to the end of the current document
	$selection.EndKey($wdStory,$wdMove) | Out-Null
	$TableRange = $Null
	$Table = $Null
	$xArray = $Null
}

Function UserIsaDomainAdmin
{
	#function adapted from sample code provided by Thomas Vuylsteke
	$IsDA = $False
	$name = $env:username
	Write-Verbose "$(Get-Date): TokenGroups - Checking groups for $name"

	$root = [ADSI]""
	$filter = "(sAMAccountName=$name)"
	$props = @("distinguishedName")
	$Searcher = new-Object System.DirectoryServices.DirectorySearcher($root,$filter,$props)
	$account = $Searcher.FindOne().properties.distinguishedname

	$user = [ADSI]"LDAP://$Account"
	$user.GetInfoEx(@("tokengroups"),0)
	$groups = $user.Get("tokengroups")

	$domainAdminsSID = New-Object System.Security.Principal.SecurityIdentifier (((Get-ADDomain -Server $ADForest).DomainSid).Value+"-512") 

	ForEach($group in $groups)
	{     
		$ID = New-Object System.Security.Principal.SecurityIdentifier($group,0)       
		If($ID.CompareTo($domainAdminsSID) -eq 0)
		{
			$IsDA = $True
		}     
	}

	$root = $Null
	$filter = $Null
	$props = $Null
	$Searcher = $Null
	$account = $Null
	$user = $Null
	$groups = $Null
	$domainAdminsSID = $Null
	Return $IsDA
}

Function GetComputerCountByOS
{
	Param([string]$xDomain)

	<#
	  This function will count the number of Windows workstations, Windows servers and
	  non-Windows computers and list them by Operating System.

	  Note that for servers we filter out Cluster Name Objects (CNOs) and
	  Virtual Computer Objects (VCOs) by checking the objects serviceprincipalname
	  property for a value of MSClusterVirtualServer. The CNO is the cluster
	  name, whereas a VCO is the client access point for the clustered role.
	  These are not actual computers, so we exlude them to assist with
	  accuracy.

	  Function Name: GetComputerCountByOS
	  Release: 1.0
	  Written by Jeremy@jhouseconsulting.com 20th May 2012
	#>

	#function optimized by Michael B. Smith
	
	Write-Verbose "$(Get-Date): `t`tGathering computer misc data"
	$Computers = @()
	$UnknownComputers = @()
	
	$Results = Get-ADComputer -Filter * -Properties Name,Operatingsystem,servicePrincipalName,DistinguishedName -Server $Domain
	
	If($? -and $Results -ne $Null)
	{
	
		Write-Verbose "$(Get-Date): `t`t`tGetting server OS counts"
		$Computers += $Results | `
			Where-Object {($_.Operatingsystem -like '*server*') -AND !($_.serviceprincipalname -like '*MSClusterVirtualServer*')} | `
			Sort-Object Name
		
		Write-Verbose "$(Get-Date): `t`t`tGetting workstation OS counts"
		$Computers += $Results | `
			Where-Object {($_.Operatingsystem -like '*windows*') -AND !($_.Operatingsystem -like '*server*')} | `
			Sort-Object Name
		
		Write-Verbose "$(Get-Date): `t`t`tGetting unknown OS counts"
		$UnknownComputers += $Results | `
			Where-Object {!($_.Operatingsystem -like '*windows*') -AND !($_.serviceprincipalname -like '*MSClusterVirtualServer*')} | `
			Sort-Object Name
		
		$Computers += $UnknownComputers
		$UnknownComputers = $UnknownComputers | Sort DistinguishedName
		
		$Computers = $Computers | Group-Object operatingsystem | Sort-Object Count -Descending

		Write-Verbose "$(Get-Date): `t`tBuild table for OS counts"
		WriteWordLine 3 0 "Windows Computer Operating Systems"
		$TableRange   = $doc.Application.Selection.Range
		[int]$Columns = 2
		If($Computers -is [array])
		{
			[int]$Rows = $Computers.Count
		}
		Else
		{
			[int]$Rows = 1
		}
		$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
		$Table.Style = $Script:MyHash.Word_TableGrid
	
		$Table.Borders.InsideLineStyle = $wdLineStyleSingle
		$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
		
		[int]$xRow = 0
		
		ForEach($Computer in $Computers)
		{
			$xRow++
			[string]$CountStr = "{0,7:N0}" -f $Computer.Count
			$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			If([String]::IsNullOrEmpty($Computer.Name))
			{
				$Table.Cell($xRow,1).Range.Text = "<No OS name>"
			}
			Else
			{
				$Table.Cell($xRow,1).Range.Text = $Computer.Name
			}
			$Table.Cell($xRow,2).Range.ParagraphFormat.Alignment = $wdCellAlignVerticalTop
			$Table.Cell($xRow,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
			$Table.Cell($xRow,2).Range.Text = $CountStr
		}
		
		$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
		$Table.AutoFitBehavior($wdAutoFitContent)

		#return focus back to document
		$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

		#move to the end of the current document
		$selection.EndKey($wdStory,$wdMove) | Out-Null
		$TableRange = $Null
		$Table = $Null
		
		If($UnknownComputers -ne $Null)
		{
			Write-Verbose "$(Get-Date): `t`tBuild table for unknown computers"
			WriteWordLine 3 0 "Non-Windows Computer Operating Systems"
			$TableRange   = $doc.Application.Selection.Range
			[int]$Columns = 2
			If($UnknownComputers -is [array])
			{
				[int]$Rows = $UnknownComputers.Count + 1
			}
			Else
			{
				[int]$Rows = 2
			}
			$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
			$Table.AutoFitBehavior($wdAutoFitFixed)
			$Table.Style = $Script:MyHash.Word_TableGrid
	
			$Table.rows.first.headingformat = $wdHeadingFormatTrue
			$Table.Borders.InsideLineStyle = $wdLineStyleSingle
			$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
			$Table.Rows.First.Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell(1,1).Range.Font.Bold = $True
			$Table.Cell(1,1).Range.Text = "Distinguished Name"
			$Table.Cell(1,2).Range.Font.Bold = $True
			$Table.Cell(1,2).Range.Text = "Operating System"
			
			[int]$xRow = 1
			
			ForEach($Computer in $UnknownComputers)
			{
				$xRow++
				[string]$CountStr = "{0,7:N0}" -f $Computer.Count
				$Table.Cell($xRow,1).Range.Text = $Computer.DistinguishedName
				If([String]::IsNullOrEmpty($Computer.OperatingSystem))
				{
					$Table.Cell($xRow,2).Range.Text = "<No OS name>"
				}
				Else
				{
					$Table.Cell($xRow,2).Range.Text = $Computer.OperatingSystem
				}
			}
			
			#set column widths
			$xcols = $table.columns

			ForEach($xcol in $xcols)
			{
			    switch ($xcol.Index)
			    {
				  1 {$xcol.width = 400}
				  2 {$xcol.width = 100}
			    }
			}

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
			$Table.AutoFitBehavior($wdAutoFitFixed)

			#return focus back to document
			$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

			#move to the end of the current document
			$selection.EndKey($wdStory,$wdMove) | Out-Null
			$TableRange = $Null
			$Table = $Null
		}
	}
	ElseIf(!$?)
	{
		Write-Warning "Error retrieving computer data for domain $($xDomain)"
		WriteWordLine 0 0 "Error retrieving computer data for domain $($xDomain)" "" $Null 0 $False $True
	}
	Else
	{
		WriteWordLine 0 0 "No computer data was retrieved for domain $($xDomain)" "" $Null 0 $False $True
	}
	$Computers = $Null
	$UnknownComputers = $Null
	$Results = $Null
}

Function ShowScriptOptions
{
	Write-Verbose "$(Get-Date): "
	Write-Verbose "$(Get-Date): "
	Write-Verbose "$(Get-Date): Company Name : $($CompanyName)"
	Write-Verbose "$(Get-Date): Cover Page   : $($CoverPage)"
	Write-Verbose "$(Get-Date): User Name    : $($UserName)"
	Write-Verbose "$(Get-Date): Save As PDF  : $($PDF)"
	Write-Verbose "$(Get-Date): HW Inventory : $($Hardware)"
	Write-Verbose "$(Get-Date): Services     : $($Services)"
	Write-Verbose "$(Get-Date): Forest Name  : $($ADForest)"
	Write-Verbose "$(Get-Date): Title        : $($Title)"
	Write-Verbose "$(Get-Date): Filename1    : $($filename1)"
	If($PDF)
	{
		Write-Verbose "$(Get-Date): Filename2    : $($filename2)"
	}
	Write-Verbose "$(Get-Date): Add DateTime : $($AddDateTime)"
	Write-Verbose "$(Get-Date): OS Detected  : $($RunningOS)"
	Write-Verbose "$(Get-Date): PSUICulture  : $($PSUICulture)"
	Write-Verbose "$(Get-Date): PSCulture    : $($PSCulture)"
	Write-Verbose "$(Get-Date): Word version : $($WordProduct)"
	Write-Verbose "$(Get-Date): Word language: $($Script:WordLanguageValue)"
	Write-Verbose "$(Get-Date): PoSH version : $($Host.Version)"
	Write-Verbose "$(Get-Date): "
	Write-Verbose "$(Get-Date): Script start : $($Script:StartTime)"
	Write-Verbose "$(Get-Date): "
	Write-Verbose "$(Get-Date): "
}

#Script begins

$script:startTime = Get-Date

If($TEXT)
{
	$global:output = ""
}

#If hardware inventory or services are requested, make sure user is running the script with Domain Admin rights
$DARights = $False
If($Hardware -or $Services)
{
	Write-Verbose "$(Get-Date): `tTesting to see if $($env:username) has Domain Admin rights"
	If($Hardware -and -not $Services)
	{
		Write-Verbose "$(Get-Date): Hardware inventory requested"
	}
	ElseIf($Services -and -not $Hardware)
	{
		Write-Verbose "$(Get-Date): Services requested"
	}
	ElseIf($Hardware -and $Services)
	{
		Write-Verbose "$(Get-Date): Hardware inventory and Services requested"
	}

	If(UserIsaDomainAdmin)
	{
		#user has Domain Admin rights
		Write-Verbose "$(Get-Date): $($env:username) has Domain Admin rights in the $($ADForest) Forest"
		$DARights = $True
	}
	Else
	{
		#user does not have Domain Admin rights
		If($Hardware -and -not $Services)
		{
			#don't abort script, set $hardware to false
			Write-Warning "`n`n`t`tHardware inventory was requested but $($WindowsIdentity.Name) does not have Domain Admin rights."
			Write-Warning "`n`n`t`tHardware inventory option will be turned off."
			$Hardware = $False
		}
		ElseIf($Services -and -not $Hardware)
		{
			#don't abort script, set $services to false
			Write-Warning "`n`n`t`tServices were requested but $($WindowsIdentity.Name) does not have Domain Admin rights."
			Write-Warning "`n`n`t`tServices option will be turned off."
			$Services = $False
		}
		ElseIf($Hardware -and $Services)
		{
			#don't abort script, set $hardware and $services to false
			Write-Warning "`n`n`t`tHardware inventory and Services were requested but $($WindowsIdentity.Name) does not have Domain Admin rights."
			Write-Warning "`n`n`t`tHardware inventory and Services options will be turned off."
			$Hardware = $False
			$Services = $False
		}
	}
}

If(![String]::IsNullOrEmpty($ComputerName)) 
{
	#get server name
	#first test to make sure the server is reachable
	Write-Verbose "$(Get-Date): Testing to see if $($ComputerName) is online and reachable"
	If(Test-Connection -ComputerName $ComputerName -quiet)
	{
		Write-Verbose "$(Get-Date): Server $($ComputerName) is online."
		Write-Verbose "$(Get-Date): `tTesting to see if it is a Domain Controller."
		#the server may be online but is it really a domain controller?

		#is the ComputerName in the current domain
		$Results = Get-ADDomainController $ComputerName
		
		If(!$?)
		{
			#try using the Forest name
			$Results = Get-ADDomainController $ComputerName -Server $ADForest
			If(!$?)
			{
				$ErrorActionPreference = $SaveEAPreference
				Write-Error "`n`n`t`t$($ComputerName) is not a domain controller for $($ADForest).`n`t`tScript cannot continue.`n`n"
				Exit
			}
		}
		$Results = $Null
	}
	Else
	{
		Write-Verbose "$(Get-Date): Computer $($ComputerName) is offline"
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "`n`n`t`tComputer $($ComputerName) is offline.`nScript cannot continue.`n`n"
		Exit
	}
}

#if computer name is localhost, get actual server name
If($ComputerName -eq "localhost")
{
	$ComputerName = $env:ComputerName
	Write-Verbose "$(Get-Date): Computer name has been renamed from localhost to $($ComputerName)"
}

#if computer name is an IP address, get host name from DNS
#http://blogs.technet.com/b/gary/archive/2009/08/29/resolve-ip-addresses-to-hostname-using-powershell.aspx
#help from Michael B. Smith
$ip = $ComputerName -as [System.Net.IpAddress]
If($ip)
{
	$Result = [System.Net.Dns]::gethostentry($ip)
	
	If($? -and $Result -ne $Null)
	{
		$ComputerName = $Result.HostName
		Write-Verbose "$(Get-Date): Computer name has been renamed from $($ip) to $($ComputerName)"
	}
	Else
	{
		Write-Warning "Unable to resolve $($ComputerName) to a hostname"
	}
}
Else
{
	#server is online but for some reason $ComputerName cannot be converted to a System.Net.IpAddress
}

#get forest information so output filename can be generated
Write-Verbose "$(Get-Date): Testing to see if $($ADForest) is a valid forest name"
If([String]::IsNullOrEmpty($ComputerName))
{
	$Forest = Get-ADForest -Identity $ADForest
	
	If(!$?)
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "`n`n`t`tCould not find a forest identified by: $($ADForest).`nScript cannot continue.`n`n"
		Exit
	}
}
Else
{
	$Forest = Get-ADForest -Identity $ADForest -Server $ComputerName

	If(!$?)
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "`n`n`t`tCould not find a forest with the name of $($ADForest).`n`n`t`tScript cannot continue.`n`n`t`tIs $($ComputerName) running Active Directory Web Services?"
		Exit
	}
}
Write-Verbose "$(Get-Date): $($ADForest) is a valid forest name"
#store root domain so it only has to be accessed once
[string]$ForestRootDomain = $Forest.RootDomain
[string]$ForestName = $Forest.Name
[string]$Title      = "Inventory Report for the $($ForestName) Forest"
SetFilename1andFilename2 "$($ForestRootDomain)"

######################START OF BUILDING REPORT

#Forest information

#set naming context
$ConfigNC = (Get-ADRootDSE -Server $ADForest).ConfigurationNamingContext

Write-Verbose "$(Get-Date): Writing forest data"

$selection.InsertNewPage()
WriteWordLine 1 0 "Forest Information"

Switch ($Forest.ForestMode)
{
	"0"	{$ForestMode = "Windows 2000"}
	"1" {$ForestMode = "Windows Server 2003 interim"}
	"2" {$ForestMode = "Windows Server 2003"}
	"3" {$ForestMode = "Windows Server 2008"}
	"4" {$ForestMode = "Windows Server 2008 R2"}
	"5" {$ForestMode = "Windows Server 2012"}
	"6" {$ForestMode = "Windows Server 2012 R2"}
	"Windows2000Forest"        {$ForestMode = "Windows 2000"}
	"Windows2003InterimForest" {$ForestMode = "Windows Server 2003 interim"}
	"Windows2003Forest"        {$ForestMode = "Windows Server 2003"}
	"Windows2008Forest"        {$ForestMode = "Windows Server 2008"}
	"Windows2008R2Forest"      {$ForestMode = "Windows Server 2008 R2"}
	"Windows2012Forest"        {$ForestMode = "Windows Server 2012"}
	"Windows2012R2Forest"      {$ForestMode = "Windows Server 2012 R2"}
	"UnknownForest"            {$ForestMode = "Unknown Forest Mode"}
	Default                    {$ForestMode = "Unable to determine Forest Mode: $($Forest.ForestMode)"}
}

$TableRange = $doc.Application.Selection.Range
[int]$Columns = 2
[int]$Rows = 12
[int]$xRow = 1
$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
$Table.AutoFitBehavior($wdAutoFitFixed)
$Table.Style = $Script:MyHash.Word_TableGrid
	
$Table.Borders.InsideLineStyle = $wdLineStyleSingle
$Table.Borders.OutsideLineStyle = $wdLineStyleSingle

$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "Forest mode"
$Table.Cell($xRow,2).Range.Text = $ForestMode

$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "Forest name"
$Table.Cell($xRow,2).Range.Text = $Forest.Name

$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "Root domain"
$Table.Cell($xRow,2).Range.Text = $ForestRootDomain

$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "Domain naming master"
$Table.Cell($xRow,2).Range.Text = $Forest.DomainNamingMaster

$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "Schema master"
$Table.Cell($xRow,2).Range.Text = $Forest.SchemaMaster

$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "Partitions container"
$Table.Cell($xRow,2).Range.Text = $Forest.PartitionsContainer

Write-Verbose "$(Get-Date): `tApplication partitions"
$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "Application partitions"

$AppPartitions = $Forest.ApplicationPartitions | Sort
If($AppPartitions -eq $Null)
{
	$Table.Cell($xRow,2).Range.Text = "<None>"
}
Else
{
	$tmp = @()
	ForEach($AppPartition in $AppPartitions)
	{
		$tmp += "$($AppPartition)`r"
	}
	$Table.Cell($xRow,2).Range.Text = $tmp
}
$AppPartitions = $Null
$tmp = $Null

Write-Verbose "$(Get-Date): `tCross forest references"
$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "Cross forest references"

$CrossForestReferences = $Forest.CrossForestReferences | Sort
If($CrossForestReferences -eq $Null)
{
	$Table.Cell($xRow,2).Range.Text = "<None>"
}
Else
{
	$tmp = @()
	ForEach($CrossForestReference in $CrossForestReferences)
	{
		$tmp += "$($CrossForestReference)`r"
	}
	$Table.Cell($xRow,2).Range.Text = $tmp
}
$CrossForestReferences = $Null
$tmp = $Null

Write-Verbose "$(Get-Date): `tSPN suffixes"
$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "SPN suffixes"
$SPNSuffixes = $Forest.SPNSuffixes | Sort
If($SPNSuffixes -eq $Null)
{
	$Table.Cell($xRow,2).Range.Text = "<None>"
}
Else
{
	$tmp = @()
	ForEach($SPNSuffix in $SPNSuffixes)
	{
		$tmp += "$($SPNSuffix)`r"
	}
	$Table.Cell($xRow,2).Range.Text = $tmp
}
$SPNSuffixes = $Null
$tmp = $Null

Write-Verbose "$(Get-Date): `tUPN suffixes"
$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "UPN Suffixes"
$UPNSuffixes = $Forest.UPNSuffixes | Sort
If($UPNSuffixes -eq $Null)
{
	$Table.Cell($xRow,2).Range.Text = "<None>"
}
Else
{
	$tmp = @()
	ForEach($UPNSuffix in $UPNSuffixes)
	{
		$tmp += "$($UPNSuffix)`r"
	}
	$Table.Cell($xRow,2).Range.Text = $tmp
}
$UPNSuffixes = $Null
$tmp = $Null

Write-Verbose "$(Get-Date): `tDomains in forest"
$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "Domains in forest"
$Domains = $Forest.Domains | Sort
If($Domains -eq $Null)
{
	$Table.Cell($xRow,2).Range.Text = "<None>"
}
Else
{
	#redo list of domains so forest root domain is listed first
	$tmpDomains = @($ForestRootDomain)
	$tmpDomains2 = @("$($ForestRootDomain)`r")
	ForEach($Domain in $Domains)
	{
		If($Domain -ne $ForestRootDomain)
		{
			$tmpDomains += "$($Domain)"
			$tmpDomains2 += "$($Domain)`r"
		}
	}
	
	$Domains = $tmpDomains
	$Table.Cell($xRow,2).Range.Text = $tmpDomains2
}

Write-Verbose "$(Get-Date): `tSites"
$xRow++
$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
$Table.Cell($xRow,1).Range.Font.Bold = $True
$Table.Cell($xRow,1).Range.Text = "Sites"
$Sites = $Forest.Sites | Sort
If($Sites -eq $Null)
{
	$Table.Cell($xRow,2).Range.Text = "<None>"
}
Else
{
	$tmp = @()
	ForEach($Site in $Sites)
	{
		$tmp += "$($Site)`r"
	}
	$Table.Cell($xRow,2).Range.Text = $tmp
}
$Sites = $Null
$tmp = $Null

#set column widths
$xcols = $table.columns

ForEach($xcol in $xcols)
{
    switch ($xcol.Index)
    {
	  1 {$xcol.width = 125}
	  2 {$xcol.width = 300}
    }
}

$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
$Table.AutoFitBehavior($wdAutoFitFixed)

#return focus back to document
$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

#move to the end of the current document
$selection.EndKey($wdStory,$wdMove) | Out-Null
$TableRange = $Null
$Table = $Null

Write-Verbose "$(Get-Date): `tDomain controllers"
WriteWordLine 3 0 "Domain Controllers"
#get all DCs in the forest
#http://www.superedge.net/2012/09/how-to-get-ad-forest-in-powershell.html
#http://msdn.microsoft.com/en-us/library/vstudio/system.directoryservices.activedirectory.forest.getforest%28v=vs.90%29
$ADContext = New-Object System.DirectoryServices.ActiveDirectory.DirectoryContext("forest", $ADForest) 
$Forest2 = [system.directoryservices.activedirectory.Forest]::GetForest($ADContext)
$AllDCs = $Forest2.domains | ForEach-Object {$_.DomainControllers} | ForEach-Object {$_.Name} 
$AllDCs = $AllDCs | Sort
$ADContext = $Null
$Forest2 = $Null

If($AllDCs -eq $Null)
{
	WriteWordLine 0 0 "<None>"
}
Else
{
	$TableRange = $doc.Application.Selection.Range
	[int]$Columns = 3
	If($AllDCs -is [array])
	{
		[int]$Rows = $AllDCs.Count + 1
	}
	Else
	{
		[int]$Rows = 2
	}
	$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
	$Table.Style = $Script:MyHash.Word_TableGrid
	
	$Table.Borders.InsideLineStyle = $wdLineStyleSingle
	$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
	$Table.rows.first.headingformat = $wdHeadingFormatTrue
	$Table.Rows.First.Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell(1,1).Range.Font.Bold = $True
	$Table.Cell(1,1).Range.Text = "Name"
	$Table.Cell(1,2).Range.Font.Bold = $True
	$Table.Cell(1,2).Range.Text = "Global Catalog"
	$Table.Cell(1,3).Range.Font.Bold = $True
	$Table.Cell(1,3).Range.Text = "Read-only"
	[int]$xRow = 1
	ForEach($DC in $AllDCs)
	{
		$DCName = $DC.SubString(0,$DC.IndexOf("."))
		$SrvName = $DC.SubString($DC.IndexOf(".")+1)
		$xRow++
		$Table.Cell($xRow,1).Range.Text = $DC
		
		$Results = Get-ADDomainController -Identity $DCName -Server $SrvName
		
		If($? -and $Results -ne $Null)
		{
			$Table.Cell($xRow,2).Range.Text = $Results.IsGlobalCatalog
			$Table.Cell($xRow,3).Range.Text = $Results.IsReadOnly
		}
		Else
		{
			$Table.Cell($xRow,2).Range.Text = "Unknown"
			$Table.Cell($xRow,3).Range.Text = "Unknown"
		}
		$Results = $Null
	}
	$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
	$Table.AutoFitBehavior($wdAutoFitContent)

	#return focus back to document
	$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

	#move to the end of the current document
	$selection.EndKey($wdStory,$wdMove) | Out-Null
	$TableRange = $Null
	$Table = $Null
}
$AllDCs = $Null

#Site information
Write-Verbose "$(Get-Date): Writing sites and services data"

$selection.InsertNewPage()
WriteWordLine 1 0 "Site and Services"

#get site information
#some of the following was taken from
#http://blogs.msdn.com/b/adpowershell/archive/2009/08/18/active-directory-powershell-to-manage-sites-and-subnets-part-3-getting-site-and-subnets.aspx

$tmp = $Forest.PartitionsContainer
$ConfigurationBase = $tmp.SubString($tmp.IndexOf(",") + 1)
$Sites = $Null
$Sites = Get-ADObject -Filter 'ObjectClass -eq "site"' -SearchBase $ConfigurationBase -Properties Name, SiteObjectBl -Server $ADForest | Sort Name

$siteContainerDN = ("CN=Sites," + $configNC)

If($? -and $Sites -ne $Null)
{
	WriteWordLine 2 0 "Inter-Site Transports"
	Write-Verbose "$(Get-Date): `tProcessing Inter-Site Transports"
	#adapted from code provided by Jeremy Saunders
	# Report of all site links and related settings
	$AllSiteLinks = Get-ADObject -Searchbase $ConfigNC -Server $ComputerName `
	-Filter 'objectClass -eq "siteLink"' -Property Description, Options, Cost, ReplInterval, SiteList, Schedule `
	| Select-Object Name, Description, @{Name="SiteCount";Expression={$_.SiteList.Count}}, Cost, ReplInterval, `
	@{Name="Schedule";Expression={If($_.Schedule){If(($_.Schedule -Join " ").Contains("240")){"NonDefault"}Else{"24x7"}}Else{"24x7"}}}, `
	Options, SiteList, DistinguishedName
	
	If($? -and $AllSiteLinks -ne $Null)
	{
		ForEach($SiteLink in $AllSiteLinks)
		{
			Write-Verbose "$(Get-Date): `t`tProcessing site link $($SiteLink.Name)"
			$SiteLinkTypeDN = @()
			$SiteLinkTypeDN = $SiteLink.DistinguishedName.Split(",")
			$SiteLinkType = $SiteLinkTypeDN[1].SubString(3)
			$SitesInLink = ""
			$SiteLinkSiteList = $SiteLink.SiteList
			ForEach($xSite in $SiteLinkSiteList)
			{
				$tmp = $xSite.Split(",")
				$SitesInLink += "$($tmp[0].SubString(3))`r"
			}
			
			$TableRange = $doc.Application.Selection.Range
			[int]$Columns = 2
			If([String]::IsNullOrEmpty($SiteLink.Description))
			{
				[int]$Rows = 7
			}
			Else
			{
				[int]$Rows = 8
			}
			[int]$xRow = 0
			$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
			$Table.Style = $Script:MyHash.Word_TableGrid
	
			$Table.rows.first.headingformat = $wdHeadingFormatTrue
			$Table.Borders.InsideLineStyle = $wdLineStyleSingle
			$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
			$xRow++
			$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Name"
			$Table.Cell($xRow,2).Range.Text = $SiteLink.Name
			If(![String]::IsNullOrEmpty($SiteLink.Description))
			{
				$xRow++
				$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
				$Table.Cell($xRow,1).Range.Font.Bold = $True
				$Table.Cell($xRow,1).Range.Text = "Description"
				$Table.Cell($xRow,2).Range.Text = $SiteLink.Description
			}
			$xRow++
			$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Sites in Link"
			If($SitesInLink -ne " ")
			{
				$Table.Cell($xRow,2).Range.Text = $SitesInLink
			}
			Else
			{
				$Table.Cell($xRow,2).Range.Text = "<None>"
			}
			$xRow++
			$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Cost"
			$Table.Cell($xRow,2).Range.Text = $SiteLink.Cost
			$xRow++
			$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Replication Interval"
			$Table.Cell($xRow,2).Range.Text = $SiteLink.ReplInterval
			$xRow++
			$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Schedule"
			$Table.Cell($xRow,2).Range.Text = $SiteLink.Schedule
			$xRow++
			$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Options"
			If([String]::IsNullOrEmpty($SiteLink.Options))
			{
				$Table.Cell($xRow,2).Range.Text = "Change Notification is Disabled"
			}
			ElseIf($SiteLink.Options -eq "1" -or $SiteLink.Options -eq "5")
			{
				$Table.Cell($xRow,2).Range.Text = "Change Notification is Enabled"
			}
			Else
			{
				$Table.Cell($xRow,2).Range.Text = "Unknown"
			}
			$xRow++
			$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Type"
			$Table.Cell($xRow,2).Range.Text = $SiteLinkType
			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
			$Table.AutoFitBehavior($wdAutoFitContent)

			#return focus back to document
			$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

			#move to the end of the current document
			$selection.EndKey($wdStory,$wdMove) | Out-Null
			$TableRange = $Null
			$Table = $Null
			WriteWordLine 0 0 ""
		}
	}
	$AllSiteLinks = $Null
	
	ForEach($Site in $Sites)
	{
		Write-Verbose "$(Get-Date): `tProcessing site $($Site.Name)"
		WriteWordLine 2 0 $Site.Name

		WriteWordLine 3 0 "Subnets"
		Write-Verbose "$(Get-Date): `t`tProcessing subnets"
		$subnetArray = New-Object -Type string[] -ArgumentList $Site.siteObjectBL.Count
		$i = 0
		$SitesiteObjectBL = $Site.siteObjectBL
		foreach ($subnetDN in $SitesiteObjectBL) 
		{
			$subnetName = $subnetDN.SubString(3, $subnetDN.IndexOf(",CN=Subnets,CN=Sites,") - 3)
			$subnetArray[$i] = $subnetName
			$i++
		}
		$subnetArray = $subnetArray | Sort
		If($subnetArray -eq $Null)
		{
			WriteWordLine 0 0 "<None>"
		}
		Else
		{
			BuildMultiColumnTable $subnetArray "Subnets"
		}
		
		Write-Verbose "$(Get-Date): `t`tProcessing servers"
		WriteWordLine 3 0 "Servers"
		$siteName = $Site.Name
		
		#build array of connect objects
		Write-Verbose "$(Get-Date): `t`t`tProcessing automatic connection objects"
		$Connections = @()
		$ConnnectionObjects = $Null
		$ConnectionObjects = Get-ADObject -Filter 'objectClass -eq "nTDSConnection" -and options -bor 1' -Searchbase $ConfigNC -Property DistinguishedName, fromServer -Server $ADForest
		
		If($? -and $ConnectionObjects -ne $Null)
		{
			ForEach($ConnectionObject in $ConnectionObjects)
			{
				$xArray = $ConnectionObject.DistinguishedName.Split(",")
				#server name is 3rd item in array (element 2)
				$ToServer = $xArray[2].SubString($xArray[2].IndexOf("=")+1) #get past the = sign
				$xArray = $ConnectionObject.FromServer.Split(",")
				#server name is 2nd item in array (element 1)
				$FromServer = $xArray[1].SubString($xArray[1].IndexOf("=")+1) #get past the = sign
				#site name is 4th item in array (element 3)
				$FromServerSite = $xArray[3].SubString($xArray[3].IndexOf("=")+1) #get past the = sign
				$xArray = $Null
				$obj = New-Object -TypeName PSObject
				$obj | Add-Member -MemberType NoteProperty -Name Name           -Value "<automatically generated>"
				$obj | Add-Member -MemberType NoteProperty -Name ToServer       -Value $ToServer
				$obj | Add-Member -MemberType NoteProperty -Name FromServer     -Value $FromServer
				$obj | Add-Member -MemberType NoteProperty -Name FromServerSite -Value $FromServerSite
				$Connections += $obj
			}
		}
		
		Write-Verbose "$(Get-Date): `t`t`tProcessing manual connection objects"
		$ConnectionObjects = $Null
		$ConnectionObjects = Get-ADObject -Filter 'objectClass -eq "nTDSConnection" -and -not options -bor 1' -Searchbase $ConfigNC -Property Name, DistinguishedName, fromServer -Server $ADForest
		
		If($? -and $ConnectionObjects -ne $Null)
		{
			ForEach($ConnectionObject in $ConnectionObjects)
			{
				$xArray = $ConnectionObject.DistinguishedName.Split(",")
				#server name is 3rd item in array (element 2)
				$ToServer = $xArray[2].SubString($xArray[2].IndexOf("=")+1) #get past the = sign
				$xArray = $ConnectionObject.FromServer.Split(",")
				#server name is 2nd item in array (element 1)
				$FromServer = $xArray[1].SubString($xArray[1].IndexOf("=")+1) #get past the = sign
				#site name is 4th item in array (element 3)
				$FromServerSite = $xArray[3].SubString($xArray[3].IndexOf("=")+1) #get past the = sign
				$xArray = $Null
				$obj = New-Object -TypeName PSObject
				$obj | Add-Member -MemberType NoteProperty -Name Name           -Value $ConnectionObject.Name
				$obj | Add-Member -MemberType NoteProperty -Name ToServer       -Value $ToServer
				$obj | Add-Member -MemberType NoteProperty -Name FromServer     -Value $FromServer
				$obj | Add-Member -MemberType NoteProperty -Name FromServerSite -Value $FromServerSite
				$Connections += $obj
			}
		}

		If($Connections -ne $Null)
		{
			$Connections = $Connections | Sort Name, ToServer, FromServer
		}
		
		#list each server
		$serverContainerDN = "CN=Servers,CN=" + $siteName + "," + $siteContainerDN
		$SiteServers = $Null
		$SiteServers = Get-ADObject -SearchBase $serverContainerDN -SearchScope OneLevel -Filter { objectClass -eq "Server" } -Properties "DNSHostName" -Server $ADForest | Select DNSHostName, Name | Sort DNSHostName
		
		If($? -and $SiteServers -ne $Null)
		{
			$First = $True
			ForEach($SiteServer in $SiteServers)
			{
				If(!$First)
				{
					WriteWordLine 0 0 ""
				}
				WriteWordLine 0 0 $SiteServer.DNSHostName
				#for each server list each connection object
				If($Connections -ne $Null)
				{
					$Results = $Connections | Where {$_.ToServer -eq $SiteServer.Name}

					If($? -and $Results -ne $Null)
					{
						WriteWordLine 0 1 "Connection Objects to source server $($SiteServer.Name)"
						$TableRange = $doc.Application.Selection.Range
						[int]$Columns = 3
						If($Results -is [array])
						{
							[int]$Rows = $Results.Count + 1
						}
						Else
						{
							[int]$Rows = 2
						}
						[int]$xRow = 1
						$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
						$Table.Style = $Script:MyHash.Word_TableGrid
	
						$Table.rows.first.headingformat = $wdHeadingFormatTrue
						$Table.Borders.InsideLineStyle = $wdLineStyleSingle
						$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
						$Table.Rows.First.Shading.BackgroundPatternColor = $wdColorGray15
						$Table.Cell($xRow,1).Range.Font.Bold = $True
						$Table.Cell($xRow,1).Range.Text = "Name"
						$Table.Cell($xRow,2).Range.Font.Bold = $True
						$Table.Cell($xRow,2).Range.Text = "From Server"
						$Table.Cell($xRow,3).Range.Font.Bold = $True
						$Table.Cell($xRow,3).Range.Text = "From Site"
						ForEach($Result in $Results)
						{
							$xRow++
							$Table.Cell($xRow,1).Range.Text = $Result.Name
							$Table.Cell($xRow,2).Range.Text = $Result.FromServer
							$Table.Cell($xRow,3).Range.Text = $Result.FromServerSite
						}
						$Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustNone)
						$Table.AutoFitBehavior($wdAutoFitContent)

						#return focus back to document
						$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

						#move to the end of the current document
						$selection.EndKey($wdStory,$wdMove) | Out-Null
						$TableRange = $Null
						$Table = $Null
					}
				}
				Else
				{
					WriteWordLine 0 3 "Connection Objects: "
					WriteWordLine 0 4 "<None>"
				}
				$First = $False
			}
		}
		ElseIf(!$?)
		{
			Write-Warning "No Site Servers were retrieved."
			WriteWordLine 0 0 "Warning: No Site Servers were retrieved" "" $Null 0 $False $True
		}
		Else
		{
			WriteWordLine 0 0 "No servers in this site"
		}
	}
}
ElseIf(!$?)
{
	Write-Warning "No Sites were retrieved."
	WriteWordLine 0 0 "Warning: No Sites were retrieved" "" $Null 0 $False $True
}
Else
{
	Write-Warning "There were no sites found to retrieve."
	WriteWordLine 0 0 "There were no sites found to retrieve" "" $Null 0 $False $True
}
$Sites = $Null
$siteContainerDN = $Null
$AllSiteLinks = $Null
$SiteLinkTypeDN = $Null
$SiteLinkType = $Null
$SitesInLink = $Null
$SiteLinkSiteList = $Null
$subnetArray = $Null
$subnetName = $Null
$connections = $Null
$ConnectionObjects = $Null
$SiteName = $Null
$serverContainerDN = $Null
$SiteServers = $Null
$Results = $Null

#domains
Write-Verbose "$(Get-Date): Writing domain data"

$selection.InsertNewPage()
WriteWordLine 1 0 "Domain Information"
$AllDomainControllers = @()
$First = $True
#http://technet.microsoft.com/en-us/library/bb125224(v=exchg.150).aspx
#http://support.microsoft.com/kb/556086/he
$SchemaVersionTable = @{ 
"13" = "Windows 2000"; 
"30" = "Windows 2003 RTM, SP1, SP2"; 
"31" = "Windows 2003 R2";
"44" = "Windows 2008"; 
"47" = "Windows 2008 R2";
"56" = "Windows Server 2012"
"69" = "Windows Server 2012 R2"
"4397" = "Exchange 2000 RTM"; 
"4406" = "Exchange 2000 SP3";
"6870" = "Exchange 2003 RTM, SP1, SP2"; 
"6936" = "Exchange 2003 SP3"; 
"10637" = "Exchange 2007 RTM";
"11116" = "Exchange 2007 SP1"; 
"14622" = "Exchange 2007 SP2, Exchange 2010 RTM";
"14625" = "Exchange 2007 SP3";
"14726" = "Exchange 2010 SP1";
"14732" = "Exchange 2010 SP2";
"14734" = "Exchange 2010 SP3";
"15137" = "Exchange 2013 RTM";
"15254" = "Exchange 2013 CU1";
"15281" = "Exchange 2013 CU2";
"15283" = "Exchange 2013 CU3";
"15292" = "Exchange 2013 SP1"
}

ForEach($Domain in $Domains)
{
	Write-Verbose "$(Get-Date): `tProcessing domain $($Domain)"

	$DomainInfo = Get-ADDomain -Identity $Domain
	
	If($? -and $DomainInfo -ne $Null)
	{
		If(!$First)
		{
			#put each domain, starting with the second, on a new page
			$selection.InsertNewPage()
		}
		
		If($Domain -eq $ForestRootDomain)
		{
			WriteWordLine 2 0 "$($Domain) (Forest Root)"
		}
		Else
		{
			WriteWordLine 2 0 $Domain
		}

		Switch ($DomainInfo.DomainMode)
		{
			"0"	{$DomainMode = "Windows 2000"}
			"1" {$DomainMode = "Windows Server 2003 mixed"}
			"2" {$DomainMode = "Windows Server 2003"}
			"3" {$DomainMode = "Windows Server 2008"}
			"4" {$DomainMode = "Windows Server 2008 R2"}
			"5" {$DomainMode = "Windows Server 2012"}
			"6" {$DomainMode = "Windows Server 2012 R2"}
			"Windows2000Domain"   {$DomainMode = "Windows 2000"}
			"Windows2003Mixed"    {$DomainMode = "Windows Server 2003 mixed"}
			"Windows2003Domain"   {$DomainMode = "Windows Server 2003"}
			"Windows2008Domain"   {$DomainMode = "Windows Server 2008"}
			"Windows2008R2Domain" {$DomainMode = "Windows Server 2008 R2"}
			"Windows2012Domain"   {$DomainMode = "Windows Server 2012"}
			"Windows2012R2Domain" {$DomainMode = "Windows Server 2012 R2"}
			"UnknownDomain"       {$DomainMode = "Unknown Domain Mode"}
			Default               {$DomainMode = "Unable to determine Domain Mode: $($ADDomain.DomainMode)"}
		}
		
		#http://blogs.technet.com/b/poshchap/archive/2014/03/07/ad-schema-version.aspx
		$ADSchemaInfo = $Null
		$ExchangeSchemaInfo = $Null
		
		$ADSchemaInfo = Get-ADObject (Get-ADRootDSE -Server $Domain).schemaNamingContext -Property objectVersion -Server $Domain
		
		If($? -and $ADSchemaInfo -ne $Null)
		{
			$ADSchemaVersion = $ADSchemaInfo.objectversion
			$ADSchemaVersionName = $SchemaVersionTable.Get_Item("$ADSchemaVersion")
			If($ADSchemaVersionName -eq $Null)
			{
				$ADSchemaVersionName = "Unknown"
			}
		}
		Else
		{
			$ADSchemaVersion = "Unknown"
			$ADSchemaVersionName = "Unknown"
		}
		
		If($Domain -eq $ForestRootDomain)
		{
			$ExchangeSchemaInfo = Get-ADObject "cn=ms-exch-schema-version-pt,cn=Schema,cn=Configuration,$($DomainInfo.DistinguishedName)" -properties rangeupper -Server $Domain

			If($? -and $ExchangeSchemaInfo -ne $Null)
			{
				$ExchangeSchemaVersion = $ExchangeSchemaInfo.rangeupper
				$ExchangeSchemaVersionName = $SchemaVersionTable.Get_Item("$ExchangeSchemaVersion")
				If($ExchangeSchemaVersionName -eq $Null)
				{
					$ExchangeSchemaVersionName = "Unknown"
				}
			}
			Else
			{
				$ExchangeSchemaVersion = "Unknown"
				$ExchangeSchemaVersionName = "Unknown"
			}
		}
		
		$TableRange = $doc.Application.Selection.Range
		[int]$Columns = 2
		[int]$Rows = 22
		If(![String]::IsNullOrEmpty($DomainInfo.ManagedBy))
		{
			$Rows++
		}
		
		If(![String]::IsNullOrEmpty($ExchangeSchemaInfo))
		{
			$Rows++
		}
		
		$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
		$Table.AutoFitBehavior($wdAutoFitFixed)	
		$Table.Style = $Script:MyHash.Word_TableGrid
	
		$Table.Borders.InsideLineStyle = $wdLineStyleSingle
		$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
		
		[int]$xRow = 1
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Domain mode"
		$Table.Cell($xRow,2).Range.Text = $DomainMode

		$xRow++
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Domain name"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.Name

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "NetBIOS name"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.NetBIOSName

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "DNS root"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.DNSRoot

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Distinguished name"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.DistinguishedName

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Infrastructure master"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.InfrastructureMaster

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "PDC Emulator"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.PDCEmulator

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "RID Master"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.RIDMaster

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Default computers container"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.ComputersContainer

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Default users container"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.UsersContainer

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Deleted objects container"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.DeletedObjectsContainer

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Domain controllers container"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.DomainControllersContainer

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Foreign security principals container"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.ForeignSecurityPrincipalsContainer

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Lost and Found container"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.LostAndFoundContainer

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Quotas container"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.QuotasContainer

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Systems container"
		$Table.Cell($xRow,2).Range.Text = $DomainInfo.SystemsContainer

		$xRow++		
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "AD Schema"
		$Table.Cell($xRow,2).Range.Text = "($($ADSchemaVersion)) - $($ADSchemaVersionName)"
		
		If(![String]::IsNullOrEmpty($ExchangeSchemaInfo))
		{
			$xRow++		
			$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Exchange Schema"
			$Table.Cell($xRow,2).Range.Text = "($($ExchangeSchemaVersion)) - $($ExchangeSchemaVersionName)"
		}
		
		If(![String]::IsNullOrEmpty($DomainInfo.ManagedBy))
		{
			$xRow++
			$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Managed by"
			$Table.Cell($xRow,2).Range.Text = $DomainInfo.ManagedBy
		}

		Write-Verbose "$(Get-Date): `t`tGetting Allowed DNS Suffixes"
		$xRow++
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Allowed DNS Suffixes"
		$DNSSuffixes = $DomainInfo.AllowedDNSSuffixes | Sort
		If($DNSSuffixes -eq $Null)
		{
			$Table.Cell($xRow,2).Range.Text = "<None>"
		}
		Else
		{
			$tmp = @()
			ForEach($DNSSuffix in $DNSSuffixes)
			{
				$tmp += "$($DNSSuffix)`r"
			}
			$Table.Cell($xRow,2).Range.Text = $tmp
		}
		$DNSSuffixes = $Null
		$tmp = $Null

		Write-Verbose "$(Get-Date): `t`tGetting Child domains"
		$xRow++
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Child domains"
		$ChildDomains = $DomainInfo.ChildDomains | Sort
		If($ChildDomains -eq $Null)
		{
			$Table.Cell($xRow,2).Range.Text = "<None>"
		}
		Else
		{
			$tmp = @()
			ForEach($ChildDomain in $ChildDomains)
			{
				$tmp += "$($ChildDomain)`r"
			}
			$Table.Cell($xRow,2).Range.Text = $tmp
		}
		$ChildDOmains = $Null
		$tmp = $Null

		Write-Verbose "$(Get-Date): `t`tGetting Read-only replica directory servers"
		$xRow++
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Read-only replica directory servers"
		$ReadOnlyReplicas = $DomainInfo.ReadOnlyReplicaDirectoryServers | Sort
		If($ReadOnlyReplicas -eq $Null)
		{
			$Table.Cell($xRow,2).Range.Text = "<None>"
		}
		Else
		{
			$tmp = @()
			ForEach($ReadOnlyReplica in $ReadOnlyReplicas)
			{
				$tmp += "$($ReadOnlyReplica)`r"
			}
			$Table.Cell($xRow,2).Range.Text = $tmp
		}
		$ReadOnlyReplicas = $Null
		$tmp = $Null

		Write-Verbose "$(Get-Date): `t`tGetting Replica directory servers"
		$xRow++
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Replica directory servers"
		$Replicas = $DomainInfo.ReplicaDirectoryServers | Sort
		If($Replicas -eq $Null)
		{
			$Table.Cell($xRow,2).Range.Text = "<None>"
		}
		Else
		{
			$tmp = @()
			ForEach($Replica in $Replicas)
			{
				$tmp += "$($Replica)`r"
			}
			$Table.Cell($xRow,2).Range.Text = $tmp
		}
		$Replicas = $Null
		$tmp = $Null

		Write-Verbose "$(Get-Date): `t`tGetting Subordinate references"
		$xRow++
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Subordinate references"
		$SubordinateReferences = $DomainInfo.SubordinateReferences | Sort
		If($SubordinateReferences -eq $Null)
		{
			$Table.Cell($xRow,2).Range.Text = "<None>"
		}
		Else
		{
			$tmp = @()
			ForEach($SubordinateReference in $SubordinateReferences)
			{
				$tmp += "$($SubordinateReference)`r"
			}
			$Table.Cell($xRow,2).Range.Text = $tmp
		}
		$SubordinateReferences = $Null
		$tmp = $Null
		
		#set column widths
		$xcols = $table.columns

		ForEach($xcol in $xcols)
		{
		    switch ($xcol.Index)
		    {
			  1 {$xcol.width = 175}
			  2 {$xcol.width = 300}
		    }
		}
		
		$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
		$Table.AutoFitBehavior($wdAutoFitFixed)	

		#return focus back to document
		$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

		#move to the end of the current document
		$selection.EndKey($wdStory,$wdMove) | Out-Null
		$TableRange = $Null
		$Table = $Null

		Write-Verbose "$(Get-Date): `t`tGetting domain trusts"
		WriteWordLine 3 0 "Domain trusts"
		
		$ADDomainTrusts = $Null
		$ADDomainTrusts = Get-ADObject -Filter {ObjectClass -eq "trustedDomain"} -Server $Domain -Properties *

		If($? -and $ADDomainTrusts -ne $Null)
		{
			
			ForEach($Trust in $ADDomainTrusts) 
			{ 
				$TableRange = $doc.Application.Selection.Range
				[int]$Columns = 2
				If([String]::IsNullOrEmpty($Trust.Description))
				{
					[int]$Rows = 6
				}
				Else
				{
					[int]$Rows = 7
				}
				[int]$xRow = 0
				$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
				$Table.Style = $Script:MyHash.Word_TableGrid
	
				$Table.Borders.InsideLineStyle = $wdLineStyleSingle
				$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
				$xRow++
				$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
				$Table.Cell($xRow,1).Range.Font.Bold = $True
				$Table.Cell($xRow,1).Range.Text = "Name"
				$Table.Cell($xRow,2).Range.Text = $Trust.Name 
				
				If(![String]::IsNullOrEmpty($Trust.Description))
				{
					$xRow++
					$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
					$Table.Cell($xRow,1).Range.Font.Bold = $True
					$Table.Cell($xRow,1).Range.Text = "Description"
					$Table.Cell($xRow,2).Range.Text = $Trust.Description
				}
				
				$xRow++
				$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
				$Table.Cell($xRow,1).Range.Font.Bold = $True
				$Table.Cell($xRow,1).Range.Text = "Created"
				$Table.Cell($xRow,2).Range.Text = $Trust.Created
				
				$xRow++
				$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
				$Table.Cell($xRow,1).Range.Font.Bold = $True
				$Table.Cell($xRow,1).Range.Text = "Modified"
				$Table.Cell($xRow,2).Range.Text = $Trust.Modified

				$TrustDirectionNumber = $Trust.TrustDirection
				$TrustTypeNumber = $Trust.TrustType
				$TrustAttributesNumber = $Trust.TrustAttributes

				#http://msdn.microsoft.com/en-us/library/cc234293.aspx
				Switch ($TrustTypeNumber) 
				{ 
					1 { $TrustType = "Trust with a Windows domain not running Active Directory"} 
					2 { $TrustType = "Trust with a Windows domain running Active Directory"} 
					3 { $TrustType = "Trust with a non-Windows-compliant Kerberos distribution"} 
					4 { $TrustType = "Trust with a DCE realm (not used)"} 
					Default { $TrustType = "Invalid Trust Type of $($TrustTypeNumber)" }
				} 
				$xRow++
				$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
				$Table.Cell($xRow,1).Range.Font.Bold = $True
				$Table.Cell($xRow,1).Range.Text = "Type"
				If($TrustTypeNumber -lt 1 -or $TrustTypeNumber -gt 4)
				{
					$Table.Cell($xRow,2).Shading.BackgroundPatternColor = $wdColorRed
					$Table.Cell($xRow,2).Range.Font.Bold  = $True
					$Table.Cell($xRow,2).Range.Font.Color = $WDColorBlack
				}
				$Table.Cell($xRow,2).Range.Text = $TrustType

				#http://msdn.microsoft.com/en-us/library/cc223779.aspx
				#thanks to fellow CTP Jeremy Saunders for the following switch stmt for trustAttributes
				#I adapted his code
				$attributes = @()
				$hextrustAttributesValue = '{0:X}' -f $trustAttributesNumber
				Switch ($hextrustAttributesValue)
				{
					{($hextrustAttributesValue -bor 0x00000001) -eq $hextrustAttributesValue} 
						{$attributes += "Non-Transitive"}
					
					{($hextrustAttributesValue -bor 0x00000002) -eq $hextrustAttributesValue} 
						{$attributes += "Uplevel clients only"}
					
					{($hextrustAttributesValue -bor 0x00000004) -eq $hextrustAttributesValue} 
						{$attributes += "Quarantined Domain (External, SID Filtering)"}
					
					{($hextrustAttributesValue -bor 0x00000008) -eq $hextrustAttributesValue} 
						{$attributes += "Cross-Organizational Trust (Selective Authentication)"}
					
					{($hextrustAttributesValue -bor 0x00000010) -eq $hextrustAttributesValue} 
						{$attributes += "Intra-Forest Trust"}
					
					{($hextrustAttributesValue -bor 0x00000020) -eq $hextrustAttributesValue} 
						{$attributes += "Inter-Forest Trust"}
					
					{($hextrustAttributesValue -bor 0x00000040) -eq $hextrustAttributesValue} 
						{$attributes += "MIT Trust using RC4 Encryption"}
					
					{($hextrustAttributesValue -bor 0x00000200) -eq $hextrustAttributesValue} 
						{$attributes += "Cross organization Trust no TGT delegation"}
				}

				$xRow++
				$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
				$Table.Cell($xRow,1).Range.Font.Bold = $True
				$Table.Cell($xRow,1).Range.Text = "Attributes"
				$tmp = @()
				ForEach($attribute in $attributes)
				{
					$tmp += "$($attribute)`r"
				}
				$Table.Cell($xRow,2).Range.Text = $tmp

				#http://msdn.microsoft.com/en-us/library/cc223768.aspx
				Switch ($TrustDirectionNumber) 
				{ 
					0 { $TrustDirection = "Disabled"} 
					1 { $TrustDirection = "Inbound"} 
					2 { $TrustDirection = "Outbound"} 
					3 { $TrustDirection = "Bidirectional"} 
					Default { $TrustDirection = $TrustDirectionNumber }
				}
				$xRow++
				$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
				$Table.Cell($xRow,1).Range.Font.Bold = $True
				$Table.Cell($xRow,1).Range.Text = "Direction"
				$Table.Cell($xRow,2).Range.Text = $TrustDirection
				
				$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
				$Table.AutoFitBehavior($wdAutoFitContent)

				#return focus back to document
				$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

				#move to the end of the current document
				$selection.EndKey($wdStory,$wdMove) | Out-Null
				$TableRange = $Null
				$Table = $Null
				WriteWordLine 0 0 ""
			}
		}
		ElseIf(!$?)
		{
			#error retrieving domain trusts
			Write-Warning "Error retrieving domain trusts for $($Domain)"
			WriteWordLine 0 0 "Error retrieving domain trusts for $($Domain)" "" $Null 0 $False $True
		}
		Else
		{
			#no domain trust data
			WriteWordLine 0 0 "<None>"
		}

		Write-Verbose "$(Get-Date): `t`tProcessing domain controllers"
		$DomainControllers = $Null
		$DomainControllers = Get-ADDomainController -Filter * -Server $DomainInfo.DNSRoot | Sort Name
		
		If($? -and $DomainControllers -ne $Null)
		{
			$AllDomainControllers += $DomainControllers
			WriteWordLine 3 0 "Domain Controllers"
			$TableRange = $doc.Application.Selection.Range
			[int]$Columns = 1
			If($DomainControllers -is [array])
			{
				[int]$Rows = $DomainControllers.Count
			}
			Else
			{
				[int]$Rows = 1
			}
			$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
			$Table.AutoFitBehavior($wdAutoFitFixed)
			$Table.Style = $Script:MyHash.Word_TableGrid
	
			$Table.Borders.InsideLineStyle = $wdLineStyleSingle
			$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
			[int]$xRow = 0
			ForEach($DomainController in $DomainControllers)
			{
				$xRow++
				$Table.Cell($xRow,1).Range.Text = $DomainController.Name
			}
			#set column widths
			$xcols = $table.columns

			ForEach($xcol in $xcols)
			{
			    switch ($xcol.Index)
			    {
				  1 {$xcol.width = 100}
			    }
			}

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
			$Table.AutoFitBehavior($wdAutoFitFixed)

			#return focus back to document
			$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

			#move to the end of the current document
			$selection.EndKey($wdStory,$wdMove) | Out-Null
			$TableRange = $Null
			$Table = $Null
		}
		ElseIf(!$?)
		{
			Write-Warning "Error retrieving domain controller data for domain $($Domain)"
			WriteWordLine 0 0 "Error retrieving domain controller data for domain $($Domain)" "" $Null 0 $False $True
		}
		Else
		{
			WriteWordLine 0 0 "No Domain controller data was retrieved for domain $($Domain)" "" $Null 0 $False $True
		}
		
		$DomainControllers = $Null
		$LinkedGPOs = $Null
		$SubordinateReferences = $Null
		$Replicas = $Null
		$ReadOnlyReplicas = $Null
		$ChildDomains = $Null
		$DNSSuffixes = $Null
		$First = $False
	}
	ElseIf(!$?)
	{
		Write-Warning "Error retrieving domain data for domain $($Domain)."
		WriteWordLine 0 0 "Error retrieving domain data for domain $($Domain)" "" $Null 0 $False $True
	}
	Else
	{
		WriteWordLine 0 0 "No Domain data was retrieved for domain $($Domain)" "" $Null 0 $False $True
	}
}
$DomainControllers = $Null
$LinkedGPOs = $Null
$SubordinateReferences = $Null
$Replicas = $Null
$ReadOnlyReplicas = $Null
$ChildDomains = $Null
$DNSSuffixes = $Null
$First = $False
$SchemaVersionTable = $Null
$DomainInfo = $Null
$ADSchemaInfo = $Null
$ExchangeSchemaInfo = $Null
$ADDomainTrusts = $Null
$attributes = $Null

#domain controllers
Write-Verbose "$(Get-Date): Writing domain controller data"

$selection.InsertNewPage()
WriteWordLine 1 0 "Domain Controllers in $($ForestName)"
$AllDomainControllers = $AllDomainControllers | Sort Name
$First = $True

ForEach($DC in $AllDomainControllers)
{
	Write-Verbose "$(Get-Date): `tProcessing domain controller $($DC.name)"
	
	If(!$First)
	{
		#put each DC, starting with the second, on a new page
		$selection.InsertNewPage()
	}
	
	WriteWordLine 2 0 $DC.Name
	$TableRange = $doc.Application.Selection.Range
	[int]$Columns = 2
	If(!$Hardware)
	{
		[int]$Rows = 16
	}
	Else
	{
		[int]$Rows = 14
	}
	$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
	$Table.AutoFitBehavior($wdAutoFitFixed)
	$Table.Style = $Script:MyHash.Word_TableGrid
	
	$Table.Borders.InsideLineStyle = $wdLineStyleSingle
	$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
	$xRow = 1
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Default partition"
	$Table.Cell($xRow,2).Range.Text = $DC.DefaultPartition
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Domain"
	$Table.Cell($xRow,2).Range.Text = $DC.domain
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Enabled"
	If($DC.Enabled -eq $True)
	{
		$Table.Cell($xRow,2).Range.Text = "True"
	}
	Else
	{
		$Table.Cell($xRow,2).Range.Text = "False"
	}
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Hostname"
	$Table.Cell($xRow,2).Range.Text = $DC.HostName
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Global Catalog"
	If($DC.IsGlobalCatalog -eq $True)
	{
		$Table.Cell($xRow,2).Range.Text = "Yes" 
	}
	Else
	{
		$Table.Cell($xRow,2).Range.Text = "No"
	}
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Read-only"
	If($DC.IsReadOnly -eq $True)
	{
		$Table.Cell($xRow,2).Range.Text = "Yes"
	}
	Else
	{
		$Table.Cell($xRow,2).Range.Text = "No"
	}
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "LDAP port"
	$Table.Cell($xRow,2).Range.Text = $DC.LdapPort
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "SSL port"
	$Table.Cell($xRow,2).Range.Text = $DC.SslPort
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Operation Master roles"
	$FSMORoles = $DC.OperationMasterRoles | Sort
	If($FSMORoles -eq $Null)
	{
		$Table.Cell($xRow,2).Range.Text = "<None>"
	}
	Else
	{
		$tmp = ""
		ForEach($FSMORole in $FSMORoles)
		{
			$tmp += ($FSMORole.ToString() + "`n")
		}
		$Table.Cell($xRow,2).Range.Text = $tmp
	}
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Partitions"
	$Partitions = $DC.Partitions | Sort
	If($Partitions -eq $Null)
	{
		$Table.Cell($xRow,2).Range.Text = "<None>"
	}
	Else
	{
		$tmp = ""
		ForEach($Partition in $Partitions)
		{
			$tmp += ($Partition + "`n")
		}
		$Table.Cell($xRow,2).Range.Text = $tmp
	}
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Site"
	$Table.Cell($xRow,2).Range.Text = $DC.Site

	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Operating System"
	$Table.Cell($xRow,2).Range.Text = $DC.OperatingSystem
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Service Pack"
	$Table.Cell($xRow,2).Range.Text = $DC.OperatingSystemServicePack
	
	$xRow++
	$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
	$Table.Cell($xRow,1).Range.Font.Bold = $True
	$Table.Cell($xRow,1).Range.Text = "Operating System version"
	$Table.Cell($xRow,2).Range.Text = $DC.OperatingSystemVersion
	
	If(!$Hardware)
	{
		
		$xRow++
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "IPv4 Address"
		If([String]::IsNullOrEmpty($DC.IPv4Address))
		{
			$Table.Cell($xRow,2).Range.Text = "<None>"
		}
		Else
		{
			$Table.Cell($xRow,2).Range.Text = $DC.IPv4Address
		}
		
		$xRow++
		$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "IPv6 Address"
		If([String]::IsNullOrEmpty($DC.IPv6Address))
		{
			$Table.Cell($xRow,2).Range.Text = "<None>"
		}
		Else
		{
			$Table.Cell($xRow,2).Range.Text = $DC.IPv6Address
		}
	}
	
	#set column widths
	$xcols = $table.columns

	ForEach($xcol in $xcols)
	{
	    switch ($xcol.Index)
	    {
		  1 {$xcol.width = 140}
		  2 {$xcol.width = 300}
	    }
	}

	$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
	$Table.AutoFitBehavior($wdAutoFitFixed)

	#return focus back to document
	$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

	#move to the end of the current document
	$selection.EndKey($wdStory,$wdMove) | Out-Null
	$TableRange = $Null
	$Table = $Null
	
	If($Hardware -or $Services)
	{
		If(Test-Connection -ComputerName $DC.name -quiet -EA 0)
		{
			If($Hardware)
			{
				GetComputerWMIInfo $DC.Name
			}
			
			If($Services)
			{
				GetComputerServices $DC.Name
			}
		}
		Else
		{
			Write-Verbose "$(Get-Date): `t`t$($DC.Name) is offline or unreachable.  Hardware inventory is skipped."
			WriteWordLine 0 0 "Server $($DC.Name) was offline or unreachable at "(get-date).ToString()
			If($Hardware -and -not $Services)
			{
				WriteWordLine 0 0 "Hardware inventory was skipped."
			}
			ElseIf($Services -and -not $Hardware)
			{
				WriteWordLine 0 0 "Services was skipped."
			}
			ElseIf($Hardware -and $Services)
			{
				WriteWordLine 0 0 "Hardware inventory and Services were skipped."
			}
		}
	}
	$First = $False
}
$AllDomainControllers = $Null

#organizational units
Write-Verbose "$(Get-Date): Writing OU data by Domain"
$selection.InsertNewPage()
WriteWordLine 1 0 "Organizational Units"
$First = $True

ForEach($Domain in $Domains)
{
	Write-Verbose "$(Get-Date): `tProcessing domain $($Domain)"
	If(!$First)
	{
		#put each domain, starting with the second, on a new page
		$selection.InsertNewPage()
	}
	If($Domain -eq $ForestRootDomain)
	{
		WriteWordLine 2 0 "OUs in Domain $($Domain) (Forest Root)"
	}
	Else
	{
		WriteWordLine 2 0 "OUs in Domain $($Domain)"
	}
	#get all OUs for the domain
	$OUs = $Null
	$OUs = Get-ADOrganizationalUnit -Filter * -Server $Domain `
	-Properties CanonicalName, DistinguishedName, Name, Created, ProtectedFromAccidentalDeletion | `
	Select CanonicalName, DistinguishedName, Name, Created, ProtectedFromAccidentalDeletion | `
	Sort CanonicalName
	
	If($? -and $OUs -ne $Null)
	{
		$TableRange = $doc.Application.Selection.Range
		[int]$Columns = 6
		If($OUs -is [array])
		{
			[int]$Rows = $OUs.Count + 1
			[int]$NumOUs = $OUs.Count
		}
		Else
		{
			[int]$Rows = 2
			[int]$NumOUs = 1
		}
		[int]$xRow = 1
		[int]$OUCount = 0

		$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
		$Table.AutoFitBehavior($wdAutoFitFixed)
		$Table.Style = $Script:MyHash.Word_TableGrid
	
		$Table.rows.first.headingformat = $wdHeadingFormatTrue
		$Table.Borders.InsideLineStyle = $wdLineStyleSingle
		$Table.Borders.OutsideLineStyle = $wdLineStyleSingle

		$Table.Rows.First.Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell($xRow,1).Range.Font.Bold = $True
		$Table.Cell($xRow,1).Range.Text = "Name"
		
		$Table.Cell($xRow,2).Range.Font.Bold = $True
		$Table.Cell($xRow,2).Range.Text = "Created"
		
		$Table.Cell($xRow,3).Range.Font.Bold = $True
		$Table.Cell($xRow,3).Range.Text = "Protected"
		
		$Table.Cell($xRow,4).Range.Font.Bold = $True
		$Table.Cell($xRow,4).Range.Text = "# Users"
		
		$Table.Cell($xRow,5).Range.Font.Bold = $True
		$Table.Cell($xRow,5).Range.Text = "# Computers"
		
		$Table.Cell($xRow,6).Range.Font.Bold = $True
		$Table.Cell($xRow,6).Range.Text = "# Groups"

		ForEach($OU in $OUs)
		{
			$xRow++
			$OUCount++
			If($xRow % 2 -eq 0)
			{
				$Table.Cell($xRow,1).Shading.BackgroundPatternColor = $wdColorGray05
				$Table.Cell($xRow,2).Shading.BackgroundPatternColor = $wdColorGray05
				$Table.Cell($xRow,3).Shading.BackgroundPatternColor = $wdColorGray05
				$Table.Cell($xRow,4).Shading.BackgroundPatternColor = $wdColorGray05
				$Table.Cell($xRow,5).Shading.BackgroundPatternColor = $wdColorGray05
				$Table.Cell($xRow,6).Shading.BackgroundPatternColor = $wdColorGray05
			}
			$OUDisplayName = $OU.CanonicalName.SubString($OU.CanonicalName.IndexOf("/")+1)
			Write-Verbose "$(Get-Date): `t`tProcessing OU $($OU.CanonicalName) - OU # $OUCount of $NumOUs"
			
			#get counts of users, computers and groups in the OU
			Write-Verbose "$(Get-Date): `t`t`tGetting user count"
			
			[int]$UserCount = 0
			[int]$ComputerCount = 0
			[int]$GroupCount = 0
			
			$Results = Get-ADUser -Filter * -SearchBase $OU.DistinguishedName -Server $Domain
			If($Results -eq $Null)
			{
				$UserCount = 0
			}
			ElseIf($Results -is [array])
			{
				$UserCount = $Results.Count
			}
			Else
			{
				$UserCount = 1
			}
			Write-Verbose "$(Get-Date): `t`t`tGetting computer count"
			$Results = Get-ADComputer -Filter * -SearchBase $OU.DistinguishedName -Server $Domain
			If($Results -eq $Null)
			{
				$ComputerCount = 0
			}
			ElseIf($Results -is [array])
			{
				$ComputerCount = $Results.Count
			}
			Else
			{
				$ComputerCount = 1
			}
			Write-Verbose "$(Get-Date): `t`t`tGetting group count"
			$Results = Get-ADGroup -Filter * -SearchBase $OU.DistinguishedName -Server $Domain
			If($Results -eq $Null)
			{
				$GroupCount = 0
			}
			ElseIf($Results -is [array])
			{
				$GroupCount = $Results.Count
			}
			Else
			{
				$GroupCount = 1
			}
			
			Write-Verbose "$(Get-Date): `t`t`tPopulating table row"
			$Table.Cell($xRow,1).Range.Text = $OUDisplayName
			$Table.Cell($xRow,2).Range.Text = $OU.Created
			If($OU.ProtectedFromAccidentalDeletion -eq $True)
			{
				$Table.Cell($xRow,3).Range.Text = "Yes"
			}
			Else
			{
				$Table.Cell($xRow,3).Range.Text = "No"
			}
			
			[string]$UserCountStr = "{0,7:N0}" -f $UserCount
			[string]$ComputerCountStr = "{0,7:N0}" -f $ComputerCount
			[string]$GroupCountStr = "{0,7:N0}" -f $GroupCount

			$Table.Cell($xRow,4).Range.ParagraphFormat.Alignment = $wdCellAlignVerticalTop
			$Table.Cell($xRow,4).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
			$Table.Cell($xRow,4).Range.Text = $UserCountStr
			$Table.Cell($xRow,5).Range.ParagraphFormat.Alignment = $wdCellAlignVerticalTop
			$Table.Cell($xRow,5).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
			$Table.Cell($xRow,5).Range.Text = $ComputerCountStr
			$Table.Cell($xRow,6).Range.ParagraphFormat.Alignment = $wdCellAlignVerticalTop
			$Table.Cell($xRow,6).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
			$Table.Cell($xRow,6).Range.Text = $GroupCountStr
			$Results = $Null
			$UserCountStr = $Null
			$ComputerCountStr = $Null
			$GroupCountStr = $Null
		}
		
		#set column widths
		$xcols = $table.columns

		ForEach($xcol in $xcols)
		{
		    switch ($xcol.Index)
		    {
			  1 {$xcol.width = 214}
			  2 {$xcol.width = 68}
			  3 {$xcol.width = 56}
			  4 {$xcol.width = 56}
			  5 {$xcol.width = 70}
			  6 {$xcol.width = 56}
		    }
		}
		
		$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
		$Table.AutoFitBehavior($wdAutoFitFixed)

		#return focus back to document
		$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

		#move to the end of the current document
		$selection.EndKey($wdStory,$wdMove) | Out-Null
		$TableRange = $Null
		$Table = $Null
		$Results = $Null
		$UserCountStr = $Null
		$ComputerCountStr = $Null
		$GroupCountStr = $Null
	}
	ElseIf(!$?)
	{
		Write-Warning "Error retrieving OU data for domain $($Domain)"
		WriteWordLine 0 0 "Error retrieving OU data for domain $($Domain)" "" $Null 0 $False $True
	}
	Else
	{
		WriteWordLine 0 0 "No OU data was retrieved for domain $($Domain)" "" $Null 0 $False $True
	}
	$First = $False
}
$OUs = $Null
$OUDisplayName = $Null
$Results = $Null
$UserCountStr = $Null
$ComputerCountStr = $Null
$GroupCountStr = $Null

#Group information
Write-Verbose "$(Get-Date): Writing group data"

$selection.InsertNewPage()
WriteWordLine 1 0 "Groups"
$First = $True

ForEach($Domain in $Domains)
{
	Write-Verbose "$(Get-Date): `tProcessing groups in domain $($Domain)"
	If(!$First)
	{
		#put each domain, starting with the second, on a new page
		$selection.InsertNewPage()
	}
	If($Domain -eq $ForestRootDomain)
	{
		WriteWordLine 2 0 "Domain $($Domain) (Forest Root)"
	}
	Else
	{
		WriteWordLine 2 0 "Domain $($Domain)"
	}

	#get all Groups for the domain
	$Groups = $Null
	$Groups = Get-ADGroup -Filter * -Server $Domain -Properties Name, GroupCategory, GroupType | Sort Name

	If($? -and $Groups -ne $Null)
	{
		#get counts
		
		Write-Verbose "$(Get-Date): `t`tGetting counts"
		
		[int]$SecurityCount = 0
		[int]$DistributionCount = 0
		[int]$GlobalCount = 0
		[int]$UniversalCount = 0
		[int]$DomainLocalCount = 0
		[int]$ContactsCount = 0
		[int]$GroupsWithSIDHistory = 0
		
		Write-Verbose "$(Get-Date): `t`t`tSecurity Groups"
		$Results = $groups | Where {$_.groupcategory -eq "Security"}
		
		If($Results -eq $Null)
		{
			[int]$SecurityCount = 0
		}
		ElseIf($Results -is [array])
		{
			[int]$SecurityCount = $Results.Count
		}
		Else
		{
			[int]$SecurityCount = 1
		}
		
		Write-Verbose "$(Get-Date): `t`t`tDistribution Groups"
		$Results = $groups | Where {$_.groupcategory -eq "Distribution"}
		
		If($Results -eq $Null)
		{
			[int]$DistributionCount = 0
		}
		ElseIf($Results -is [array])
		{
			[int]$DistributionCount = $Results.Count
		}
		Else
		{
			[int]$DistributionCount = 1
		}

		Write-Verbose "$(Get-Date): `t`t`tGlobal Groups"
		$Results = $groups | Where {$_.groupscope -eq "Global"}

		If($Results -eq $Null)
		{
			[int]$GlobalCount = 0
		}
		ElseIf($Results -is [array])
		{
			[int]$GlobalCount = $Results.Count
		}
		Else
		{
			[int]$GlobalCount = 1
		}

		Write-Verbose "$(Get-Date): `t`t`tUniversal Groups"
		$Results = $groups | Where {$_.groupscope -eq "Universal"}

		If($Results -eq $Null)
		{
			[int]$UniversalCount = 0
		}
		ElseIf($Results -is [array])
		{
			[int]$UniversalCount = $Results.Count
		}
		Else
		{
			[int]$UniversalCount = 1
		}
		
		Write-Verbose "$(Get-Date): `t`t`tDomain Local Groups"
		$Results = $groups | Where {$_.groupscope -eq "DomainLocal"}

		If($Results -eq $Null)
		{
			[int]$DomainLocalCount = 0
		}
		ElseIf($Results -is [array])
		{
			[int]$DomainLocalCount = $Results.Count
		}
		Else
		{
			[int]$DomainLocalCount = 1
		}

		Write-Verbose "$(Get-Date): `t`t`tGroups with SID History"
		$Results = $Null
		$Results = Get-ADObject -LDAPFilter "(sIDHistory=*)" -Server $Domain -Property objectClass, sIDHistory

		If($Results -eq $Null)
		{
			[int]$GroupsWithSIDHistory = 0
		}
		ElseIf($Results -is [array])
		{
			[int]$GroupsWithSIDHistory = ($Results | Where {$_.objectClass -eq 'group'}).Count
		}
		Else
		{
			[int]$GroupsWithSIDHistory = 1
		}

		Write-Verbose "$(Get-Date): `t`t`tContacts"
		$Results = $Null
		$Results = Get-ADObject -LDAPFilter "objectClass=Contact" -Server $Domain

		If($Results -eq $Null)
		{
			[int]$ContactsCount = 0
		}
		ElseIf($Results -is [array])
		{
			[int]$ContactsCount = $Results.Count
		}
		Else
		{
			[int]$ContactsCount = 1
		}

		[string]$TotalCountStr = "{0,7:N0}" -f ($SecurityCount + $DistributionCount)
		[string]$SecurityCountStr = "{0,7:N0}" -f $SecurityCount
		[string]$DomainLocalCountStr = "{0,7:N0}" -f $DomainLocalCount
		[string]$GlobalCountStr = "{0,7:N0}" -f $GlobalCount
		[string]$UniversalCountStr = "{0,7:N0}" -f $UniversalCount
		[string]$DistributionCountStr = "{0,7:N0}" -f $DistributionCount
		[string]$GroupsWithSIDHistoryStr = "{0,7:N0}" -f $GroupsWithSIDHistory
		[string]$ContactsCountStr = "{0,7:N0}" -f $ContactsCount
		
		Write-Verbose "$(Get-Date): `t`tBuild groups table"
		$TableRange = $doc.Application.Selection.Range
		[int]$Columns = 2
		[int]$Rows = 8
		$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
		$Table.Style = $Script:MyHash.Word_TableGrid
	
		$Table.Borders.InsideLineStyle = $wdLineStyleSingle
		$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
		$Table.Cell(1,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(1,1).Range.Font.Bold = $True
		$Table.Cell(1,1).Range.Text = "Total Groups"
		$Table.Cell(1,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(1,2).Range.Text = $TotalCountStr
		$Table.Cell(2,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(2,1).Range.Font.Bold = $True
		$Table.Cell(2,1).Range.Text = "`tSecurity Groups"
		$Table.Cell(2,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(2,2).Range.Text = $SecurityCountStr
		$Table.Cell(3,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(3,1).Range.Font.Bold = $True
		$Table.Cell(3,1).Range.Text = "`t`tDomain Local"
		$Table.Cell(3,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(3,2).Range.Text = $DomainLocalCountStr
		$Table.Cell(4,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(4,1).Range.Font.Bold = $True
		$Table.Cell(4,1).Range.Text = "`t`tGlobal"
		$Table.Cell(4,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(4,2).Range.Text = $GlobalCountStr
		$Table.Cell(5,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(5,1).Range.Font.Bold = $True
		$Table.Cell(5,1).Range.Text = "`t`tUniversal"
		$Table.Cell(5,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(5,2).Range.Text = $UniversalCountStr
		$Table.Cell(6,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(6,1).Range.Font.Bold = $True
		$Table.Cell(6,1).Range.Text = "`tDistribution Groups"
		$Table.Cell(6,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(6,2).Range.Text = $DistributionCountStr
		$Table.Cell(7,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(7,1).Range.Font.Bold = $True
		$Table.Cell(7,1).Range.Text = "Groups with SID History"
		$Table.Cell(7,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(7,2).Range.Text = $GroupsWithSIDHistoryStr
		$Table.Cell(8,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(8,1).Range.Font.Bold = $True
		$Table.Cell(8,1).Range.Text = "Contacts"
		$Table.Cell(8,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(8,2).Range.Text = $ContactsCountStr

		$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
		$Table.AutoFitBehavior($wdAutoFitContent)

		#return focus back to document
		$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

		#move to the end of the current document
		$selection.EndKey($wdStory,$wdMove) | Out-Null
		$TableRange = $Null
		$Table = $Null
		
		#get members of privileged groups
		$DomainInfo = $Null
		$DomainInfo = Get-ADDomain -Identity $Domain
		
		If($? -and $DomainInfo -ne $Null)
		{
			$DomainAdminsSID = "$($DomainInfo.DomainSID)-512"
			$EnterpriseAdminsSID = "$($DomainInfo.DomainSID)-519"
			$SchemaAdminsSID = "$($DomainInfo.DomainSID)-518"
		}
		Else
		{
			$DomainAdminsSID = $Null
			$EnterpriseAdminsSID = $Null
			$SchemaAdminsSID = $Null
		}
		
		WriteWordLine 3 0 "Privileged Groups"
		Write-Verbose "$(Get-Date): `t`tListing domain admins"
		$Admins = $Null
		$Admins = Get-ADGroupMember -Identity $DomainAdminsSID -Server $Domain
		
		If($? -and $Admins -ne $Null)
		{
			If($Admins -is [array])
			{
				[int]$AdminsCount = $Admins.Count
			}
			Else
			{
				[int]$AdminsCount = 1
			}
			$Admins = $Admins | Sort Name
			[string]$AdminsCountStr = "{0:N0}" -f $AdminsCount
			
			WriteWordLine 4 0 "Domain Admins ($($AdminsCountStr) members):"
			$TableRange = $doc.Application.Selection.Range
			[int]$Columns = 4
			[int]$Rows = $AdminsCount + 1
			[int]$xRow = 1
			$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
			$Table.AutoFitBehavior($wdAutoFitFixed)
			$Table.Style = $Script:MyHash.Word_TableGrid
	
			$Table.rows.first.headingformat = $wdHeadingFormatTrue
			$Table.Borders.InsideLineStyle = $wdLineStyleSingle
			$Table.Borders.OutsideLineStyle = $wdLineStyleSingle

			$Table.Rows.First.Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Name"
			$Table.Cell($xRow,2).Range.Font.Bold = $True
			$Table.Cell($xRow,2).Range.Text = "Password Last Changed"
			$Table.Cell($xRow,3).Range.Font.Bold = $True
			$Table.Cell($xRow,3).Range.Text = "Password Never Expires"
			$Table.Cell($xRow,4).Range.Font.Bold = $True
			$Table.Cell($xRow,4).Range.Text = "Account Enabled"
			#$Table.Cell($xRow,5).Range.Font.Bold = $True
			#$Table.Cell($xRow,5).Range.Text = "Password Policy"
			ForEach($Admin in $Admins)
			{
				$User = Get-ADUser -Identity $Admin.SID -Server $Domain -Properties PasswordLastSet, Enabled, PasswordNeverExpires 

				$xRow++
				
				If($? -and $User -ne $Null)
				{
					$Table.Cell($xRow,1).Range.Text = $User.Name
					If($User.PasswordLastSet -eq $Null)
					{
						$Table.Cell($xRow,2).Shading.BackgroundPatternColor = $wdColorRed
						$Table.Cell($xRow,2).Range.Font.Bold  = $True
						$Table.Cell($xRow,2).Range.Font.Color = $WDColorBlack
						$Table.Cell($xRow,2).Range.Text = "No Date Set"
					}
					Else
					{
						$Table.Cell($xRow,2).Range.Text = (get-date $User.PasswordLastSet -f d)
					}
					If($User.PasswordNeverExpires -eq $True)
					{
						$Table.Cell($xRow,3).Shading.BackgroundPatternColor = $wdColorRed
						$Table.Cell($xRow,3).Range.Font.Bold  = $True
						$Table.Cell($xRow,3).Range.Font.Color = $WDColorBlack
					}
					$Table.Cell($xRow,3).Range.Text = $User.PasswordNeverExpires
					If($User.Enabled -eq $False)
					{
						$Table.Cell($xRow,4).Shading.BackgroundPatternColor = $wdColorRed
						$Table.Cell($xRow,4).Range.Font.Bold  = $True
						$Table.Cell($xRow,4).Range.Font.Color = $WDColorBlack
					}
					$Table.Cell($xRow,4).Range.Text = $User.Enabled
					#$Table.Cell($xRow,5).Range.Text = ""
				}
				Else
				{
					$Table.Cell($xRow,2).Range.Text = $Admin.SID
					$Table.Cell($xRow,3).Range.Text = "Unknown"
					$Table.Cell($xRow,4).Range.Text = "Unknown"
					#$Table.Cell($xRow,5).Range.Text = "Unknown"
				}
			}
			
			#set column widths
			$xcols = $table.columns

			ForEach($xcol in $xcols)
			{
			    switch ($xcol.Index)
			    {
				  1 {$xcol.width = 200}
				  2 {$xcol.width = 66}
				  3 {$xcol.width = 56}
				  4 {$xcol.width = 50}
				  5 {$xcol.width = 142}
			    }
			}
			
			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
			$Table.AutoFitBehavior($wdAutoFitFixed)

			#return focus back to document
			$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

			#move to the end of the current document
			$selection.EndKey($wdStory,$wdMove) | Out-Null
			$TableRange = $Null
			$Table = $Null
		}
		ElseIf(!$?)
		{
			WriteWordLine 0 0 "Unable to retrieve Domain Admins group membership" "" $Null 0 $False $True
		}
		Else
		{
			WriteWordLine 4 0 "Domain Admins: "
			WriteWordLine 0 0 "<None>"
		}

		Write-Verbose "$(Get-Date): `t`tListing enterprise admins"
		
		If($Domain -eq $ForestRootDomain)
		{
			$Admins = Get-ADGroupMember -Identity $EnterpriseAdminsSID -Server $Domain 
			
			If($? -and $Admins -ne $Null)
			{
				If($Admins -is [array])
				{
					[int]$AdminsCount = $Admins.Count
				}
				Else
				{
					[int]$AdminsCount = 1
				}
				$Admins = $Admins | Sort Name
				[string]$AdminsCountStr = "{0:N0}" -f $AdminsCount
				
				WriteWordLine 4 0 "Enterprise Admins ($($AdminsCountStr) members):"
				$TableRange = $doc.Application.Selection.Range
				[int]$Columns = 5
				[int]$Rows = $AdminsCount + 1
				[int]$xRow = 1
				$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
				$Table.AutoFitBehavior($wdAutoFitFixed)
				$Table.Style = $Script:MyHash.Word_TableGrid
	
				$Table.rows.first.headingformat = $wdHeadingFormatTrue
				$Table.Borders.InsideLineStyle = $wdLineStyleSingle
				$Table.Borders.OutsideLineStyle = $wdLineStyleSingle

				$Table.Rows.First.Shading.BackgroundPatternColor = $wdColorGray15
				$Table.Cell($xRow,1).Range.Font.Bold = $True
				$Table.Cell($xRow,1).Range.Text = "Name"
				$Table.Cell($xRow,2).Range.Font.Bold = $True
				$Table.Cell($xRow,2).Range.Text = "Domain"
				$Table.Cell($xRow,3).Range.Font.Bold = $True
				$Table.Cell($xRow,3).Range.Text = "Password Last Changed"
				$Table.Cell($xRow,4).Range.Font.Bold = $True
				$Table.Cell($xRow,4).Range.Text = "Password Never Expires"
				$Table.Cell($xRow,5).Range.Font.Bold = $True
				$Table.Cell($xRow,5).Range.Text = "Account Enabled"
				#$Table.Cell($xRow,6).Range.Font.Bold = $True
				#$Table.Cell($xRow,6).Range.Text = "Password Policy"
				ForEach($Admin in $Admins)
				{
					$xRow++
					$xArray = $Admin.DistinguishedName.Split(",")
					$xServer = ""
					$xCnt = 0
					ForEach($xItem in $xArray)
					{
						$xCnt++
						If($xItem.StartsWith("DC="))
						{
							$xtmp = $xItem.Substring($xItem.IndexOf("=")+1)
							If($xCnt -eq $xArray.Count)
							{
								$xServer += $xTmp
							}
							Else
							{
								$xServer += "$($xTmp)."
							}
						}
					}

					If($Admin.ObjectClass -eq 'user')
					{
						$User = Get-ADUser -Identity $Admin.SID.value -Server $xServer -Properties PasswordLastSet, Enabled, PasswordNeverExpires 
					}
					ElseIf($Admin.ObjectClass -eq 'group')
					{
						$User = Get-ADGroup -Identity $Admin.SID.value -Server $xServer 
					}
					Else
					{
						$User = $Null
					}
					
					If($? -and $User -ne $Null)
					{
						If($Admin.ObjectClass -eq 'user')
						{
							$Table.Cell($xRow,1).Range.Text = $User.Name
							$Table.Cell($xRow,2).Range.Text = $xServer
							If($User.PasswordLastSet -eq $Null)
							{
								$Table.Cell($xRow,3).Shading.BackgroundPatternColor = $wdColorRed
								$Table.Cell($xRow,3).Range.Font.Bold  = $True
								$Table.Cell($xRow,3).Range.Font.Color = $WDColorBlack
								$Table.Cell($xRow,3).Range.Text = "No Date Set"
							}
							Else
							{
								$Table.Cell($xRow,3).Range.Text = (get-date $User.PasswordLastSet -f d)
							}
							If($User.PasswordNeverExpires -eq $True)
							{
								$Table.Cell($xRow,4).Shading.BackgroundPatternColor = $wdColorRed
								$Table.Cell($xRow,4).Range.Font.Bold  = $True
								$Table.Cell($xRow,4).Range.Font.Color = $WDColorBlack
							}
							$Table.Cell($xRow,4).Range.Text = $User.PasswordNeverExpires
							If($User.Enabled -eq $False)
							{
								$Table.Cell($xRow,5).Shading.BackgroundPatternColor = $wdColorRed
								$Table.Cell($xRow,5).Range.Font.Bold  = $True
								$Table.Cell($xRow,5).Range.Font.Color = $WDColorBlack
							}
							$Table.Cell($xRow,5).Range.Text = $User.Enabled
							#$Table.Cell($xRow,6).Range.Text = ""
						}
						ElseIf($Admin.ObjectClass -eq 'group')
						{
							$Table.Cell($xRow,1).Range.Text = "$($User.Name) (group)"
							$Table.Cell($xRow,2).Range.Text = $xServer
							$Table.Cell($xRow,3).Range.Text = "N/A"
							$Table.Cell($xRow,4).Range.Text = "N/A"
							$Table.Cell($xRow,5).Range.Text = "N/A"
							#$Table.Cell($xRow,6).Range.Text = ""
						}
						
					}
					Else
					{
						$Table.Cell($xRow,1).Range.Text = $Admin.SID.Value
						$Table.Cell($xRow,2).Range.Text = $xServer
						$Table.Cell($xRow,3).Range.Text = "Unknown"
						$Table.Cell($xRow,4).Range.Text = "Unknown"
						$Table.Cell($xRow,5).Range.Text = "Unknown"
						#$Table.Cell($xRow,6).Range.Text = "Unknown"
					}
				}
			
				#set column widths
				$xcols = $table.columns

				ForEach($xcol in $xcols)
				{
				    switch ($xcol.Index)
				    {
					  1 {$xcol.width = 100}
					  2 {$xcol.width = 108}
					  3 {$xcol.width = 66}
					  4 {$xcol.width = 56}
					  5 {$xcol.width = 56}
					  6 {$xcol.width = 100}
				    }
				}

				$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
				$Table.AutoFitBehavior($wdAutoFitFixed)

				#return focus back to document
				$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

				#move to the end of the current document
				$selection.EndKey($wdStory,$wdMove) | Out-Null
				$TableRange = $Null
				$Table = $Null
			}
			ElseIf(!$?)
			{
				WriteWordLine 0 0 "Unable to retrieve Enterprise Admins group membership" "" $Null 0 $False $True
			}
			Else
			{
				WriteWordLine 0 0 "<None>"
			}
		}
		Else
		{
			WriteWordLine 4 0 "Enterprise Admins: "
			WriteWordLine 0 0 "<None>"
		}
		
		Write-Verbose "$(Get-Date): `t`tListing schema admins"
		
		If($Domain -eq $ForestRootDomain)
		{
			$Admins = Get-ADGroupMember -Identity $SchemaAdminsSID -Server $Domain 
			
			If($? -and $Admins -ne $Null)
			{
				If($Admins -is [array])
				{
					[int]$AdminsCount = $Admins.Count
				}
				Else
				{
					[int]$AdminsCount = 1
				}
				$Admins = $Admins | Sort Name
				[string]$AdminsCountStr = "{0:N0}" -f $AdminsCount
				
				WriteWordLine 4 0 "Schema Admins ($($AdminsCountStr) members):"
				$TableRange = $doc.Application.Selection.Range
				[int]$Columns = 5
				[int]$Rows = $AdminsCount + 1
				[int]$xRow = 1
				$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
				$Table.AutoFitBehavior($wdAutoFitFixed)
				$Table.Style = $Script:MyHash.Word_TableGrid
	
				$Table.rows.first.headingformat = $wdHeadingFormatTrue
				$Table.Borders.InsideLineStyle = $wdLineStyleSingle
				$Table.Borders.OutsideLineStyle = $wdLineStyleSingle

				$Table.Rows.First.Shading.BackgroundPatternColor = $wdColorGray15
				$Table.Cell($xRow,1).Range.Font.Bold = $True
				$Table.Cell($xRow,1).Range.Text = "Name"
				$Table.Cell($xRow,2).Range.Font.Bold = $True
				$Table.Cell($xRow,2).Range.Text = "Domain"
				$Table.Cell($xRow,3).Range.Font.Bold = $True
				$Table.Cell($xRow,3).Range.Text = "Password Last Changed"
				$Table.Cell($xRow,4).Range.Font.Bold = $True
				$Table.Cell($xRow,4).Range.Text = "Password Never Expires"
				$Table.Cell($xRow,5).Range.Font.Bold = $True
				$Table.Cell($xRow,5).Range.Text = "Account Enabled"
				#$Table.Cell($xRow,6).Range.Font.Bold = $True
				#$Table.Cell($xRow,6).Range.Text = "Password Policy"
				ForEach($Admin in $Admins)
				{
					$xRow++
					$xArray = $Admin.DistinguishedName.Split(",")
					$xServer = ""
					$xCnt = 0
					ForEach($xItem in $xArray)
					{
						$xCnt++
						If($xItem.StartsWith("DC="))
						{
							$xtmp = $xItem.Substring($xItem.IndexOf("=")+1)
							If($xCnt -eq $xArray.Count)
							{
								$xServer += $xTmp
							}
							Else
							{
								$xServer += "$($xTmp)."
							}
						}
					}

					If($Admin.ObjectClass -eq 'user')
					{
						$User = Get-ADUser -Identity $Admin.SID.value -Server $xServer -Properties PasswordLastSet, Enabled, PasswordNeverExpires 
					}
					ElseIf($Admin.ObjectClass -eq 'group')
					{
						$User = Get-ADGroup -Identity $Admin.SID.value -Server $xServer 
					}
					Else
					{
						$User = $Null
					}
					
					If($? -and $User -ne $Null)
					{
						If($Admin.ObjectClass -eq 'user')
						{
							$Table.Cell($xRow,1).Range.Text = $User.Name
							$Table.Cell($xRow,2).Range.Text = $xServer
							If($User.PasswordLastSet -eq $Null)
							{
								$Table.Cell($xRow,3).Shading.BackgroundPatternColor = $wdColorRed
								$Table.Cell($xRow,3).Range.Font.Bold  = $True
								$Table.Cell($xRow,3).Range.Font.Color = $WDColorBlack
								$Table.Cell($xRow,3).Range.Text = "No Date Set"
							}
							Else
							{
								$Table.Cell($xRow,3).Range.Text = (get-date $User.PasswordLastSet -f d)
							}
							If($User.PasswordNeverExpires -eq $True)
							{
								$Table.Cell($xRow,4).Shading.BackgroundPatternColor = $wdColorRed
								$Table.Cell($xRow,4).Range.Font.Bold  = $True
								$Table.Cell($xRow,4).Range.Font.Color = $WDColorBlack
							}
							$Table.Cell($xRow,4).Range.Text = $User.PasswordNeverExpires
							If($User.Enabled -eq $False)
							{
								$Table.Cell($xRow,5).Shading.BackgroundPatternColor = $wdColorRed
								$Table.Cell($xRow,5).Range.Font.Bold  = $True
								$Table.Cell($xRow,5).Range.Font.Color = $WDColorBlack
							}
							$Table.Cell($xRow,5).Range.Text = $User.Enabled
							#$Table.Cell($xRow,6).Range.Text = ""
						}
						ElseIf($Admin.ObjectClass -eq 'group')
						{
							$Table.Cell($xRow,1).Range.Text = "$($User.Name) (group)"
							$Table.Cell($xRow,2).Range.Text = $xServer
							$Table.Cell($xRow,3).Range.Text = "N/A"
							$Table.Cell($xRow,4).Range.Text = "N/A"
							$Table.Cell($xRow,5).Range.Text = "N/A"
							#$Table.Cell($xRow,6).Range.Text = ""
						}
						
					}
					Else
					{
						$Table.Cell($xRow,1).Range.Text = $Admin.SID.Value
						$Table.Cell($xRow,2).Range.Text = $xServer
						$Table.Cell($xRow,3).Range.Text = "Unknown"
						$Table.Cell($xRow,4).Range.Text = "Unknown"
						$Table.Cell($xRow,5).Range.Text = "Unknown"
						#$Table.Cell($xRow,6).Range.Text = "Unknown"
					}
				}
			
				#set column widths
				$xcols = $table.columns

				ForEach($xcol in $xcols)
				{
				    switch ($xcol.Index)
				    {
					  1 {$xcol.width = 100}
					  2 {$xcol.width = 108}
					  3 {$xcol.width = 66}
					  4 {$xcol.width = 56}
					  5 {$xcol.width = 56}
					  6 {$xcol.width = 100}
				    }
				}
				
				$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
				$Table.AutoFitBehavior($wdAutoFitFixed)

				#return focus back to document
				$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

				#move to the end of the current document
				$selection.EndKey($wdStory,$wdMove) | Out-Null
				$TableRange = $Null
				$Table = $Null
			}
			ElseIf(!$?)
			{
				WriteWordLine 0 0 "Unable to retrieve Schema Admins group membership" "" $Null 0 $False $True
			}
			Else
			{
				WriteWordLine 0 0 "<None>"
			}
		}
		Else
		{
			WriteWordLine 4 0 "Schema Admins: "
			WriteWordLine 0 0 "<None>"
		}

		#http://www.shariqsheikh.com/blog/index.php/200908/use-powershell-to-look-up-admincount-from-adminsdholder-and-sdprop/		
		Write-Verbose "$(Get-Date): `t`tListing users with AdminCount = 1"
		$AdminCounts = Get-ADUser -LDAPFilter "(admincount=1)"  -Server $Domain 
		
		If($? -and $AdminCounts -ne $Null)
		{
			$AdminCounts = $AdminCounts | Sort Name
			If($AdminCounts -is [array])
			{
				[int]$AdminsCount = $AdminCounts.Count
			}
			Else
			{
				[int]$AdminsCount = 1
			}
			[string]$AdminsCountStr = "{0:N0}" -f $AdminsCount
			
			WriteWordLine 4 0 "Users with AdminCount=1 ($($AdminsCountStr) members):"
			$TableRange = $doc.Application.Selection.Range
			[int]$Columns = 4
			[int]$Rows = $AdminCounts.Count + 1
			[int]$xRow = 1
			$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
			$Table.AutoFitBehavior($wdAutoFitFixed)
			$Table.Style = $Script:MyHash.Word_TableGrid
	
			$Table.rows.first.headingformat = $wdHeadingFormatTrue
			$Table.Borders.InsideLineStyle = $wdLineStyleSingle
			$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
			
			$Table.Rows.First.Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Name"
			$Table.Cell($xRow,2).Range.Font.Bold = $True
			$Table.Cell($xRow,2).Range.Text = "Password Last Changed"
			$Table.Cell($xRow,3).Range.Font.Bold = $True
			$Table.Cell($xRow,3).Range.Text = "Password Never Expires"
			$Table.Cell($xRow,4).Range.Font.Bold = $True
			$Table.Cell($xRow,4).Range.Text = "Account Enabled"
			#$Table.Cell($xRow,5).Range.Font.Bold = $True
			#$Table.Cell($xRow,5).Range.Text = "Password Policy"
			ForEach($Admin in $AdminCounts)
			{
				$User = Get-ADUser -Identity $Admin.SID -Server $Domain -Properties PasswordLastSet, Enabled, PasswordNeverExpires 

				$xRow++
				
				If($? -and $User -ne $Null)
				{
					$Table.Cell($xRow,1).Range.Text = $User.Name
					If($User.PasswordLastSet -eq $Null)
					{
						$Table.Cell($xRow,2).Shading.BackgroundPatternColor = $wdColorRed
						$Table.Cell($xRow,2).Range.Font.Bold  = $True
						$Table.Cell($xRow,2).Range.Font.Color = $WDColorBlack
						$Table.Cell($xRow,2).Range.Text = "No Date Set"
					}
					Else
					{
						$Table.Cell($xRow,2).Range.Text = (get-date $User.PasswordLastSet -f d)
					}
					If($User.PasswordNeverExpires -eq $True)
					{
						$Table.Cell($xRow,3).Shading.BackgroundPatternColor = $wdColorRed
						$Table.Cell($xRow,3).Range.Font.Bold  = $True
						$Table.Cell($xRow,3).Range.Font.Color = $WDColorBlack
					}
					$Table.Cell($xRow,3).Range.Text = $User.PasswordNeverExpires
					If($User.Enabled -eq $False)
					{
						$Table.Cell($xRow,4).Shading.BackgroundPatternColor = $wdColorRed
						$Table.Cell($xRow,4).Range.Font.Bold  = $True
						$Table.Cell($xRow,4).Range.Font.Color = $WDColorBlack
					}
					$Table.Cell($xRow,4).Range.Text = $User.Enabled
					#$Table.Cell($xRow,5).Range.Text = ""
				}
				Else
				{
					$Table.Cell($xRow,2).Range.Text = $Admin.SID
					$Table.Cell($xRow,3).Range.Text = "Unknown"
					$Table.Cell($xRow,4).Range.Text = "Unknown"
					#$Table.Cell($xRow,5).Range.Text = "Unknown"
				}
			}
			
			#set column widths
			$xcols = $table.columns

			ForEach($xcol in $xcols)
			{
			    switch ($xcol.Index)
			    {
				  1 {$xcol.width = 200}
				  2 {$xcol.width = 66}
				  3 {$xcol.width = 56}
				  4 {$xcol.width = 50}
				  5 {$xcol.width = 142}
			    }
			}

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
			$Table.AutoFitBehavior($wdAutoFitFixed)

			#return focus back to document
			$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

			#move to the end of the current document
			$selection.EndKey($wdStory,$wdMove) | Out-Null
			$TableRange = $Null
			$Table = $Null
		}
		ElseIf(!$?)
		{
			WriteWordLine 0 0 "Unable to retrieve users with AdminCount=1" "" $Null 0 $False $True
		}
		Else
		{
			WriteWordLine 4 0 "Users with AdminCount=1: "
			WriteWordLIne 0 0 "<None>"
		}
		
		Write-Verbose "$(Get-Date): `t`tListing groups with AdminCount = 1"
		$AdminCounts = Get-ADGroup -LDAPFilter "(admincount=1)" -Server $Domain  | Select Name
		
		If($? -and $AdminCounts -ne $Null)
		{
			$AdminCounts = $AdminCounts | Sort Name
			If($AdminCounts -is [array])
			{
				[int]$AdminsCount = $AdminCounts.Count
			}
			Else
			{
				[int]$AdminsCount = 1
			}
			[string]$AdminsCountStr = "{0:N0}" -f $AdminsCount
			
			WriteWordLine 4 0 "Groups with AdminCount=1 ($($AdminsCountStr) members):"
			$TableRange = $doc.Application.Selection.Range
			[int]$Columns = 2
			[int]$Rows = $AdminCounts.Count + 1
			[int]$xRow = 1
			$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
			$Table.AutoFitBehavior($wdAutoFitFixed)
			$Table.Style = $Script:MyHash.Word_TableGrid
	
			$Table.rows.first.headingformat = $wdHeadingFormatTrue
			$Table.Borders.InsideLineStyle = $wdLineStyleSingle
			$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
			$Table.Rows.First.Shading.BackgroundPatternColor = $wdColorGray15
			$Table.Cell($xRow,1).Range.Font.Bold = $True
			$Table.Cell($xRow,1).Range.Text = "Group Name"
			$Table.Cell($xRow,2).Range.Font.Bold = $True
			$Table.Cell($xRow,2).Range.Text = "Members"
			ForEach($Admin in $AdminCounts)
			{
				Write-Verbose "$(Get-Date): `t`t`t$($Admin.Name)"
				$xRow++
				$Members = Get-ADGroupMember -Identity $Admin.Name -Server $Domain | Sort Name
				
				If($? -and $Members -ne $Null)
				{
					If($Members -is [array])
					{
						$MembersCount = $Members.Count
					}
					Else
					{
						$MembersCount = 1
					}
				}
				Else
				{
					$MembersCount = 0
				}

				[string]$MembersCountStr = "{0:N0}" -f $MembersCount
				$Table.Cell($xRow,1).Range.Text = "$($Admin.Name) ($($MembersCountStr) members)"
				$MbrStr = ""
				If($MembersCount -gt 0)
				{
					ForEach($Member in $Members)
					{
						$MbrStr += "$($Member.Name)`r"
					}
					$Table.Cell($xRow,2).Range.Text = $MbrStr
				}
			}
			
			#set column widths
			$xcols = $table.columns

			ForEach($xcol in $xcols)
			{
			    switch ($xcol.Index)
			    {
				  1 {$xcol.width = 200}
				  2 {$xcol.width = 172}
			    }
			}
			
			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
			$Table.AutoFitBehavior($wdAutoFitFixed)

			#return focus back to document
			$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

			#move to the end of the current document
			$selection.EndKey($wdStory,$wdMove) | Out-Null
			$TableRange = $Null
			$Table = $Null
		}
		ElseIf(!$?)
		{
			WriteWordLine 0 0 "Unable to retrieve Groups with AdminCount=1" "" $Null 0 $False $True
		}
		Else
		{
			WriteWordLine 4 0 "Groups with AdminCount=1: "
			WriteWordLine 0 0 "<None>"
		}
	}
	ElseIf(!$?)
	{
		Write-Warning "Error retrieving Group data for domain $($Domain)"
		WriteWordLine 0 0 "Error retrieving Group data for domain $($Domain)" "" $Null 0 $False $True
	}
	Else
	{
		WriteWordLine 0 0 "No Group data was retrieved for domain $($Domain)" "" $Null 0 $False $True
	}
	$First = $False
}
$Groups = $Null
$Admins = $Null
$Members = $Null
$Results = $Null
$DomainInfo = $Null
$User = $Null
$AdminCounts = $Null
$TotalCountStr = $Null
$SecurityCountStr = $Null
$DomainLocalCountStr = $Null
$GlobalCountStr = $Null
$UniversalCountStr = $Null
$DistributionCountStr = $Null
$GroupsWithSIDHistoryStr = $Null
$ContactsCountStr = $Null
$DomainAdminsSID = $Null
$EnterpriseAdminsSID = $Null
$SchemaAdminsSID = $Null
$AdminsCountStr = $Null
$MembersCountStr = $Null

#GPOs by domain
Write-Verbose "$(Get-Date): Writing domain group policy data"

$selection.InsertNewPage()
WriteWordLine 1 0 "Group Policies by Domain"
$First = $True

ForEach($Domain in $Domains)
{
	Write-Verbose "$(Get-Date): `tProcessing group policies for domain $($Domain)"

	$DomainInfo = Get-ADDomain -Identity $Domain 
	
	If($? -and $DomainInfo -ne $Null)
	{
		If(!$First)
		{
			#put each domain, starting with the second, on a new page
			$selection.InsertNewPage()
		}
		
		If($Domain -eq $ForestRootDomain)
		{
			WriteWordLine 2 0 "$($Domain) (Forest Root)"
		}
		Else
		{
			WriteWordLine 2 0 $Domain
		}

		Write-Verbose "$(Get-Date): `t`tGetting linked GPOs"
		WriteWordLine 3 0 "Linked Group Policy Objects" 
		$LinkedGPOs = $DomainInfo.LinkedGroupPolicyObjects | Sort
		If($LinkedGpos -eq $Null)
		{
			WriteWordLine 0 0 "<None>"
		}
		Else
		{
			$TableRange = $doc.Application.Selection.Range
			[int]$Columns = 1
			If($LinkedGpos -is [array])
			{
				[int]$Rows = $LinkedGpos.Count
			}
			Else
			{
				[int]$Rows = 1
			}
			$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
			$Table.Style = $Script:MyHash.Word_TableGrid
	
			$Table.Borders.InsideLineStyle = $wdLineStyleSingle
			$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
			$GPOArray = @()
			ForEach($LinkedGpo in $LinkedGpos)
			{
				#taken from Michael B. Smith's work on the XenApp 6.x scripts
				#this way we don't need the GroupPolicy module
				$gpObject = [ADSI]( "LDAP://" + $LinkedGPO )
				If($gpObject.DisplayName -eq $Null)
				{
					$p1 = $LinkedGPO.IndexOf("{")
					#38 is length of guid (32) plus the four "-"s plus the beginning "{" plus the ending "}"
					$GUID = $LinkedGPO.SubString($p1,38)
					$tmp = "GPO with GUID $($GUID) was not found in this domain"
				}
				Else
				{
					$tmp = $gpObject.DisplayName	### name of the group policy object
				}
				$GPOArray += $tmp
			}

			$GPOArray = $GPOArray | Sort
			
			[int]$xRow = 0
			ForEach($Item in $GPOArray)
			{
				$xRow++
				$Table.Cell($xRow,1).Range.Text = $Item
			}
			$GPOArray = $Null

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
			$Table.AutoFitBehavior($wdAutoFitContent)

			#return focus back to document
			$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

			#move to the end of the current document
			$selection.EndKey($wdStory,$wdMove) | Out-Null
			$TableRange = $Null
			$Table = $Null
		}
		$LinkedGPOs = $Null
		$First = $False
	}
	ElseIf(!$?)
	{
		Write-Warning "Error retrieving domain data for domain $($Domain)"
		WriteWordLine 0 0 "Error retrieving domain data for domain $($Domain)" "" $Null 0 $False $True
	}
	Else
	{
		WriteWordLine 0 0 "No Domain data was retrieved for domain $($Domain)" "" $Null 0 $False $True
	}
}
$DomainInfo = $Null
$LinkedGPOs = $Null
$GPOArray = $Null

#group policies by organizational units
Write-Verbose "$(Get-Date): Writing Group Policy data by Domain by OU"
$selection.InsertNewPage()
WriteWordLine 1 0 "Group Policies by Organizational Unit"
$First = $True

ForEach($Domain in $Domains)
{
	Write-Verbose "$(Get-Date): `tProcessing domain $($Domain)"
	If(!$First)
	{
		#put each domain, starting with the second, on a new page
		$selection.InsertNewPage()
	}
	If($Domain -eq $ForestRootDomain)
	{
		WriteWordLine 2 0 "Group Policies by OUs in Domain $($Domain) (Forest Root)"
	}
	Else
	{
		WriteWordLine 2 0 "Group Policies by OUs in Domain $($Domain)"
	}
	#print disclaimer line in 8 point bold italics
	WriteWordLine 0 0 "(Contains only OUs with linked Group Policies)" "" $Null 8 $True $True
	#get all OUs for the domain
	$OUs = Get-ADOrganizationalUnit -Filter * -Server $Domain -Properties CanonicalName, DistinguishedName, Name  | Select CanonicalName, DistinguishedName, Name | Sort CanonicalName
	
	If($? -and $OUs -ne $Null)
	{
		If($OUs -is [array])
		{
			[int]$NumOUs = $OUs.Count
		}
		Else
		{
			[int]$NumOUs = 1
		}
		[int]$OUCount = 0

		ForEach($OU in $OUs)
		{
			$OUCount++
			$OUDisplayName = $OU.CanonicalName.SubString($OU.CanonicalName.IndexOf("/")+1)
			Write-Verbose "$(Get-Date): `t`tProcessing OU $($OU.CanonicalName) - OU # $OUCount of $NumOUs"
			
			#get data for the individual OU
			$OUInfo = Get-ADOrganizationalUnit -Identity $OU.DistinguishedName -Server $Domain -Properties * 
			
			If($? -and $OUInfo -ne $Null)
			{
				Write-Verbose "$(Get-Date): `t`t`tGetting linked GPOs"
				$LinkedGPOs = $OUInfo.LinkedGroupPolicyObjects | Sort
				If($LinkedGpos -eq $Null)
				{
					# do nothing
				}
				Else
				{
					WriteWordLine 3 0 "$($OUDisplayName)"
					$TableRange = $doc.Application.Selection.Range
					[int]$Columns = 1
					If($LinkedGpos -is [array])
					{
						[int]$Rows = $LinkedGpos.Count
					}
					Else
					{
						[int]$Rows = 1
					}
					$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
					$Table.Style = $Script:MyHash.Word_TableGrid
	
					$Table.Borders.InsideLineStyle = $wdLineStyleSingle
					$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
					$GPOArray = @()
					ForEach($LinkedGpo in $LinkedGpos)
					{
						#taken from Michael B. Smith's work on the XenApp 6.x scripts
						#this way we don't need the GroupPolicy module
						$gpObject = [ADSI]( "LDAP://" + $LinkedGPO )
						If($gpObject.DisplayName -eq $Null)
						{
							$p1 = $LinkedGPO.IndexOf("{")
							#38 is length of guid (32) plus the four "-"s plus the beginning "{" plus the ending "}"
							$GUID = $LinkedGPO.SubString($p1,38)
							$tmp = "GPO with GUID $($GUID) was not found in this domain"
						}
						Else
						{
							$tmp = $gpObject.DisplayName	### name of the group policy object
						}
						$GPOArray += $tmp
					}

					$GPOArray = $GPOArray | Sort
					
					[int]$xRow = 0
					ForEach($Item in $GPOArray)
					{
						$xRow++
						$Table.Cell($xRow,1).Range.Text = $Item
					}
					$GPOArray = $Null

					$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
					$Table.AutoFitBehavior($wdAutoFitContent)

					#return focus back to document
					$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

					#move to the end of the current document
					$selection.EndKey($wdStory,$wdMove) | Out-Null
					$TableRange = $Null
					$Table = $Null
				}
			}
			ElseIf(!$?)
			{
				Write-Warning "Error retrieving OU data for OU $($OU.CanonicalName)"
			}
			Else
			{
				$Table.Cell($xRow,1).Range.Text = "<None>"
				$Table.Cell($xRow,2).Range.Text = "<None>"
				$Table.Cell($xRow,3).Range.Text = "<None>"
				$Table.Cell($xRow,4).Range.Text = "<None>"
				$Table.Cell($xRow,5).Range.Text = "<None>"
				$Table.Cell($xRow,6).Range.Text = "<None>"
			}
		}
		$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
		$Table.AutoFitBehavior($wdAutoFitContent)

		#return focus back to document
		$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

		#move to the end of the current document
		$selection.EndKey($wdStory,$wdMove) | Out-Null
	}
	ElseIf(!$?)
	{
		Write-Warning "Error retrieving OU data for domain $($Domain)"
		WriteWordLine 0 0 "Error retrieving OU data for domain $($Domain)" "" $Null 0 $False $True
	}
	Else
	{
		WriteWordLine 0 0 "No OU data was retrieved for domain $($Domain)" "" $Null 0 $False $True
	}
	$First = $False
}
$OUs = $Null
$OUDisplayName = $Null
$OUInfo = $Null
$LinkedGPOs = $Null
$GPOArray = $Null

#misc info by domain
Write-Verbose "$(Get-Date): Writing miscellaneous data by domain"

$selection.InsertNewPage()
WriteWordLine 1 0 "Miscellaneous Data by Domain"
$First = $True

ForEach($Domain in $Domains)
{
	Write-Verbose "$(Get-Date): `tProcessing misc data for domain $($Domain)"

	$DomainInfo = Get-ADDomain -Identity $Domain 
	
	If($? -and $DomainInfo -ne $Null)
	{
		If(!$First)
		{
			#put each domain, starting with the second, on a new page
			$selection.InsertNewPage()
		}
		
		If($Domain -eq $ForestRootDomain)
		{
			WriteWordLine 2 0 "$($Domain) (Forest Root)"
		}
		Else
		{
			WriteWordLine 2 0 $Domain
		}

		Write-Verbose "$(Get-Date): `t`tGathering user misc data"
		
		$Users = Get-ADUser -Filter * -Server $Domain -Properties CannotChangePassword, Enabled, LockedOut, PasswordExpired, PasswordNeverExpires, PasswordNotRequired, lastLogonTimestamp, DistinguishedName 
		
		If($? -and $Users -ne $Null)
		{
			If($Users -is [array])
			{
				[int]$UsersCount = $Users.Count
			}
			Else
			{
				[int]$UsersCount = 1
			}
			
			Write-Verbose "$(Get-Date): `t`t`tDisabled users"
			$Results = $Users | Where {$_.Enabled -eq $False}
		
			If($Results -eq $Null)
			{
				[int]$UsersDisabled = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$UsersDisabled = $Results.Count
			}
			Else
			{
				[int]$UsersDisabled = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tUnknown users"
			$Results = $Users | Where {$_.Enabled -eq $Null}
		
			If($Results -eq $Null)
			{
				[int]$UsersUnknown = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$UsersUnknown = $Results.Count
			}
			Else
			{
				[int]$UsersUnknown = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tLocked out users"
			$Results = $Users | Where {$_.LockedOut -eq $True}
		
			If($Results -eq $Null)
			{
				[int]$UsersLockedOut = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$UsersLockedOut = $Results.Count
			}
			Else
			{
				[int]$UsersLockedOut = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tAll users with password expired"
			$Results = $Users | Where {$_.PasswordExpired -eq $True}
		
			If($Results -eq $Null)
			{
				[int]$UsersPasswordExpired = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$UsersPasswordExpired = $Results.Count
			}
			Else
			{
				[int]$UsersPasswordExpired = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tAll users password never expires"
			$Results = $Users | Where {$_.PasswordNeverExpires -eq $True}
		
			If($Results -eq $Null)
			{
				[int]$UsersPasswordNeverExpires = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$UsersPasswordNeverExpires = $Results.Count
			}
			Else
			{
				[int]$UsersPasswordNeverExpires = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tAll users password not required"
			$Results = $Users | Where {$_.PasswordNotRequired -eq $True}
		
			If($Results -eq $Null)
			{
				[int]$UsersPasswordNotRequired = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$UsersPasswordNotRequired = $Results.Count
			}
			Else
			{
				[int]$UsersPasswordNotRequired = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tAll users who cannot change password"
			$Results = $Users | Where {$_.CannotChangePassword -eq $True}
		
			If($Results -eq $Null)
			{
				[int]$UsersCannotChangePassword = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$UsersCannotChangePassword = $Results.Count
			}
			Else
			{
				[int]$UsersCannotChangePassword = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tAll users with SID History"
			$Results = $Null
			$Results = Get-ADObject -LDAPFilter "(sIDHistory=*)" -Server $Domain -Property objectClass, sIDHistory

			If($Results -eq $Null)
			{
				[int]$UsersWithSIDHistory = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$UsersWithSIDHistory = ($Results | Where {$_.objectClass -eq 'user'}).Count
			}
			Else
			{
				[int]$UserssWithSIDHistory = 1
			}

			#active users now
			Write-Verbose "$(Get-Date): `t`t`tActive users"
			$EnabledUsers = $Users | Where {$_.Enabled -eq $True}
		
			If($EnabledUsers -eq $Null)
			{
				[int]$ActiveUsersCount = 0
			}
			ElseIf($EnabledUsers -is [array])
			{
				[int]$ActiveUsersCount = $EnabledUsers.Count
			}
			Else
			{
				[int]$ActiveUsersCount = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tActive users password expired"
			$Results = $EnabledUsers | Where {$_.PasswordExpired -eq $True}
		
			If($Results -eq $Null)
			{
				[int]$ActiveUsersPasswordExpired = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$ActiveUsersPasswordExpired = $Results.Count
			}
			Else
			{
				[int]$ActiveUsersPasswordExpired = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tActive users password never expires"
			$Results = $EnabledUsers | Where {$_.PasswordNeverExpires -eq $True}
		
			If($Results -eq $Null)
			{
				[int]$ActiveUsersPasswordNeverExpires = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$ActiveUsersPasswordNeverExpires = $Results.Count
			}
			Else
			{
				[int]$ActiveUsersPasswordNeverExpires = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tActive users password not required"
			$Results = $EnabledUsers | Where {$_.PasswordNotRequired -eq $True}
		
			If($Results -eq $Null)
			{
				[int]$ActiveUsersPasswordNotRequired = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$ActiveUsersPasswordNotRequired = $Results.Count
			}
			Else
			{
				[int]$ActiveUsersPasswordNotRequired = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tActive Users cannot change password"
			$Results = $EnabledUsers | Where {$_.CannotChangePassword -eq $True}
		
			If($Results -eq $Null)
			{
				[int]$ActiveUsersCannotChangePassword = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$ActiveUsersCannotChangePassword = $Results.Count
			}
			Else
			{
				[int]$ActiveUsersCannotChangePassword = 1
			}

			Write-Verbose "$(Get-Date): `t`t`tActive Users no lastLogonTimestamp"
			$Results = $EnabledUsers | Where {$_.lastLogonTimestamp -eq $Null}
		
			If($Results -eq $Null)
			{
				[int]$ActiveUserslastLogonTimestamp = 0
			}
			ElseIf($Results -is [array])
			{
				[int]$ActiveUserslastLogonTimestamp = $Results.Count
			}
			Else
			{
				[int]$ActiveUserslastLogonTimestamp = 1
			}
		}
		Else
		{
			[int]$UsersCount = 0
			[int]$UsersDisabled = 0
			[int]$UsersLockedOut = 0
			[int]$UsersPasswordExpired = 0
			[int]$UsersPasswordNeverExpires = 0
			[int]$UsersPasswordNotRequired = 0
			[int]$UsersCannotChangePassword = 0
			[int]$UsersWithSIDHistory = 0
			[int]$ActiveUsersCount = 0
			[int]$ActiveUsersPasswordExpired = 0
			[int]$ActiveUsersPasswordNeverExpires = 0
			[int]$ActiveUsersPasswordNotRequired = 0
			[int]$ActiveUsersCannotChangePassword = 0
			[int]$ActiveUserslastLogonTimestamp = 0
		}

		Write-Verbose "$(Get-Date): `t`tFormat numbers into strings"
		[string]$UsersCountStr = "{0,7:N0}" -f $UsersCount
		[string]$UsersDisabledStr = "{0,7:N0}" -f $UsersDisabled
		[string]$UsersUnknownStr = "{0,7:N0}" -f $UsersUnknown
		[string]$UsersLockedOutStr = "{0,7:N0}" -f $UsersLockedOut
		[string]$UsersPasswordExpiredStr = "{0,7:N0}" -f $UsersPasswordExpired
		[string]$UsersPasswordNeverExpiresStr = "{0,7:N0}" -f $UsersPasswordNeverExpires
		[string]$UsersPasswordNotRequiredStr = "{0,7:N0}" -f $UsersPasswordNotRequired
		[string]$UsersCannotChangePasswordStr = "{0,7:N0}" -f $UsersCannotChangePassword
		[string]$UsersWithSIDHistoryStr = "{0,7:N0}" -f $UsersWithSIDHistory
		[string]$ActiveUsersCountStr = "{0,7:N0}" -f $ActiveUsersCount
		[string]$ActiveUsersPasswordExpiredStr = "{0,7:N0}" -f $ActiveUsersPasswordExpired
		[string]$ActiveUsersPasswordNeverExpiresStr = "{0,7:N0}" -f $ActiveUsersPasswordNeverExpires
		[string]$ActiveUsersPasswordNotRequiredStr = "{0,7:N0}" -f $ActiveUsersPasswordNotRequired
		[string]$ActiveUsersCannotChangePasswordStr = "{0,7:N0}" -f $ActiveUsersCannotChangePassword
		[string]$ActiveUserslastLogonTimestampStr = "{0,7:N0}" -f $ActiveUserslastLogonTimestamp

		Write-Verbose "$(Get-Date): `t`tBuild table for All Users"
		WriteWordLine 3 0 "All Users"
		$TableRange   = $doc.Application.Selection.Range
		[int]$Columns = 3
		[int]$Rows = 9
		$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
		$Table.Style = $Script:MyHash.Word_TableGrid
	
		$Table.Borders.InsideLineStyle = $wdLineStyleSingle
		$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
		$Table.Cell(1,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(1,1).Range.Font.Bold = $True
		$Table.Cell(1,1).Range.Text = "Total Users"
		$Table.Cell(1,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(1,2).Range.Text = $UsersCountStr
		$Table.Cell(2,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(2,1).Range.Font.Bold = $True
		$Table.Cell(2,1).Range.Text = "Disabled users"
		$Table.Cell(2,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(2,2).Range.Text = $UsersDisabledStr
		[single]$pct = (($UsersDisabled / $UsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(2,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(2,3).Range.Text = "$($pctstr)% of Total Users"
		$Table.Cell(3,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(3,1).Range.Font.Bold = $True
		$Table.Cell(3,1).Range.Text = "Unknown users*"
		$Table.Cell(3,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(3,2).Range.Text = $UsersUnknownStr
		[single]$pct = (($UsersUnknown / $UsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(3,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(3,3).Range.Text = "$($pctstr)% of Total Users"
		$Table.Cell(4,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(4,1).Range.Font.Bold = $True
		$Table.Cell(4,1).Range.Text = "Locked out users"
		$Table.Cell(4,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(4,2).Range.Text = $UsersLockedOutStr
		[single]$pct = (($UsersLockedOut / $UsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(4,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(4,3).Range.Text = "$($pctstr)% of Total Users"
		$Table.Cell(5,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(5,1).Range.Font.Bold = $True
		$Table.Cell(5,1).Range.Text = "Password expired"
		$Table.Cell(5,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(5,2).Range.Text = $UsersPasswordExpiredStr
		[single]$pct = (($UsersPasswordExpired / $UsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(5,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(5,3).Range.Text = "$($pctstr)% of Total Users"
		$Table.Cell(6,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(6,1).Range.Font.Bold = $True
		$Table.Cell(6,1).Range.Text = "Password never expires"
		$Table.Cell(6,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(6,2).Range.Text = $UsersPasswordNeverExpiresStr
		[single]$pct = (($UsersPasswordNeverExpires / $UsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(6,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(6,3).Range.Text = "$($pctstr)% of Total Users"
		$Table.Cell(7,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(7,1).Range.Font.Bold = $True
		$Table.Cell(7,1).Range.Text = "Password not required"
		$Table.Cell(7,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(7,2).Range.Text = $UsersPasswordNotRequiredStr
		[single]$pct = (($UsersPasswordNotRequired / $UsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(7,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(7,3).Range.Text = "$($pctstr)% of Total Users"
		$Table.Cell(8,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(8,1).Range.Font.Bold = $True
		$Table.Cell(8,1).Range.Text = "Can't change password"
		$Table.Cell(8,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(8,2).Range.Text = $UsersCannotChangePasswordStr
		[single]$pct = (($UsersCannotChangePassword / $UsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(8,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(8,3).Range.Text = "$($pctstr)% of Total Users"
		$Table.Cell(9,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(9,1).Range.Font.Bold = $True
		$Table.Cell(9,1).Range.Text = "With SID History"
		$Table.Cell(9,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(9,2).Range.Text = $UsersWithSIDHistoryStr
		[single]$pct = (($UsersWithSIDHistory / $UsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(9,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(9,3).Range.Text = "$($pctstr)% of Total Users"

		$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
		$Table.AutoFitBehavior($wdAutoFitContent)

		#return focus back to document
		$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

		#move to the end of the current document
		$selection.EndKey($wdStory,$wdMove) | Out-Null
		$TableRange = $Null
		$Table = $Null

		WriteWordLine 0 0 "*Unknown users are user accounts with no Enabled property." "" $Null 8 $False $True
		If($DARights -eq $False)
		{
			WriteWordLine 0 0 "*Rerun the script with Domain Admin rights in $($ADForest)." "" $Null 8 $False $True
		}
		Else
		{
			WriteWordLine 0 0 "*This may be a permissions issue if this is a Trusted Forest." "" $Null 8 $False $True
		}
		
		Write-Verbose "$(Get-Date): `t`tBuild table for Active Users"
		WriteWordLine 3 0 "Active Users"
		$TableRange   = $doc.Application.Selection.Range
		[int]$Columns = 3
		[int]$Rows = 6
		$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
		$Table.Style = $Script:MyHash.Word_TableGrid
	
		$Table.Borders.InsideLineStyle = $wdLineStyleSingle
		$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
		$Table.Cell(1,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(1,1).Range.Font.Bold = $True
		$Table.Cell(1,1).Range.Text = "Total Active Users"
		$Table.Cell(1,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(1,2).Range.Text = $ActiveUsersCountStr
		$Table.Cell(2,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(2,1).Range.Font.Bold = $True
		$Table.Cell(2,1).Range.Text = "Password expired"
		$Table.Cell(2,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(2,2).Range.Text = $ActiveUsersPasswordExpiredStr
		[single]$pct = (($ActiveUsersPasswordExpired / $ActiveUsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(2,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(2,3).Range.Text = "$($pctstr)% of Active Users"
		$Table.Cell(3,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(3,1).Range.Font.Bold = $True
		$Table.Cell(3,1).Range.Text = "Password never expires"
		$Table.Cell(3,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(3,2).Range.Text = $ActiveUsersPasswordNeverExpiresStr
		[single]$pct = (($ActiveUsersPasswordNeverExpires / $ActiveUsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(3,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(3,3).Range.Text = "$($pctstr)% of Active Users"
		$Table.Cell(4,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(4,1).Range.Font.Bold = $True
		$Table.Cell(4,1).Range.Text = "Password not required"
		$Table.Cell(4,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(4,2).Range.Text = $ActiveUsersPasswordNotRequiredStr
		[single]$pct = (($ActiveUsersPasswordNotRequired / $ActiveUsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(4,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(4,3).Range.Text = "$($pctstr)% of Active Users"
		$Table.Cell(5,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(5,1).Range.Font.Bold = $True
		$Table.Cell(5,1).Range.Text = "Can't change password"
		$Table.Cell(5,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(5,2).Range.Text = $ActiveUsersCannotChangePasswordStr
		[single]$pct = (($ActiveUsersCannotChangePassword / $ActiveUsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(5,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(5,3).Range.Text = "$($pctstr)% of Active Users"
		$Table.Cell(6,1).Shading.BackgroundPatternColor = $wdColorGray15
		$Table.Cell(6,1).Range.Font.Bold = $True
		$Table.Cell(6,1).Range.Text = "No lastLogonTimestamp"
		$Table.Cell(6,2).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(6,2).Range.Text = $ActiveUserslastLogonTimestampStr
		[single]$pct = (($ActiveUserslastLogonTimestamp / $ActiveUsersCount)*100)
		$pctstr = "{0,5:N2}" -f $pct
		$Table.Cell(6,3).Range.ParagraphFormat.Alignment = $wdAlignParagraphRight
		$Table.Cell(6,3).Range.Text = "$($pctstr)% of Active Users"

		$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
		$Table.AutoFitBehavior($wdAutoFitContent)

		#return focus back to document
		$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

		#move to the end of the current document
		$selection.EndKey($wdStory,$wdMove) | Out-Null
		$TableRange = $Null
		$Table = $Null

		#put computer info on a separate page
		$selection.InsertNewPage()
		
		GetComputerCountByOS $Domain
		
	}
	ElseIf(!$?)
	{
		Write-Warning "Error retrieving domain data for domain $($Domain)"
		WriteWordLine 0 0 "Error retrieving domain data for domain $($Domain)" "" $Null 0 $False $True
	}
	Else
	{
		WriteWordLine 0 0 "No Domain data was retrieved for domain $($Domain)" "" $Null 0 $False $True
	}
	$First = $False
}
$Domains = $Null
$DomainInfo = $Null
$Users = $Null
$EnabledUsers = $Null
$Results = $Null
$UsersCountStr = $Null
$UsersDisabledStr = $Null
$UsersUnknownStr = $Null
$UsersLockedOutStr = $Null
$UsersPasswordExpiredStr = $Null
$UsersPasswordNeverExpiresStr = $Null
$UsersPasswordNotRequiredStr = $Null
$UsersCannotChangePasswordStr = $Null
$UsersWithSIDHistoryStr = $Null
$ActiveUsersCountStr = $Null
$ActiveUsersPasswordExpiredStr = $Null
$ActiveUsersPasswordNeverExpiresStr = $Null
$ActiveUsersPasswordNotRequiredStr = $Null
$ActiveUsersCannotChangePasswordStr = $Null
$ActiveUserslastLogonTimestampStr = $Null
$pctstr = $Null

Write-Verbose "$(Get-Date): Finishing up document"
#end of document processing

$AbstractTitle = "Microsoft Active Directory Inventory"
$SubjectTitle = "Active Directory Inventory"
UpdateDocumentProperties $AbstractTitle $SubjectTitle

If($MSWORD -or $PDF)
{
    SaveandCloseDocumentandShutdownWord
}
ElseIf($Text)
{
    SaveandCloseTextDocument
}
ElseIf($HTML)
{
    SaveandCloseHTMLDocument
}

Write-Verbose "$(Get-Date): Script has completed"
Write-Verbose "$(Get-Date): "

If($PDF)
{
	If(Test-Path "$($Script:FileName2)")
	{
		Write-Verbose "$(Get-Date): $($Script:FileName2) is ready for use"
	}
	Else
	{
		Write-Warning "$(Get-Date): Unable to save the output file, $($Script:FileName2)"
		Write-Error "Unable to save the output file, $($Script:FileName2)"
	}
}
Else
{
	If(Test-Path "$($Script:FileName1)")
	{
		Write-Verbose "$(Get-Date): $($Script:FileName1) is ready for use"
	}
	Else
	{
		Write-Warning "$(Get-Date): Unable to save the output file, $($Script:FileName1)"
		Write-Error "Unable to save the output file, $($Script:FileName1)"
	}
}

Write-Verbose "$(Get-Date): "

#http://poshtips.com/measuring-elapsed-time-in-powershell/
Write-Verbose "$(Get-Date): Script started: $($Script:StartTime)"
Write-Verbose "$(Get-Date): Script ended: $(Get-Date)"
$runtime = $(Get-Date) - $Script:StartTime
$Str = [string]::format("{0} days, {1} hours, {2} minutes, {3}.{4} seconds", `
	$runtime.Days, `
	$runtime.Hours, `
	$runtime.Minutes, `
	$runtime.Seconds,
	$runtime.Milliseconds)
Write-Verbose "$(Get-Date): Elapsed time: $($Str)"
$runtime = $Null
$Str = $Null
$ErrorActionPreference = $SaveEAPreference

# SIG # Begin signature block
# MIIiywYJKoZIhvcNAQcCoIIivDCCIrgCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUyaux3729V1yQpSlEN602qwdm
# IxKggh41MIIDtzCCAp+gAwIBAgIQDOfg5RfYRv6P5WD8G/AwOTANBgkqhkiG9w0B
# AQUFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVk
# IElEIFJvb3QgQ0EwHhcNMDYxMTEwMDAwMDAwWhcNMzExMTEwMDAwMDAwWjBlMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3Qg
# Q0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCtDhXO5EOAXLGH87dg
# +XESpa7cJpSIqvTO9SA5KFhgDPiA2qkVlTJhPLWxKISKityfCgyDF3qPkKyK53lT
# XDGEKvYPmDI2dsze3Tyoou9q+yHyUmHfnyDXH+Kx2f4YZNISW1/5WBg1vEfNoTb5
# a3/UsDg+wRvDjDPZ2C8Y/igPs6eD1sNuRMBhNZYW/lmci3Zt1/GiSw0r/wty2p5g
# 0I6QNcZ4VYcgoc/lbQrISXwxmDNsIumH0DJaoroTghHtORedmTpyoeb6pNnVFzF1
# roV9Iq4/AUaG9ih5yLHa5FcXxH4cDrC0kqZWs72yl+2qp/C3xag/lRbQ/6GW6whf
# GHdPAgMBAAGjYzBhMA4GA1UdDwEB/wQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB0G
# A1UdDgQWBBRF66Kv9JLLgjEtUYunpyGd823IDzAfBgNVHSMEGDAWgBRF66Kv9JLL
# gjEtUYunpyGd823IDzANBgkqhkiG9w0BAQUFAAOCAQEAog683+Lt8ONyc3pklL/3
# cmbYMuRCdWKuh+vy1dneVrOfzM4UKLkNl2BcEkxY5NM9g0lFWJc1aRqoR+pWxnmr
# EthngYTffwk8lOa4JiwgvT2zKIn3X/8i4peEH+ll74fg38FnSbNd67IJKusm7Xi+
# fT8r87cmNW1fiQG2SVufAQWbqz0lwcy2f8Lxb4bG+mRo64EtlOtCt/qMHt1i8b5Q
# Z7dsvfPxH2sMNgcWfzd8qVttevESRmCD1ycEvkvOl77DZypoEd+A5wwzZr8TDRRu
# 838fYxAe+o0bJW1sj6W3YQGx0qMmoRBxna3iw/nDmVG3KwcIzi7mULKn+gpFL6Lw
# 8jCCBmowggVSoAMCAQICEAZkAUbpgOAOYKFNj0RKWVgwDQYJKoZIhvcNAQEFBQAw
# YjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQ
# d3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQgQXNzdXJlZCBJRCBD
# QS0xMB4XDTE0MDUyMDAwMDAwMFoXDTE1MDYwMzAwMDAwMFowRzELMAkGA1UEBhMC
# VVMxETAPBgNVBAoTCERpZ2lDZXJ0MSUwIwYDVQQDExxEaWdpQ2VydCBUaW1lc3Rh
# bXAgUmVzcG9uZGVyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqYkY
# 9jz0cTh/7Ea2LfjJAyUlCT023BpNjNgLP54HJlwVkORvGporGxGeg3bTVAcr5INC
# pjtt7PPznWyPVpqBqdnArxE4opqA4pAU/BGXQqZQnS6ps+BIVy8ESRr1110jm6B3
# EOxzxW8a7c3WExRbVdDwQTBGSMAuegKq4A6OEf3jJMowO/mYp7vgJ6lpE8jazn41
# /OFF93zyZBRIQZgDH86IymgeEI/xlKHYbCvwvWuRhZXZO4VMlpAv8S3nWAMjgNTM
# 0ehaplIaEa5jR1qqsz8iYFH2/tK5jQQtP7WrNXXqZNNM+tBAdZIEJqXCLyzh2+vB
# a++Y9NAkNY8ewBQWQQIDAQABo4IDNTCCAzEwDgYDVR0PAQH/BAQDAgeAMAwGA1Ud
# EwEB/wQCMAAwFgYDVR0lAQH/BAwwCgYIKwYBBQUHAwgwggG/BgNVHSAEggG2MIIB
# sjCCAaEGCWCGSAGG/WwHATCCAZIwKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRp
# Z2ljZXJ0LmNvbS9DUFMwggFkBggrBgEFBQcCAjCCAVYeggFSAEEAbgB5ACAAdQBz
# AGUAIABvAGYAIAB0AGgAaQBzACAAQwBlAHIAdABpAGYAaQBjAGEAdABlACAAYwBv
# AG4AcwB0AGkAdAB1AHQAZQBzACAAYQBjAGMAZQBwAHQAYQBuAGMAZQAgAG8AZgAg
# AHQAaABlACAARABpAGcAaQBDAGUAcgB0ACAAQwBQAC8AQwBQAFMAIABhAG4AZAAg
# AHQAaABlACAAUgBlAGwAeQBpAG4AZwAgAFAAYQByAHQAeQAgAEEAZwByAGUAZQBt
# AGUAbgB0ACAAdwBoAGkAYwBoACAAbABpAG0AaQB0ACAAbABpAGEAYgBpAGwAaQB0
# AHkAIABhAG4AZAAgAGEAcgBlACAAaQBuAGMAbwByAHAAbwByAGEAdABlAGQAIABo
# AGUAcgBlAGkAbgAgAGIAeQAgAHIAZQBmAGUAcgBlAG4AYwBlAC4wCwYJYIZIAYb9
# bAMVMB8GA1UdIwQYMBaAFBUAEisTmLKZB+0e36K+Vw0rZwLNMB0GA1UdDgQWBBQ0
# /A9Gfqu32Wtd+FNyReYEkdPC+zB9BgNVHR8EdjB0MDigNqA0hjJodHRwOi8vY3Js
# My5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURDQS0xLmNybDA4oDagNIYy
# aHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEQ0EtMS5j
# cmwwdwYIKwYBBQUHAQEEazBpMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdp
# Y2VydC5jb20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRENBLTEuY3J0MA0GCSqGSIb3DQEBBQUAA4IBAQAQ
# QJCzcZ/wHjsC3D+8TBXnDjkSwIZAFhqgZciTW8MHsKSIRA+QlEdeNcMFsv7YnR7U
# 9Ld+xgchXmYP5TWypB8EKkIw5idPJ2I0wGaUwgIvR3kmSp1KXAS1BEjzK3lJGkcU
# vBblx7hnUCC9rMS0/ashgCxgphurfO8HPEDuaRhN1ifiNFnhKUIjsz1DnW4el8Td
# gvjyoRT4jfxmfWTsQDcBBN5MVU4/0yL4Rs8uWMDLsKW+4OUbi0hcshGRAsy5XOz9
# HnUl/n4lFrosEoQf2/EO+QRTsvhNnAZGM3F1hobjVA/X67PVWK8rWofEoDANM8am
# 8TC+1ft/Nb7G4o/ZGe+UMIIGkDCCBXigAwIBAgIQBKVRftX3ANDrw0+OjYS9xjAN
# BgkqhkiG9w0BAQUFADBvMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQg
# SW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMS4wLAYDVQQDEyVEaWdpQ2Vy
# dCBBc3N1cmVkIElEIENvZGUgU2lnbmluZyBDQS0xMB4XDTExMDkzMDAwMDAwMFoX
# DTE0MTAwODEyMDAwMFowXDELMAkGA1UEBhMCVVMxCzAJBgNVBAgTAlROMRIwEAYD
# VQQHEwlUdWxsYWhvbWExFTATBgNVBAoTDENhcmwgV2Vic3RlcjEVMBMGA1UEAxMM
# Q2FybCBXZWJzdGVyMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz2g4
# Kup2X6Mscbuq96HnetDDiITbncV1LtQ8Rxf8ZtN00+O/TliIZsWtufMq7GsLj1D8
# ikWfcgWGqMngWMsVYB4vdr1B8aQuHmKWld7W+j8FhKp3l+rNuFviTGa62sR6fEVW
# 1N6lDtJJHpfSIg/FUFfAqOKl0gFc45PU7iWCh08+oG5FJdhZ3WY0SosS1QujKEA4
# riSjeXPV6XSLsAHTE/fmHlGuu7NzJyMUzNNz2gPOFxYupHygbduhM5aAItD6GJ1h
# ajlovRt71tAMyeIPWNjj9B2luXxfRbgO9eufw91uFrXnougBPa7/eQ25YdW3NcGf
# tosYjvVI6Ptw/AaSiQIDAQABo4IDOTCCAzUwHwYDVR0jBBgwFoAUe2jOKarAF75J
# euHlP9an90WPNTIwHQYDVR0OBBYEFMHndyU+4pRT+JRECX9EG4y1laDkMA4GA1Ud
# DwEB/wQEAwIHgDATBgNVHSUEDDAKBggrBgEFBQcDAzBzBgNVHR8EbDBqMDOgMaAv
# hi1odHRwOi8vY3JsMy5kaWdpY2VydC5jb20vYXNzdXJlZC1jcy0yMDExYS5jcmww
# M6AxoC+GLWh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9hc3N1cmVkLWNzLTIwMTFh
# LmNybDCCAcQGA1UdIASCAbswggG3MIIBswYJYIZIAYb9bAMBMIIBpDA6BggrBgEF
# BQcCARYuaHR0cDovL3d3dy5kaWdpY2VydC5jb20vc3NsLWNwcy1yZXBvc2l0b3J5
# Lmh0bTCCAWQGCCsGAQUFBwICMIIBVh6CAVIAQQBuAHkAIAB1AHMAZQAgAG8AZgAg
# AHQAaABpAHMAIABDAGUAcgB0AGkAZgBpAGMAYQB0AGUAIABjAG8AbgBzAHQAaQB0
# AHUAdABlAHMAIABhAGMAYwBlAHAAdABhAG4AYwBlACAAbwBmACAAdABoAGUAIABE
# AGkAZwBpAEMAZQByAHQAIABDAFAALwBDAFAAUwAgAGEAbgBkACAAdABoAGUAIABS
# AGUAbAB5AGkAbgBnACAAUABhAHIAdAB5ACAAQQBnAHIAZQBlAG0AZQBuAHQAIAB3
# AGgAaQBjAGgAIABsAGkAbQBpAHQAIABsAGkAYQBiAGkAbABpAHQAeQAgAGEAbgBk
# ACAAYQByAGUAIABpAG4AYwBvAHIAcABvAHIAYQB0AGUAZAAgAGgAZQByAGUAaQBu
# ACAAYgB5ACAAcgBlAGYAZQByAGUAbgBjAGUALjCBggYIKwYBBQUHAQEEdjB0MCQG
# CCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wTAYIKwYBBQUHMAKG
# QGh0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRENv
# ZGVTaWduaW5nQ0EtMS5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOC
# AQEAm1zhveo2Zy2lp8UNpR2E2CE8/NvEk0NDLszcBBuMda3N8Du23CikXCgrVvE0
# 3mMaeu/cIMDVU01ityLaqvDuovmTsvAKqaSJNztV9yTeWK9H4+h+35UEIU5TvYLs
# uzEW+rI5M2KcCXR6/LF9ZPmnBf9hHnK44hweHpmDWbo8HPqMatnIo7ideucuDn/D
# BM6s63eTMsFQCPYwte5vxuyVLqodOubLvIOMezZzByrpvJp9+gWAL151CE4qR6xQ
# jpgk5KqSkkkyvl72D+3PhNwZuxZDbZil5PIcrjmaBYoG8wfJzoNrtPFq3aG8dnQr
# xjXJjl+IN1iHYehBAUoBX98EozCCBqMwggWLoAMCAQICEA+oSQYV1wCgviF2/cXs
# bb0wDQYJKoZIhvcNAQEFBQAwZTELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lD
# ZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEkMCIGA1UEAxMbRGln
# aUNlcnQgQXNzdXJlZCBJRCBSb290IENBMB4XDTExMDIxMTEyMDAwMFoXDTI2MDIx
# MDEyMDAwMFowbzELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IEluYzEZ
# MBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEuMCwGA1UEAxMlRGlnaUNlcnQgQXNz
# dXJlZCBJRCBDb2RlIFNpZ25pbmcgQ0EtMTCCASIwDQYJKoZIhvcNAQEBBQADggEP
# ADCCAQoCggEBAJx8+aCPCsqJS1OaPOwZIn8My/dIRNA/Im6aT/rO38bTJJH/qFKT
# 53L48UaGlMWrF/R4f8t6vpAmHHxTL+WD57tqBSjMoBcRSxgg87e98tzLuIZARR9P
# +TmY0zvrb2mkXAEusWbpprjcBt6ujWL+RCeCqQPD/uYmC5NJceU4bU7+gFxnd7XV
# b2ZklGu7iElo2NH0fiHB5sUeyeCWuAmV+UuerswxvWpaQqfEBUd9YCvZoV29+1aT
# 7xv8cvnfPjL93SosMkbaXmO80LjLTBA1/FBfrENEfP6ERFC0jCo9dAz0eotyS+BW
# tRO2Y+k/Tkkj5wYW8CWrAfgoQebH1GQ7XasCAwEAAaOCA0MwggM/MA4GA1UdDwEB
# /wQEAwIBhjATBgNVHSUEDDAKBggrBgEFBQcDAzCCAcMGA1UdIASCAbowggG2MIIB
# sgYIYIZIAYb9bAMwggGkMDoGCCsGAQUFBwIBFi5odHRwOi8vd3d3LmRpZ2ljZXJ0
# LmNvbS9zc2wtY3BzLXJlcG9zaXRvcnkuaHRtMIIBZAYIKwYBBQUHAgIwggFWHoIB
# UgBBAG4AeQAgAHUAcwBlACAAbwBmACAAdABoAGkAcwAgAEMAZQByAHQAaQBmAGkA
# YwBhAHQAZQAgAGMAbwBuAHMAdABpAHQAdQB0AGUAcwAgAGEAYwBjAGUAcAB0AGEA
# bgBjAGUAIABvAGYAIAB0AGgAZQAgAEQAaQBnAGkAQwBlAHIAdAAgAEMAUAAvAEMA
# UABTACAAYQBuAGQAIAB0AGgAZQAgAFIAZQBsAHkAaQBuAGcAIABQAGEAcgB0AHkA
# IABBAGcAcgBlAGUAbQBlAG4AdAAgAHcAaABpAGMAaAAgAGwAaQBtAGkAdAAgAGwA
# aQBhAGIAaQBsAGkAdAB5ACAAYQBuAGQAIABhAHIAZQAgAGkAbgBjAG8AcgBwAG8A
# cgBhAHQAZQBkACAAaABlAHIAZQBpAG4AIABiAHkAIAByAGUAZgBlAHIAZQBuAGMA
# ZQAuMBIGA1UdEwEB/wQIMAYBAf8CAQAweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUF
# BzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6
# Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5j
# cnQwgYEGA1UdHwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9E
# aWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9jcmw0LmRp
# Z2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwHQYDVR0OBBYE
# FHtozimqwBe+SXrh5T/Wp/dFjzUyMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
# IZ3zbcgPMA0GCSqGSIb3DQEBBQUAA4IBAQB7ch1k/4jIOsG36eepxIe725SS15BZ
# M/orh96oW4AlPxOPm4MbfEPE5ozfOT7DFeyw2jshJXskwXJduEeRgRNG+pw/alE4
# 3rQly/Cr38UoAVR5EEYk0TgPJqFhkE26vSjmP/HEqpv22jVTT8nyPdNs3CPtqqBN
# ZwnzOoA9PPs2TJDndqTd8jq/VjUvokxl6ODU2tHHyJFqLSNPNzsZlBjU1ZwQPNWx
# HBn/j8hrm574rpyZlnjRzZxRFVtCJnJajQpKI5JA6IbeIsKTOtSbaKbfKX8GuTwO
# vZ/EhpyCR0JxMoYJmXIJeUudcWn1Qf9/OXdk8YSNvosesn1oo6WQsQz/MIIGzTCC
# BbWgAwIBAgIQBv35A5YDreoACus/J7u6GzANBgkqhkiG9w0BAQUFADBlMQswCQYD
# VQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGln
# aWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVkIElEIFJvb3QgQ0Ew
# HhcNMDYxMTEwMDAwMDAwWhcNMjExMTEwMDAwMDAwWjBiMQswCQYDVQQGEwJVUzEV
# MBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29t
# MSEwHwYDVQQDExhEaWdpQ2VydCBBc3N1cmVkIElEIENBLTEwggEiMA0GCSqGSIb3
# DQEBAQUAA4IBDwAwggEKAoIBAQDogi2Z+crCQpWlgHNAcNKeVlRcqcTSQQaPyTP8
# TUWRXIGf7Syc+BZZ3561JBXCmLm0d0ncicQK2q/LXmvtrbBxMevPOkAMRk2T7It6
# NggDqww0/hhJgv7HxzFIgHweog+SDlDJxofrNj/YMMP/pvf7os1vcyP+rFYFkPAy
# IRaJxnCI+QWXfaPHQ90C6Ds97bFBo+0/vtuVSMTuHrPyvAwrmdDGXRJCgeGDboJz
# PyZLFJCuWWYKxI2+0s4Grq2Eb0iEm09AufFM8q+Y+/bOQF1c9qjxL6/siSLyaxhl
# scFzrdfx2M8eCnRcQrhofrfVdwonVnwPYqQ/MhRglf0HBKIJAgMBAAGjggN6MIID
# djAOBgNVHQ8BAf8EBAMCAYYwOwYDVR0lBDQwMgYIKwYBBQUHAwEGCCsGAQUFBwMC
# BggrBgEFBQcDAwYIKwYBBQUHAwQGCCsGAQUFBwMIMIIB0gYDVR0gBIIByTCCAcUw
# ggG0BgpghkgBhv1sAAEEMIIBpDA6BggrBgEFBQcCARYuaHR0cDovL3d3dy5kaWdp
# Y2VydC5jb20vc3NsLWNwcy1yZXBvc2l0b3J5Lmh0bTCCAWQGCCsGAQUFBwICMIIB
# Vh6CAVIAQQBuAHkAIAB1AHMAZQAgAG8AZgAgAHQAaABpAHMAIABDAGUAcgB0AGkA
# ZgBpAGMAYQB0AGUAIABjAG8AbgBzAHQAaQB0AHUAdABlAHMAIABhAGMAYwBlAHAA
# dABhAG4AYwBlACAAbwBmACAAdABoAGUAIABEAGkAZwBpAEMAZQByAHQAIABDAFAA
# LwBDAFAAUwAgAGEAbgBkACAAdABoAGUAIABSAGUAbAB5AGkAbgBnACAAUABhAHIA
# dAB5ACAAQQBnAHIAZQBlAG0AZQBuAHQAIAB3AGgAaQBjAGgAIABsAGkAbQBpAHQA
# IABsAGkAYQBiAGkAbABpAHQAeQAgAGEAbgBkACAAYQByAGUAIABpAG4AYwBvAHIA
# cABvAHIAYQB0AGUAZAAgAGgAZQByAGUAaQBuACAAYgB5ACAAcgBlAGYAZQByAGUA
# bgBjAGUALjALBglghkgBhv1sAxUwEgYDVR0TAQH/BAgwBgEB/wIBADB5BggrBgEF
# BQcBAQRtMGswJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBD
# BggrBgEFBQcwAoY3aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
# QXNzdXJlZElEUm9vdENBLmNydDCBgQYDVR0fBHoweDA6oDigNoY0aHR0cDovL2Ny
# bDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9vdENBLmNybDA6oDig
# NoY0aHR0cDovL2NybDQuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0QXNzdXJlZElEUm9v
# dENBLmNybDAdBgNVHQ4EFgQUFQASKxOYspkH7R7for5XDStnAs0wHwYDVR0jBBgw
# FoAUReuir/SSy4IxLVGLp6chnfNtyA8wDQYJKoZIhvcNAQEFBQADggEBAEZQPsm3
# KCSnOB22WymvUs9S6TFHq1Zce9UNC0Gz7+x1H3Q48rJcYaKclcNQ5IK5I9G6OoZy
# rTh4rHVdFxc0ckeFlFbR67s2hHfMJKXzBBlVqefj56tizfuLLZDCwNK1lL1eT7EF
# 0g49GqkUW6aGMWKoqDPkmzmnxPXOHXh2lCVz5Cqrz5x2S+1fwksW5EtwTACJHvzF
# ebxMElf+X+EevAJdqP77BzhPDcZdkbkPZ0XN1oPt55INjbFpjE/7WeAjD9KqrgB8
# 7pxCDs+R1ye3Fu4Pw718CqDuLAhVhSK46xgaTfwqIa1JMYNHlXdx3LEbS0scEJx3
# FMGdTy9alQgpECYxggQAMIID/AIBATCBgzBvMQswCQYDVQQGEwJVUzEVMBMGA1UE
# ChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMS4wLAYD
# VQQDEyVEaWdpQ2VydCBBc3N1cmVkIElEIENvZGUgU2lnbmluZyBDQS0xAhAEpVF+
# 1fcA0OvDT46NhL3GMAkGBSsOAwIaBQCgQDAZBgkqhkiG9w0BCQMxDAYKKwYBBAGC
# NwIBBDAjBgkqhkiG9w0BCQQxFgQUUuOnGI9vkDqPP7dqH+QwhpYrbqQwDQYJKoZI
# hvcNAQEBBQAEggEAp54saqIqQDlwVsc0a2qoysY1IhLe3P2l4oFVloIIJeAGu0y6
# 0qcl0VLZLtidWhJt3Le50TYD+Rc0qY3MkyEC2rWh4HBw5wHB6LVMlNydltTPdWgJ
# V9a0AeTVlej+eSKLMS3HV8puwr0zavt9jyIy8TJ3BPY8bGzQCPIYN58f/PY3e8lX
# auGmp+KpRtcz7Vefw+RSbbFfjH3pu/MMvgZ8w6o66oZyLot3bLye0qPUmiHHRdHb
# kxUtZTvejuMKE+sVG1KIGTjdBPCS2r+8D84UFcfwIm5b8cxh01sDhkMfgRlLGYDs
# zmjPRhKL3NhV+2FR+Is7C3oGfdOzhsww44QRqKGCAg8wggILBgkqhkiG9w0BCQYx
# ggH8MIIB+AIBATB2MGIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xITAfBgNVBAMTGERpZ2lDZXJ0
# IEFzc3VyZWQgSUQgQ0EtMQIQBmQBRumA4A5goU2PREpZWDAJBgUrDgMCGgUAoF0w
# GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQwODA3
# MTIyMTQ0WjAjBgkqhkiG9w0BCQQxFgQUudX8NdrWAda2ZRdKPgRwg52yapYwDQYJ
# KoZIhvcNAQEBBQAEggEAaq3R5es3mrKsidFDSj544mMWQcQHJUQqH982aVNetYPS
# TdfV7Xo1ZMb/pz5DjGqhRZ2fSASnembe0/BHmYrMDxRANqaqp8I7WQCQtxdIX4L+
# MEnks2kL4uKzxd5MtguS6mBJNA9mtjLc35fLdzho/q4TAFKObRqIfSHK4012uMKh
# Kd4NdkjKoiD1GVsXUGT++kw/mxLfVJFPigvYNPpy/fHiuadvWF+3W5s74RX2kdMX
# iBBQpJomC42fz7WeQuyjynH6QU5h1Xb3rHkw/bY1OqN5z+QDfx5PIOejje7xuj2/
# rfQ/BPk4jTkwy2C4Z2dqYuVJUr0HmTFLLToNnxx5NA==
# SIG # End signature block
