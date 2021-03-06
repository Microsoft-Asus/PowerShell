#Generated Form Function
function GenerateForm {
################################################################################################
# ADACLScan.ps1
# 
# AUTHOR: Robin Granberg (robin.granberg@microsoft.com)
#
# THIS CODE-SAMPLE IS PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED 
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR 
# FITNESS FOR A PARTICULAR PURPOSE.
#
# This sample is not supported under any Microsoft standard support program or service. 
# The script is provided AS IS without warranty of any kind. Microsoft further disclaims all
# implied warranties including, without limitation, any implied warranties of merchantability
# or of fitness for a particular purpose. The entire risk arising out of the use or performance
# of the sample and documentation remains with you. In no event shall Microsoft, its authors,
# or anyone else involved in the creation, production, or delivery of the script be liable for 
# any damages whatsoever (including, without limitation, damages for loss of business profits, 
# business interruption, loss of business information, or other pecuniary loss) arising out of 
# the use of or inability to use the sample or documentation, even if Microsoft has been advised 
# of the possibility of such damages.
################################################################################################

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
[reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null
#endregion

#region Generated Form Objects'
$chkBoxGetOwner = New-Object System.Windows.Forms.CheckBox
$chkBoxReplMeta = New-Object System.Windows.Forms.CheckBox
$chkBoxType = New-Object System.Windows.Forms.CheckBox
$chkBoxObject = New-Object System.Windows.Forms.CheckBox
$chkBoxTrustee = New-Object System.Windows.Forms.CheckBox
$lblStyleWin8_1 = New-Object System.Windows.Forms.Panel
$lblStyleWin8_1 = New-Object System.Windows.Forms.Label
$lblStyleWin8_2 = New-Object System.Windows.Forms.Label
$lblStyleWin8_3 = New-Object System.Windows.Forms.Label
$lblStyleWin8_4 = New-Object System.Windows.Forms.Label
$lblStyleWin8_5 = New-Object System.Windows.Forms.Label
$lblHeaderInfo = New-Object System.Windows.Forms.Label
$lblRunScan	= New-Object System.Windows.Forms.Label
$lblConnect	= New-Object System.Windows.Forms.Label
$btnGetObjFullFilter = New-Object System.Windows.Forms.Button 
$gBoxFilter = New-Object System.Windows.Forms.GroupBox
$combObjectFilter = New-Object System.Windows.Forms.ComboBox 
$lblGetObj = New-Object System.Windows.Forms.Label
$lblGetObjExtend = New-Object System.Windows.Forms.Label
$lblAccessCtrl = New-Object System.Windows.Forms.Label
$combAccessCtrl = New-Object System.Windows.Forms.ComboBox
$lblFilterTrusteeExpl = New-Object System.Windows.Forms.Label
$txtFilterTrustee = New-Object System.Windows.Forms.TextBox 
$chkBoxFilter = New-Object System.Windows.Forms.CheckBox
$lblFilterExpl = New-Object System.Windows.Forms.Label
$textBoxResultView  = New-Object System.Windows.Forms.TextBox 
$InitialFormWindowStatePop = New-Object System.Windows.Forms.FormWindowState 
$form1 = New-Object System.Windows.Forms.Form
$txtTempFolder = New-Object System.Windows.Forms.TextBox 
$lblTempFolder = New-Object System.Windows.Forms.Label
$txtCompareTemplate = New-Object System.Windows.Forms.TextBox 
$lblCompareTemplate = New-Object System.Windows.Forms.Label
$lblSelectedNode = New-Object System.Windows.Forms.Label
$lblStatusBar = New-Object System.Windows.Forms.Label
$lblStatusMessage = New-Object System.Windows.Forms.Label
$lblDomain = New-Object System.Windows.Forms.Label
$rdbCustomNC = New-Object System.Windows.Forms.RadioButton
$rdbDSdef = New-Object System.Windows.Forms.RadioButton
$rdbDSConf = New-Object System.Windows.Forms.RadioButton
$rdbDSSchm = New-Object System.Windows.Forms.RadioButton
$btnDSConnect = New-Object System.Windows.Forms.Button 
$gBoxRdbScan = New-Object System.Windows.Forms.GroupBox
$gBoxRdbFile = New-Object System.Windows.Forms.GroupBox
$tabScanTop = New-Object System.Windows.Forms.TabControl
$tabScan = New-Object System.Windows.Forms.TabPage
$tabOfflineScan = New-Object System.Windows.Forms.TabPage
$txtCSVImport = New-Object System.Windows.Forms.TextBox 
$lblCSVImport = New-Object System.Windows.Forms.Label
$chkBoxOneLevel = New-Object System.Windows.Forms.CheckBox
$chkInheritedPerm = New-Object System.Windows.Forms.CheckBox
$chkBoxDefaultPerm = New-Object System.Windows.Forms.CheckBox
$rdbScanOU = New-Object System.Windows.Forms.RadioButton
$rdbScanContainer = New-Object System.Windows.Forms.RadioButton
$rdbScanAll = New-Object System.Windows.Forms.RadioButton
$rdbHTAandCSV = New-Object System.Windows.Forms.RadioButton
$rdbOnlyHTA = New-Object System.Windows.Forms.RadioButton
$rdbOnlyCSV = New-Object System.Windows.Forms.RadioButton
$chkBoxExplicit = New-Object System.Windows.Forms.CheckBox
$btnConfig = New-Object System.Windows.Forms.Button 
$txtBoxSelected = New-Object System.Windows.Forms.TextBox
$txtBoxDomainConnect = New-Object System.Windows.Forms.TextBox
$gBoxNCSelect = New-Object System.Windows.Forms.GroupBox
$gBoxBrowse = New-Object System.Windows.Forms.GroupBox
$rdbBrowseAll = New-Object System.Windows.Forms.RadioButton
$rdbBrowseOU = New-Object System.Windows.Forms.RadioButton
$btnScan = New-Object System.Windows.Forms.Button
$btnCompare = New-Object System.Windows.Forms.Button
$lblHeader = New-Object System.Windows.Forms.Label
$treeView1 = New-Object System.Windows.Forms.TreeView
$btnGetTemplateFolder = New-Object System.Windows.Forms.Button
$btnGetCompareInput = New-Object System.Windows.Forms.Button
$btnExit = New-Object System.Windows.Forms.Button
$btnGetCSVFile = New-Object System.Windows.Forms.Button
$btnConvertCSV = New-Object System.Windows.Forms.Button
$InitialFormWindowState = New-Object System.Windows.Forms.FormWindowState
$gBoxCompare = New-Object System.Windows.Forms.GroupBox
$gBoxImportCSV = New-Object System.Windows.Forms.GroupBox

$txtTempFolder.Text = $CurrentFSPath
$global:bolConnected = $false

$FontSans775 = "Microsoft Sans Serif, 7.75pt"
$FontSans825B = "Microsoft Sans Serif, 8.25pt, style=Bold"
$FontSans75B = "Microsoft Sans Serif, 7.5pt, style=Bold"
$FontSans9B = "Microsoft Sans Serif, 9pt, style=Bold"	
$FontSans9 = "Microsoft Sans Serif, 9pt"	

#----------------------------------------------
#Generated Event Script Blocks
#----------------------------------------------
$FormEvent_Load= 
{
#TODO: Place custom script here
#Add-Type -TypeDefinition @"
New-Type @"
using System;
using System.Windows.Forms;

public class Win32Window : IWin32Window
{
    private IntPtr _hWnd;
    
    public Win32Window(IntPtr handle)
    {
        _hWnd = handle;
    }

    public IntPtr Handle
    {
        get { return _hWnd; }
    }
}
"@ -ReferencedAssemblies "System.Windows.Forms.dll"

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

$owner = New-Object Win32Window -ArgumentList ([System.Diagnostics.Process]::GetCurrentProcess().MainWindowHandle)

}
$btnGetTemplateFolder_OnClick= 
{
  
$strFolderPath = Select-Folder   
$txtTempFolder.Text = $strFolderPath


}
$btnGetCompareInput_OnClick= 
{

$strFilePath = Select-File 
$txtCompareTemplate.Text = $strFilePath


}
$btnGetCSVFile_OnClick= 
{

$strFilePath = Select-File 
$txtCSVImport.Text = $strFilePath


}
$btnDSConnect_OnClick=
{

$global:bolRoot = $true
$treeView1.Nodes.Clear()
$NCSelect = $false
	If ($rdbDSConf.Checked)
	{
        [directoryservices.directoryEntry]$root = (New-Object system.directoryservices.directoryEntry)
        # Try to connect to the Domain root
        &{#Try
        [void]$Root.psbase.get_Name()}
        Trap [SystemException]
        {[boolean] $global:bolRoot = $false 
            $lblStatusMessage.ForeColor = "red"
            $lblStatusMessage.Text = "Failed! Domain does not exist or can not be connected"
            $global:bolConnected = $false; Continue
        }
        if ($global:bolRoot -eq $true)
        {
        $arrADPartitions = GetADPartitions($root.distinguishedName)
        [string] $global:strDomainFqdnName = $arrADPartitions.Item("domain")
        $global:strDomainLongName = $global:strDomainFqdnName.Replace("DC=","")
        $global:strDomainLongName = $global:strDomainLongName.Replace(",",".")
        $global:strDomainShortName = GetDomainShortName $root.distinguishedName 
        $lblStatusMessage.ForeColor = "black"
        $lblStatusMessage.Text = "Connected"
        $strNamingContextDN = $root.distinguishedName
    	$root = New-Object system.directoryservices.directoryEntry("LDAP://$strNamingContextDN") 
    	$arrADPartitions = GetADPartitions($strNamingContextDN)
    	[string] $global:strDomainFqdnName =  $arrADPartitions.Item("domain")
    	$global:strDomainLongName =  $global:strDomainFqdnName.Replace("DC=","")
    	$global:strDomainLongName = $global:strDomainLongName.Replace(",",".")  
              
		$root = New-Object system.directoryservices.directoryEntry("LDAP://"+$arrADPartitions.Item("config")) 
		$strNCShortName = GetNCShortName $root.distinguishedName 
		$global:strDomainShortName = GetDomainShortName $arrADPartitions.Item("domain") 
        $global:Forest = Get-Forest
        $NCSelect = $true
        }
	}
	If ($rdbDSSchm.Checked)
	{
        [directoryservices.directoryEntry]$root = (New-Object system.directoryservices.directoryEntry)
        # Try to connect to the Domain root
        &{#Try
        [void]$Root.psbase.get_Name()}
        Trap [SystemException]
        {[boolean] $global:bolRoot = $false 
            $lblStatusMessage.ForeColor = "red"
            $lblStatusMessage.Text = "Failed! Domain does not exist or can not be connected"
            $global:bolConnected = $false; Continue
        }
        if ($global:bolRoot -eq $true)
        {
        $arrADPartitions = GetADPartitions($root.distinguishedName)
        [string] $global:strDomainFqdnName = $arrADPartitions.Item("domain")
        $global:strDomainLongName = $global:strDomainFqdnName.Replace("DC=","")
        $global:strDomainLongName = $global:strDomainLongName.Replace(",",".")
        $global:strDomainShortName = GetDomainShortName $root.distinguishedName 
        $lblStatusMessage.ForeColor = "black"
        $lblStatusMessage.Text = "Connected"
        $strNamingContextDN = $root.distinguishedName
    	$root = New-Object system.directoryservices.directoryEntry("LDAP://$strNamingContextDN") 
    	$arrADPartitions = GetADPartitions($strNamingContextDN)
    	[string] $global:strDomainFqdnName =  $arrADPartitions.Item("domain")
    	$global:strDomainLongName =  $global:strDomainFqdnName.Replace("DC=","")
    	$global:strDomainLongName = $global:strDomainLongName.Replace(",",".")  
        $root = New-Object system.directoryservices.directoryEntry("LDAP://"+$arrADPartitions.Item("schema")) 
		$strNCShortName = GetNCShortName $root.distinguishedName 
		$global:strDomainShortName = GetDomainShortName $arrADPartitions.Item("domain") 
        $global:Forest = Get-Forest
        $NCSelect = $true
        }
	}
	If ($rdbDSdef.Checked)
	{
        [directoryservices.directoryEntry]$root = (New-Object system.directoryservices.directoryEntry)
        # Try to connect to the Domain root
        &{#Try
        [void]$Root.psbase.get_Name()}
        Trap [SystemException]
        {[boolean] $global:bolRoot = $false 
            $lblStatusMessage.ForeColor = "red"
            $lblStatusMessage.Text = "Failed! Domain does not exist or can not be connected"
            $global:bolConnected = $false; Continue
        }
        if ($global:bolRoot -eq $true)
        {
        $arrADPartitions = GetADPartitions($root.distinguishedName)
        [string] $global:strDomainFqdnName = $arrADPartitions.Item("domain")
        $global:strDomainLongName = $global:strDomainFqdnName.Replace("DC=","")
        $global:strDomainLongName = $global:strDomainLongName.Replace(",",".")
        $global:strDomainShortName = GetDomainShortName $root.distinguishedName 
        $lblStatusMessage.ForeColor = "black"
        $lblStatusMessage.Text = "Connected"
        $strNamingContextDN = $root.distinguishedName
    	$root = New-Object system.directoryservices.directoryEntry("LDAP://$strNamingContextDN") 
    	$arrADPartitions = GetADPartitions($strNamingContextDN)
    	[string] $global:strDomainFqdnName =  $arrADPartitions.Item("domain")
    	$global:strDomainLongName =  $global:strDomainFqdnName.Replace("DC=","")
    	$global:strDomainLongName = $global:strDomainLongName.Replace(",",".")  
    
		$root = New-Object system.directoryservices.directoryEntry("LDAP://"+$arrADPartitions.Item("domain")) 
		$strNCShortName = GetNCShortName $root.distinguishedName 
		$global:strDomainShortName = GetDomainShortName $arrADPartitions.Item("domain")
        $global:Forest = Get-Forest
        $NCSelect = $true
        }
	}
	If ($rdbCustomNC.Checked)
	{        
        if ($txtBoxDomainConnect.Text.Length -gt 0)
        {
            $strNamingContextDN = $txtBoxDomainConnect.Text
            If(CheckDNExist $strNamingContextDN)
            {
                $root = New-Object system.directoryservices.directoryEntry("LDAP://"+$strNamingContextDN)
                $strRootObjectCategory = $root.objectCategory.tostring()
                $strRootObjectCategory = $strRootObjectCategory.Replace("CN=Configuration,",";")
                $global:strDomainFqdnName = $strRootObjectCategory.split(";")[1]
                $global:strDomainLongName = $global:strDomainFqdnName.Replace("DC=","")
                $global:strDomainLongName = $global:strDomainLongName.Replace(",",".")
                $global:strDomainShortName = GetDomainShortName $global:strDomainFqdnName
                $global:Forest = Get-Forest
                $NCSelect = $true
            }
            else
            {
               $lblStatusMessage.ForeColor = "red"
               $lblStatusMessage.Text = "Failed! Domain does not exist or can not be connected"
               $global:bolConnected = $false
            }
        }
        else
        {
               $lblStatusMessage.ForeColor = "red"
               $lblStatusMessage.Text = "Failed! No naming context specified!"      
               $global:bolConnected = $false  
        }
	}  
    If ($NCSelect -eq $true)  
    {
	If (!($strLastCacheGuidsDom -eq $global:strDomainFqdnName))
	{
	    $global:dicRightsGuids = @{"Seed" = "xxx"}
	    CacheRightsGuids $global:strDomainFqdnName
	    $strLastCacheGuidsDom = $global:strDomainFqdnName
        $global:strDomainController = GetConnectedDC $global:strDomainLongName
        
	}
	If ($TNRoot.Nodes.Count -gt 0)
	{
	    $TNRoot.Nodes.Clear()
	}
	$treeView1.Nodes.Clear()
	$TNRoot = new-object System.Windows.Forms.TreeNode("Root") 
	$TNRoot.Name = $root.distinguishedName 
	$TNRoot.Text = $root.name 
	$TNRoot.tag = "NotEnumerated" 
	$TNRoot.ForeColor = "Black"
	# Add all Children found as Sub Nodes to the selected TreeNode 
	$treeView1.add_AfterSelect({ 
		$txtBoxSelected.Text = $this.SelectedNode.Name
		If ($prevNodeText.Length -gt 0){
		$prevNode.ForeColor = "Black"
		}
		$this.SelectedNode.ForeColor = "Blue"
	     if ($this.SelectedNode.tag -eq "NotEnumerated") { 
	     	$lblStatusMessage.ForeColor = "black"
			$lblStatusMessage.Text = "Browsing.."
	      BuildTree $this.SelectedNode 
	      # Set tag to show this node is already enumerated 
	      $this.SelectedNode.tag = "Enumerated" 
	     
	
	    } 
	      [string] $prevNodeText = $this.SelectedNode.name
	      $prevNode = $this.SelectedNode
	      $lblStatusMessage.Text = ""
	   }) 
	[void]$treeView1.Nodes.Add($TNRoot) 
	BuildTree $TNRoot
    $global:bolConnected = $true
    $lblStatusMessage.ForeColor = "black"
    $lblStatusMessage.Text = "Connected"
    }
}


$btnScan_OnClick= 
{
If ($treeView1.SelectedNode.name)
{
    $allSubOU = New-Object System.Collections.ArrayList
    $allSubOU.Clear()
	$lblStatusMessage.Text = "Scanning.."	 
	$BolSkipDefPerm = $chkBoxDefaultPerm.Checked
	$bolCSV = $rdbHTAandCSV.Checked
	$sADobjectName = "LDAP://" + $treeView1.SelectedNode.name.ToString()
	$ADobject =  [ADSI] $sADobjectName
	$strNode = $ADobject.name
			
    $date= get-date -uformat %Y%m%d_%H%M%S
	$strFileCSV = $txtTempFolder.Text + "\" +$strNode + "_" + $global:strDomainShortName + "_adAclOutput" + $date + ".csv" 
	$strFileHTA = $env:temp + "\ACLHTML.hta" 
	$strFileHTM = $env:temp + "\"+"$global:strDomainShortName-$strNode"+".htm" 	
    if(!($rdbOnlyCSV.Checked))
    {			
        if ($chkBoxFilter.checked)
        {
		    CreateHTA "$global:strDomainShortName-$strNode Filtered" $strFileHTA  $strFileHTM $CurrentFSPath
		    CreateHTM "$global:strDomainShortName-$strNode Filtered" $strFileHTM	
        }
        else
        {
            CreateHTA "$global:strDomainShortName-$strNode" $strFileHTA $strFileHTM $CurrentFSPath
		    CreateHTM "$global:strDomainShortName-$strNode" $strFileHTM	
        }
	    InitiateHTM $strFileHTA $chkBoxReplMeta.Checked
	    InitiateHTM $strFileHTM $chkBoxReplMeta.Checked
    }			
	If ($treeView1.SelectedNode.name.ToString().Length -gt 0) {
		If ($chkBoxOneLevel.checked -eq $False)
		{
    
			$allSubOU = GetAllChildNodes($treeView1.SelectedNode.name)
            Get-Perm $allSubOU $global:strDomainShortName $BolSkipDefPerm $chkBoxFilter.checked $chkBoxGetOwner.checked $rdbOnlyCSV.Checked $chkBoxReplMeta.Checked
		}
		else
		{
			$allSubOU = @($treeView1.SelectedNode.name)
            Get-Perm $allSubOU $global:strDomainShortName $BolSkipDefPerm $chkBoxFilter.checked $chkBoxGetOwner.checked $rdbOnlyCSV.Checked $chkBoxReplMeta.Checked			
		}
		$lblStatusMessage.ForeColor = "black"
		$lblStatusMessage.Text = "Done"	
	}
}
else
{
		$lblStatusMessage.ForeColor = "red"
		$lblStatusMessage.Text = "No object selected!"	
}
$allSubOU = ""
$strFileCSV = ""
$strFileHTA = ""
$strFileHTM = ""
$sADobjectName = ""
$date= ""
}
$btnCreateHTML= 
{
 if ($txtCSVImport.Text -eq "")
    {
    	$lblStatusMessage.ForeColor = "red"
        $lblStatusMessage.Text = "No Template CSV file selected!"
    }
    else
    {
     ConvertCSVtoHTM $txtCSVImport.Text
    }

}

$btnCompare_OnClick= 
{
If ($treeView1.SelectedNode.name)
{
    $boolReplMeta = $false
    $allSubOU = New-Object System.Collections.ArrayList
    $allSubOU.Clear()
    if ($txtCompareTemplate.Text -eq "")
    {
    	$lblStatusMessage.ForeColor = "red"
        $lblStatusMessage.Text = "No Template CSV file selected!"
    }
    else
    {
       $strCompareFile = $txtCompareTemplate.Text
       ImportADSettings $strCompareFile
	   $lblStatusMessage.Text = "Scanning.."	 
	   $BolSkipDefPerm = $chkBoxDefaultPerm.Checked
	   $sADobjectName = "LDAP://" + $treeView1.SelectedNode.name.ToString()
	   $ADobject =  [ADSI] $sADobjectName
	   $strNode = $ADobject.Name
	   $strFileHTA = $env:temp + "\ACLHTML.hta" 
	   $strFileHTM = $env:temp + "\"+"$global:strDomainShortName-$strNode"+".htm" 
	   CreateHTM "$global:strDomainShortName-$strNode" $strFileHTM					
       CreateHTA "$global:strDomainShortName-$strNode" $strFileHTA $strFileHTM $CurrentFSPath

        If ($chkBoxReplMeta.Checked -eq $true)
        {
            If ($HistACLs[0].split(";")[13].length -gt 1)
            {
        $boolReplMeta = $true
            }
        }
       InitiateCompareHTM $strFileHTA $boolReplMeta
       InitiateCompareHTM $strFileHTM $boolReplMeta
			
	   If ($treeView1.SelectedNode.name.ToString().Length -gt 0) {
		  If ($chkBoxOneLevel.checked -eq $False)
		  {
			$allSubOU = GetAllChildNodes($treeView1.SelectedNode.name)
            Get-PermCompare $allSubOU $BolSkipDefPerm $chkBoxReplMeta.Checked $chkBoxGetOwner.checked 
		  }
		  else
		  {
			$allSubOU = @($treeView1.SelectedNode.name)
            Get-PermCompare $allSubOU $BolSkipDefPerm $chkBoxReplMeta.Checked $chkBoxGetOwner.checked 
		  }# End If
		  $lblStatusMessage.ForeColor = "black"
		  $lblStatusMessage.Text = "Done"	
	   }# End If

    }# End If          
}
else
{
		$lblStatusMessage.ForeColor = "red"
		$lblStatusMessage.Text = "No object selected!"	
}
$allSubOU = ""
$strFileCSV = ""
$strFileHTA = ""
$strFileHTM = ""
$sADobjectName = ""
$date= ""
}

$btnExit_OnClick= 
{
#TODO: Place custom script here
$form1.close()

}

$btnGetObjFullFilter_OnClick= 
{
    if ($global:bolConnected -eq $true)
    {
        GetSchemaObjectGUID  -Domain $global:strDomainFqdnName
		$lblStatusMessage.ForeColor = "black"
		$lblStatusMessage.Text = "All schema objects and attributes listed!"	        
    }
    else
    {
		$lblStatusMessage.ForeColor = "red"
		$lblStatusMessage.Text = "Connect to your naming context first!"	    
    }
}



foreach ($ldapDisplayName in $global:dicSchemaIDGUIDs.values)
{
    [void]$combObjectFilter.Items.Add($ldapDisplayName)
}

$OnLoadForm_StateCorrection=
{#Correct the initial state of the form to prevent the .Net maximized form issue
	$form1.WindowState = $InitialFormWindowState
}


#----------------------------------------------
#region Generated Form Code
$form1.BackColor = [System.Drawing.Color]::FromArgb(255,235,235,235) 
$form1.Text = "AD ACL Scanner"
$form1.Name = "form1"
$form1.DataBindings.DefaultDataSourceUpdateMode = 0
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 900
$System_Drawing_Size.Height = 700
$form1.ClientSize = $System_Drawing_Size
$form1.add_Load($FormEvent_Load)

	
$lblStyleWin8_1.BackColor = [System.Drawing.Color]::FromArgb(255,255,83,0)
$lblStyleWin8_1.Name = "lblStyleWin8_1"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 595
$System_Drawing_Point.Y = 545
$lblStyleWin8_1.Font = "Webdings, 35pt"	
$lblStyleWin8_1.Location = $System_Drawing_Point
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 60
$lblStyleWin8_1.Size = $System_Drawing_Size
$lblStyleWin8_1.Text = "d"
$lblStyleWin8_1.TextAlign = 'MiddleCenter'
	
$form1.Controls.Add($lblStyleWin8_1)
	
$lblStyleWin8_2.BackColor = [System.Drawing.Color]::FromArgb(255,0,64,128)
$lblStyleWin8_2.ForeColor = 'White'	
$lblStyleWin8_2.Name = "lblStyleWin8_2"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 660
$System_Drawing_Point.Y = 600
$lblStyleWin8_2.Location = $System_Drawing_Point
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 230
$System_Drawing_Size.Height = 70
$lblStyleWin8_2.Size = $System_Drawing_Size
$lblStyleWin8_2.Font = "Microsoft Sans Serif, 9pt, style=Bold"		
$lblStyleWin8_2.Text = "written by robin.granberg@microsoft.com"
	
$form1.Controls.Add($lblStyleWin8_2)

$lblStyleWin8_3.BackColor = [System.Drawing.Color]::FromArgb(255,0,174,239)
$lblStyleWin8_3.Name = "lblStyleWin8_3"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 595
$System_Drawing_Point.Y = 610
$lblStyleWin8_3.Font = "Webdings, 35pt"	
$lblStyleWin8_3.Location = $System_Drawing_Point
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 60
$lblStyleWin8_3.Size = $System_Drawing_Size
$lblStyleWin8_3.Text = "L"
$lblStyleWin8_3.TextAlign = 'MiddleCenter'
	
$form1.Controls.Add($lblStyleWin8_3)

$lblStyleWin8_4.BackColor = [System.Drawing.Color]::FromArgb(255,140,198,0)	
$lblStyleWin8_4.Name = "lblStyleWin8_4"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 660
$System_Drawing_Point.Y = 545
$lblStyleWin8_4.Font = "Webdings, 35pt"	
$lblStyleWin8_4.Location = $System_Drawing_Point
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 60
$System_Drawing_Size.Height = 60
$lblStyleWin8_4.Size = $System_Drawing_Size
$lblStyleWin8_4.Text = "L"
$lblStyleWin8_4.TextAlign = 'MiddleCenter'
	
#$form1.Controls.Add($lblStyleWin8_4)
	
$lblStyleWin8_5.BackColor = [System.Drawing.Color]::FromArgb(255,0,64,128)
$lblStyleWin8_5.ForeColor = 'White'	
$lblStyleWin8_5.Name = "lblStyleWin8_5"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 660
$System_Drawing_Point.Y = 545
$lblStyleWin8_5.Location = $System_Drawing_Point
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 230
$System_Drawing_Size.Height = 60
$lblStyleWin8_5.Size = $System_Drawing_Size
$lblStyleWin8_5.Font = "Microsoft Sans Serif, 13pt, style=Bold"		
$lblStyleWin8_5.Text = "AD ACL Scanner 1.2"
	
$form1.Controls.Add($lblStyleWin8_5)

$gBoxFilter.Name = "gBoxFilter"
$gBoxFilter.Text = "Filter Options"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 280
$System_Drawing_Size.Height = 450
$gBoxFilter.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 620
$System_Drawing_Point.Y = 38
$gBoxFilter.Location = $System_Drawing_Point
$gBoxFilter.DataBindings.DefaultDataSourceUpdateMode = 0

$form1.Controls.Add($gBoxFilter)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 275
$System_Drawing_Size.Height = 450
$tabScanTop.Size = $System_Drawing_Size
$tabScanTop.Text = "Scan Options"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 340
$System_Drawing_Point.Y = 38
$tabScanTop.Location = $System_Drawing_Point
$tabScanTop.Name = "tbPScanTop"
$tabScanTop.DataBindings.DefaultDataSourceUpdateMode = 0

$form1.Controls.Add($tabScanTop)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 266
$System_Drawing_Size.Height = 450
$tabScan.Size = $System_Drawing_Size
$tabScan.Text = "Scan Options"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 340
$System_Drawing_Point.Y = 38
$tabScan.Location = $System_Drawing_Point
$tabScan.Name = "tbPScan"
$tabScan.DataBindings.DefaultDataSourceUpdateMode = 0

$tabScanTop.Controls.Add($tabScan)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 266
$System_Drawing_Size.Height = 450
$tabOfflineScan.Size = $System_Drawing_Size
$tabOfflineScan.Text = "Additional Options"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 340
$System_Drawing_Point.Y = 38
$tabOfflineScan.Location = $System_Drawing_Point
$tabOfflineScan.Name = "tbPOfflineScan"
$tabOfflineScan.DataBindings.DefaultDataSourceUpdateMode = 0

$tabScanTop.Controls.Add($tabOfflineScan)

$gBoxNCSelect.TabIndex = 0
$gBoxNCSelect.Name = "gBoxNCSelect"
$gBoxNCSelect.Text = "Select Naming Context"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 310
$System_Drawing_Size.Height = 120
$gBoxNCSelect.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 38
$gBoxNCSelect.Location = $System_Drawing_Point
$gBoxNCSelect.DataBindings.DefaultDataSourceUpdateMode = 0

$form1.Controls.Add($gBoxNCSelect)

$chkBoxFilter.UseVisualStyleBackColor = $False
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 24
$chkBoxFilter.Size = $System_Drawing_Size
$chkBoxFilter.Text = "Enable Filter"
$chkBoxFilter.Checked = $False
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 18
$chkBoxFilter.Location = $System_Drawing_Point
$chkBoxFilter.CheckState = 0
$chkBoxFilter.DataBindings.DefaultDataSourceUpdateMode = 0
$chkBoxFilter.Name = "chkBoxFilter"


$gBoxFilter.Controls.Add($chkBoxFilter)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 18
$System_Drawing_Size.Height = 24
$chkBoxType.Size = $System_Drawing_Size
$chkBoxType.Text = ""
$chkBoxType.Checked = $False
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 60
$chkBoxType.Location = $System_Drawing_Point
$chkBoxType.CheckState = 0
$chkBoxType.DataBindings.DefaultDataSourceUpdateMode = 0
$chkBoxType.Name = "chkBoxType"


$gBoxFilter.Controls.Add($chkBoxType)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 250
$System_Drawing_Size.Height = 16
$lblAccessCtrl.Size = $System_Drawing_Size
$lblAccessCtrl.Font = $FontSans775
$lblAccessCtrl.Text = "Filter by Access Type:(example: Allow)"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 40
$lblAccessCtrl.Location = $System_Drawing_Point
$lblAccessCtrl.DataBindings.DefaultDataSourceUpdateMode = 0
$lblAccessCtrl.Name = "lblAccessCtrl"

$gBoxFilter.Controls.Add($lblAccessCtrl)

$combAccessCtrl.FormattingEnabled = $True
$combAccessCtrl.Sorted = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 60
$combAccessCtrl.Location = $System_Drawing_Point
$combAccessCtrl.Name = "combAccessCtrl"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 21
$combAccessCtrl.Size = $System_Drawing_Size
[void]$combAccessCtrl.Items.Add("Allow")
[void]$combAccessCtrl.Items.Add("Deny")

$gBoxFilter.Controls.Add($combAccessCtrl)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 250
$System_Drawing_Size.Height = 16
$lblFilterExpl.Size = $System_Drawing_Size
$lblFilterExpl.Font = $FontSans775
$lblFilterExpl.Text = "Filter by Object:(example: user)"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 90
$lblFilterExpl.Location = $System_Drawing_Point
$lblFilterExpl.DataBindings.DefaultDataSourceUpdateMode = 0
$lblFilterExpl.Name = "lblFilterExpl"

$gBoxFilter.Controls.Add($lblFilterExpl)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 18
$System_Drawing_Size.Height = 24
$chkBoxObject.Size = $System_Drawing_Size
$chkBoxObject.Text = ""
$chkBoxObject.Checked = $False
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 110
$chkBoxObject.Location = $System_Drawing_Point
$chkBoxObject.CheckState = 0
$chkBoxObject.DataBindings.DefaultDataSourceUpdateMode = 0
$chkBoxObject.Name = "chkBoxObject"

$gBoxFilter.Controls.Add($chkBoxObject)

$combObjectFilter.FormattingEnabled = $True
$combObjectFilter.Sorted = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 110
$combObjectFilter.Location = $System_Drawing_Point
$combObjectFilter.Name = "combObjectFilter"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 190
$System_Drawing_Size.Height = 21
$combObjectFilter.Size = $System_Drawing_Size

$gBoxFilter.Controls.Add($combObjectFilter)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 265
$System_Drawing_Size.Height = 44
$lblGetObj.Size = $System_Drawing_Size
$lblGetObj.Font = $FontSans775
$lblGetObj.Text = "The list box contains a few  number of standard objects. To load all objects from schema press Load."
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 140
$lblGetObj.Location = $System_Drawing_Point
$lblGetObj.DataBindings.DefaultDataSourceUpdateMode = 0
$lblGetObj.Name = "lblGetObj"

$gBoxFilter.Controls.Add($lblGetObj)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 15
$lblGetObjExtend.Size = $System_Drawing_Size
$lblGetObjExtend.Font = "Microsoft Sans Serif, 7.75pt, style=Bold"	
$lblGetObjExtend.Text = "This may take a while!"
$lblGetObjExtend.ForeColor = "Black"	
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 182
$lblGetObjExtend.Location = $System_Drawing_Point
$lblGetObjExtend.DataBindings.DefaultDataSourceUpdateMode = 0
$lblGetObjExtend.Name = "lblGetObjExtend"

$gBoxFilter.Controls.Add($lblGetObjExtend)	

$btnGetObjFullFilter.Name = "btnGetObjFullFilter"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 23
$btnGetObjFullFilter.Size = $System_Drawing_Size
$btnGetObjFullFilter.UseVisualStyleBackColor = $True
$btnGetObjFullFilter.Font = $FontSans825B 
$btnGetObjFullFilter.Text = "Load"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 160
$System_Drawing_Point.Y = 185
$btnGetObjFullFilter.Location = $System_Drawing_Point
$btnGetObjFullFilter.DataBindings.DefaultDataSourceUpdateMode = 0
$btnGetObjFullFilter.add_Click($btnGetObjFullFilter_OnClick)

$gBoxFilter.Controls.Add($btnGetObjFullFilter)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 270
$System_Drawing_Size.Height = 16
$lblFilterTrusteeExpl.Size = $System_Drawing_Size
$lblFilterTrusteeExpl.Font = $FontSans775
$lblFilterTrusteeExpl.Text = "Filter by Trustee:(example: CONTOSO\User)"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 220
$lblFilterTrusteeExpl.Location = $System_Drawing_Point
$lblFilterTrusteeExpl.DataBindings.DefaultDataSourceUpdateMode = 0
$lblFilterTrusteeExpl.Name = "lblFilterTrusteeExpl"

$gBoxFilter.Controls.Add($lblFilterTrusteeExpl)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 18
$System_Drawing_Size.Height = 24
$chkBoxTrustee.Size = $System_Drawing_Size
$chkBoxTrustee.Text = ""
$chkBoxTrustee.Checked = $False
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 240
$chkBoxTrustee.Location = $System_Drawing_Point
$chkBoxTrustee.CheckState = 0
$chkBoxTrustee.DataBindings.DefaultDataSourceUpdateMode = 0
$chkBoxTrustee.Name = "chkBoxObject"

$gBoxFilter.Controls.Add($chkBoxTrustee)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 245
$System_Drawing_Size.Height = 20
$txtFilterTrustee.Size = $System_Drawing_Size
$txtFilterTrustee.DataBindings.DefaultDataSourceUpdateMode = 0
$txtFilterTrustee.Name = "txtFilterTrustee"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 29
$System_Drawing_Point.Y = 240
$txtFilterTrustee.Location = $System_Drawing_Point
$gBoxFilter.Controls.Add($txtFilterTrustee)

  
$gBoxCompare.Name = "gBoxCompare"
$gBoxCompare.Text = "Compare Options"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 260
$System_Drawing_Size.Height = 120
$gBoxCompare.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 295
$gBoxCompare.Location = $System_Drawing_Point
$gBoxCompare.DataBindings.DefaultDataSourceUpdateMode = 0

$tabScan.Controls.Add($gBoxCompare)

$gBoxImportCSV.Name = "gBoxImportCSV"
$gBoxImportCSV.Text = "CSV to HTML"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 260
$System_Drawing_Size.Height = 160
$gBoxImportCSV.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 10
$gBoxImportCSV.Location = $System_Drawing_Point
$gBoxImportCSV.DataBindings.DefaultDataSourceUpdateMode = 0

$tabOfflineScan.Controls.Add($gBoxImportCSV)


$rdbDSdef.TabIndex = 99
$rdbDSdef.TabStop = $false
$rdbDSdef.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 24
$rdbDSdef.Size = $System_Drawing_Size
$rdbDSdef.Text = "Domain"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 20
$rdbDSdef.Location = $System_Drawing_Point
$rdbDSdef.DataBindings.DefaultDataSourceUpdateMode = 0
$rdbDSdef.Name = "rdbDSdef"
$rdbDSdef.Checked = $true


$gBoxNCSelect.Controls.Add($rdbDSdef)

$rdbCustomNC.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 24
$rdbCustomNC.Size = $System_Drawing_Size
$rdbCustomNC.Text = "Custom"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 230
$System_Drawing_Point.Y = 20
$rdbCustomNC.Location = $System_Drawing_Point
$rdbCustomNC.DataBindings.DefaultDataSourceUpdateMode = 0
$rdbCustomNC.Name = "rdbCustomNC"
$rdbCustomNC.Checked = $false

$gBoxNCSelect.Controls.Add($rdbCustomNC)

$rdbDSConf.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 70
$System_Drawing_Size.Height = 24
$rdbDSConf.Size = $System_Drawing_Size
$rdbDSConf.Text = "Config"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 78
$System_Drawing_Point.Y = 20
$rdbDSConf.Location = $System_Drawing_Point
$rdbDSConf.DataBindings.DefaultDataSourceUpdateMode = 0
$rdbDSConf.Name = "rdbDSConf"
$rdbDSConf.Checked = $False

$gBoxNCSelect.Controls.Add($rdbDSConf)

$rdbDSSchm.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 24
$rdbDSSchm.Size = $System_Drawing_Size
$rdbDSSchm.Text = "Schema"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 150
$System_Drawing_Point.Y = 20
$rdbDSSchm.Location = $System_Drawing_Point
$rdbDSSchm.DataBindings.DefaultDataSourceUpdateMode = 0
$rdbDSSchm.Name = "rdbDSSchm"
$rdbDSSchm.Checked = $False

$gBoxNCSelect.Controls.Add($rdbDSSchm)


$gBoxRdbScan.Name = "gBoxRdbScan"
$gBoxRdbScan.Text = "Report Objects"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 260
$System_Drawing_Size.Height = 50
$gBoxRdbScan.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 100
$gBoxRdbScan.Location = $System_Drawing_Point
$gBoxRdbScan.DataBindings.DefaultDataSourceUpdateMode = 0

$tabScan.Controls.Add($gBoxRdbScan)

$gBoxRdbFile.Name = "gBoxRdbFile"
$gBoxRdbFile.Text = "Output Options"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 260
$System_Drawing_Size.Height = 140
$gBoxRdbFile.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 155
$gBoxRdbFile.Location = $System_Drawing_Point
$gBoxRdbFile.DataBindings.DefaultDataSourceUpdateMode = 0

$tabScan.Controls.Add($gBoxRdbFile)

$chkBoxOneLevel.UseVisualStyleBackColor = $False
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$chkBoxOneLevel.Size = $System_Drawing_Size
$chkBoxOneLevel.Text = "One Level"
$chkBoxOneLevel.Checked = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 9
$chkBoxOneLevel.Location = $System_Drawing_Point
$chkBoxOneLevel.CheckState = 1
$chkBoxOneLevel.DataBindings.DefaultDataSourceUpdateMode = 0
$chkBoxOneLevel.Name = "chkBoxOneLevel"


$tabScan.Controls.Add($chkBoxOneLevel)

$chkInheritedPerm.UseVisualStyleBackColor = $False
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 190
$System_Drawing_Size.Height = 24
$chkInheritedPerm.Size = $System_Drawing_Size
$chkInheritedPerm.Text = "Inherited Permissions"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 30
$chkInheritedPerm.Location = $System_Drawing_Point
$chkInheritedPerm.CheckState = 0
$chkInheritedPerm.DataBindings.DefaultDataSourceUpdateMode = 0
$chkInheritedPerm.Name = "chkInheritedPerm"


$tabScan.Controls.Add($chkInheritedPerm)

$chkBoxGetOwner.UseVisualStyleBackColor = $False
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$chkBoxGetOwner.Size = $System_Drawing_Size
$chkBoxGetOwner.Text = "View Owner"
$chkBoxGetOwner.Checked = $True
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 120
$System_Drawing_Point.Y = 9
$chkBoxGetOwner.Location = $System_Drawing_Point
$chkBoxGetOwner.CheckState = 1
$chkBoxGetOwner.DataBindings.DefaultDataSourceUpdateMode = 0
$chkBoxGetOwner.Name = "chkBoxGetOwner"

$tabScan.Controls.Add($chkBoxGetOwner)

$chkBoxDefaultPerm.UseVisualStyleBackColor = $False
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 182
$System_Drawing_Size.Height = 24
$chkBoxDefaultPerm.Size = $System_Drawing_Size
$chkBoxDefaultPerm.Text = "Skip Default Permissions"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 51
$chkBoxDefaultPerm.Location = $System_Drawing_Point
$chkBoxDefaultPerm.DataBindings.DefaultDataSourceUpdateMode = 0
$chkBoxDefaultPerm.Name = "chkBoxDefaultPerm"

$tabScan.Controls.Add($chkBoxDefaultPerm)


$chkBoxReplMeta.UseVisualStyleBackColor = $False
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 230
$System_Drawing_Size.Height = 20
$chkBoxReplMeta.Size = $System_Drawing_Size
$chkBoxReplMeta.Text = "Replication Metadata"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 9
$System_Drawing_Point.Y = 75
$chkBoxReplMeta.Location = $System_Drawing_Point
$chkBoxReplMeta.CheckState = 0
$chkBoxReplMeta.DataBindings.DefaultDataSourceUpdateMode = 0
$chkBoxReplMeta.Name = "chkBoxReplMeta"

$tabScan.Controls.Add($chkBoxReplMeta)


$rdbScanOU.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 55
$System_Drawing_Size.Height = 24
$rdbScanOU.Size = $System_Drawing_Size
$rdbScanOU.Text = "OUs"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 20
$rdbScanOU.Location = $System_Drawing_Point
$rdbScanOU.DataBindings.DefaultDataSourceUpdateMode = 0
$rdbScanOU.Name = "rdbScanOU"
$rdbScanOU.Checked = $true

$gBoxRdbScan.Controls.Add($rdbScanOU)

$rdbScanContainer.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 95
$System_Drawing_Size.Height = 24
$rdbScanContainer.Size = $System_Drawing_Size
$rdbScanContainer.Text = "Containers"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 60
$System_Drawing_Point.Y = 20
$rdbScanContainer.Location = $System_Drawing_Point
$rdbScanContainer.DataBindings.DefaultDataSourceUpdateMode = 0
$rdbScanContainer.Name = "rdbScanContainer"
$rdbScanContainer.Checked = $false

$gBoxRdbScan.Controls.Add($rdbScanContainer)	

$rdbScanAll.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 100
$System_Drawing_Size.Height = 24
$rdbScanAll.Size = $System_Drawing_Size
$rdbScanAll.Text = "All Objects"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 155
$System_Drawing_Point.Y = 20
$rdbScanAll.Location = $System_Drawing_Point
$rdbScanAll.DataBindings.DefaultDataSourceUpdateMode = 0
$rdbScanAll.Name = "rdbScanAll"

$gBoxRdbScan.Controls.Add($rdbScanAll)

$btnGetTemplateFolder.Name = "btnGetTemplateFolder"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 110
$System_Drawing_Size.Height = 23
$btnGetTemplateFolder.Size = $System_Drawing_Size
$btnGetTemplateFolder.UseVisualStyleBackColor = $True
$btnGetTemplateFolder.Font = $FontSans825B 
$btnGetTemplateFolder.Text = "Change Folder"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 140
$System_Drawing_Point.Y = 110
$btnGetTemplateFolder.Location = $System_Drawing_Point
$btnGetTemplateFolder.DataBindings.DefaultDataSourceUpdateMode = 0
$btnGetTemplateFolder.add_Click($btnGetTemplateFolder_OnClick)

$gBoxRdbFile.Controls.Add($btnGetTemplateFolder)

$btnGetCompareInput.Name = "btnGetCompareInput"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 120
$System_Drawing_Size.Height = 23
$btnGetCompareInput.Size = $System_Drawing_Size
$btnGetCompareInput.UseVisualStyleBackColor = $True
$btnGetCompareInput.Font = $FontSans825B 	
$btnGetCompareInput.Text = "Select Template"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 130
$System_Drawing_Point.Y = 60
$btnGetCompareInput.Location = $System_Drawing_Point
$btnGetCompareInput.DataBindings.DefaultDataSourceUpdateMode = 0
$btnGetCompareInput.add_Click($btnGetCompareInput_OnClick)

$gBoxCompare.Controls.Add($btnGetCompareInput)



$btnGetCSVFile.Name = "btnGetCSVFile"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 120
$System_Drawing_Size.Height = 23
$btnGetCSVFile.Size = $System_Drawing_Size
$btnGetCSVFile.UseVisualStyleBackColor = $True
$btnGetCSVFile.Font = $FontSans75B 	
$btnGetCSVFile.Text = "Select CSV"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 120
$System_Drawing_Point.Y = 60
$btnGetCSVFile.Location = $System_Drawing_Point
$btnGetCSVFile.DataBindings.DefaultDataSourceUpdateMode = 0
$btnGetCSVFile.add_Click($btnGetCSVFile_OnClick)

$gBoxImportCsv.Controls.Add($btnGetCSVFile)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 245
$System_Drawing_Size.Height = 20
$txtTempFolder.Size = $System_Drawing_Size
$txtTempFolder.DataBindings.DefaultDataSourceUpdateMode = 0
$txtTempFolder.Name = "txtTempFolder"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 85
$txtTempFolder.Location = $System_Drawing_Point

$gBoxRdbFile.Controls.Add($txtTempFolder)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 158
$System_Drawing_Size.Height = 16
$lblTempFolder.Size = $System_Drawing_Size
$lblTempFolder.Text = "CSV file destination:"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 70
$lblTempFolder.Location = $System_Drawing_Point
$lblTempFolder.DataBindings.DefaultDataSourceUpdateMode = 0
$lblTempFolder.Name = "lblTempFolder"

$gBoxRdbFile.Controls.Add($lblTempFolder)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 158
$System_Drawing_Size.Height = 16
$lblCompareTemplate.Size = $System_Drawing_Size
$lblCompareTemplate.Text = "CSV Template File:"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 19
$lblCompareTemplate.Location = $System_Drawing_Point
$lblCompareTemplate.DataBindings.DefaultDataSourceUpdateMode = 0
$lblCompareTemplate.Name = "lblCompareTemplate"

$gBoxCompare.Controls.Add($lblCompareTemplate)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 220
$System_Drawing_Size.Height = 20
$txtCompareTemplate.Size = $System_Drawing_Size
$txtCompareTemplate.DataBindings.DefaultDataSourceUpdateMode = 0
$txtCompareTemplate.Name = "txtCompareTemplate"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 35
$txtCompareTemplate.Location = $System_Drawing_Point

$gBoxCompare.Controls.Add($txtCompareTemplate)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 220
$System_Drawing_Size.Height = 20
$txtCSVImport.Size = $System_Drawing_Size
$txtCSVImport.DataBindings.DefaultDataSourceUpdateMode = 0
$txtCSVImport.Name = "txtCSVImport"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 35
$txtCSVImport.Location = $System_Drawing_Point

$gBoxImportCSV.Controls.Add($txtCSVImport)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 200
$System_Drawing_Size.Height = 16
$lblCSVImport.Size = $System_Drawing_Size
$lblCSVImport.Text = "This file will be converted HTML:"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 20
$lblCSVImport.Location = $System_Drawing_Point
$lblCSVImport.DataBindings.DefaultDataSourceUpdateMode = 0
$lblCSVImport.Name = "lblCSVImport"

$gBoxImportCSV.Controls.Add($lblCSVImport)

$rdbOnlyHTA.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 101
$System_Drawing_Size.Height = 24
$rdbOnlyHTA.Size = $System_Drawing_Size
$rdbOnlyHTA.Text = "HTML report"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 20
$rdbOnlyHTA.Location = $System_Drawing_Point
$rdbOnlyHTA.DataBindings.DefaultDataSourceUpdateMode = 1
$rdbOnlyHTA.Name = "rdbOnlyHTA"
$rdbOnlyHTA.Checked = $true

$gBoxRdbFile.Controls.Add($rdbOnlyHTA)

$rdbHTAandCSV.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 150
$System_Drawing_Size.Height = 40
$rdbHTAandCSV.Size = $System_Drawing_Size
$rdbHTAandCSV.Text = "HTML report and CSV file"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 104
$System_Drawing_Point.Y = 12
$rdbHTAandCSV.Location = $System_Drawing_Point
$rdbHTAandCSV.DataBindings.DefaultDataSourceUpdateMode = 1
$rdbHTAandCSV.Name = "rdbHTAandCSV"

$gBoxRdbFile.Controls.Add($rdbHTAandCSV)

$rdbOnlyCSV.UseVisualStyleBackColor = $True
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 97
$System_Drawing_Size.Height = 24
$rdbOnlyCSV.Size = $System_Drawing_Size
$rdbOnlyCSV.Text = "CSV file"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 40
$rdbOnlyCSV.Location = $System_Drawing_Point
$rdbOnlyCSV.DataBindings.DefaultDataSourceUpdateMode = 1
$rdbOnlyCSV.Name = "rdbOnlyCSV"
$rdbOnlyCSV.Checked = $false

$gBoxRdbFile.Controls.Add($rdbOnlyCSV)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 90
$System_Drawing_Size.Height = 20
$lblDomain.Size = $System_Drawing_Size
$lblDomain.Text = "Custom NC:"
$lblDomain.ForeColor = [System.Drawing.Color]::FromArgb(0,0,0,0)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 45
$lblDomain.Location = $System_Drawing_Point
$lblDomain.DataBindings.DefaultDataSourceUpdateMode = 0
$lblDomain.Name = "lblDomain"

$gBoxNCSelect.Controls.Add($lblDomain)

$txtBoxDomainConnect.TabStop = $false
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 230
$System_Drawing_Size.Height = 20
$txtBoxDomainConnect.Size = $System_Drawing_Size
$txtBoxDomainConnect.DataBindings.DefaultDataSourceUpdateMode = 0
$txtBoxDomainConnect.Name = "txtBoxDomainConnect"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 65
$txtBoxDomainConnect.Location = $System_Drawing_Point

$gBoxNCSelect.Controls.Add($txtBoxDomainConnect)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 225
$System_Drawing_Size.Height = 28
$lblConnect.Size = $System_Drawing_Size
$lblConnect.Font = $FontSans775
$lblConnect.Text = "First click Connect to connect to a domain."
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 80
$System_Drawing_Point.Y = 90
$lblConnect.Location = $System_Drawing_Point
$lblConnect.DataBindings.DefaultDataSourceUpdateMode = 0
$lblConnect.Name = "lblConnect"

$btnDSConnect.TabIndex = 1
$btnDSConnect.Name = "btnDSConnect"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 23
$btnDSConnect.Size = $System_Drawing_Size
$btnDSConnect.UseVisualStyleBackColor = $True
$btnDSConnect.Font = $FontSans825B 		
$btnDSConnect.Text = "Connect"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 3
$System_Drawing_Point.Y = 90
$btnDSConnect.Location = $System_Drawing_Point
$btnDSConnect.DataBindings.DefaultDataSourceUpdateMode = 0
$btnDSConnect.add_Click($btnDSConnect_OnClick)


$gBoxNCSelect.Controls.Add($btnDSConnect)


$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 550
$System_Drawing_Size.Height = 20
$txtBoxSelected.Size = $System_Drawing_Size
$txtBoxSelected.DataBindings.DefaultDataSourceUpdateMode = 0
$txtBoxSelected.Name = "txtBoxSelected"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 590
$txtBoxSelected.Location = $System_Drawing_Point

$form1.Controls.Add($txtBoxSelected)


$gBoxBrowse.Name = "gBoxBrowse"
$gBoxBrowse.Text = "Browse Options"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 310
$System_Drawing_Size.Height = 51
$gBoxBrowse.Size = $System_Drawing_Size
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 160
$gBoxBrowse.Location = $System_Drawing_Point
$gBoxBrowse.DataBindings.DefaultDataSourceUpdateMode = 0

$form1.Controls.Add($gBoxBrowse)

$rdbBrowseAll.Name = "rdbBrowseAll"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 98
$System_Drawing_Size.Height = 24
$rdbBrowseAll.Size = $System_Drawing_Size
$rdbBrowseAll.UseVisualStyleBackColor = $True

$rdbBrowseAll.Text = "All Objects"

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 68
$System_Drawing_Point.Y = 19
$rdbBrowseAll.Location = $System_Drawing_Point
$rdbBrowseAll.DataBindings.DefaultDataSourceUpdateMode = 0


$gBoxBrowse.Controls.Add($rdbBrowseAll)


$rdbBrowseOU.Name = "rdbBrowseOU"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 104
$System_Drawing_Size.Height = 24
$rdbBrowseOU.Size = $System_Drawing_Size
$rdbBrowseOU.UseVisualStyleBackColor = $True

$rdbBrowseOU.Text = "OU''s"
$rdbBrowseOU.Checked = $true

$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 6
$System_Drawing_Point.Y = 19
$rdbBrowseOU.Location = $System_Drawing_Point
$rdbBrowseOU.DataBindings.DefaultDataSourceUpdateMode = 0

$gBoxBrowse.Controls.Add($rdbBrowseOU)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 200
$System_Drawing_Size.Height = 90
$lblRunScan.Size = $System_Drawing_Size
$lblRunScan.Font = $FontSans9B			
$lblRunScan.Text = "1.Select a naming context.`n2.Connect to a naming context.`n3.Select a node.`n4.Press Run Scan."
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 340
$System_Drawing_Point.Y = 490
$lblRunScan.Location = $System_Drawing_Point
$lblRunScan.DataBindings.DefaultDataSourceUpdateMode = 0
$lblRunScan.Name = "lblRunScan"

$Form1.Controls.Add($lblRunScan)

$btnScan.TabIndex = 2
$btnScan.Name = "btnScan"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 85
$System_Drawing_Size.Height = 23
$btnScan.Size = $System_Drawing_Size
$btnScan.UseVisualStyleBackColor = $True
$btnScan.Font = $FontSans825B 			
$btnScan.Text = "Run Scan"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 590
$System_Drawing_Point.Y = 510
$btnScan.Location = $System_Drawing_Point
$btnScan.DataBindings.DefaultDataSourceUpdateMode = 0
$btnScan.add_Click($btnScan_OnClick)

$Form1.Controls.Add($btnScan)

$btnCompare.Name = "btnCompare"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 120
$System_Drawing_Size.Height = 23
$btnCompare.Size = $System_Drawing_Size
$btnCompare.UseVisualStyleBackColor = $True
$btnCompare.Font = $FontSans825B 				
$btnCompare.Text = "Run Compare"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 130
$System_Drawing_Point.Y = 90
$btnCompare.Location = $System_Drawing_Point
$btnCompare.DataBindings.DefaultDataSourceUpdateMode = 0
$btnCompare.add_Click($btnCompare_OnClick)

$gBoxCompare.Controls.Add($btnCompare)

$btnConvertCSV.Name = "btnConvertCSV"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 125
$System_Drawing_Size.Height = 23
$btnConvertCSV.Size = $System_Drawing_Size
$btnConvertCSV.UseVisualStyleBackColor = $True
$btnConvertCSV.Font = $FontSans75B 				
$btnConvertCSV.Text = "Create HTML View"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 120
$System_Drawing_Point.Y = 90
$btnConvertCSV.Location = $System_Drawing_Point
$btnConvertCSV.DataBindings.DefaultDataSourceUpdateMode = 0
$btnConvertCSV.add_Click($btnCreateHTML)

$gBoxImportCSV.Controls.Add($btnConvertCSV)

$lblHeaderInfo.BackColor = [System.Drawing.Color]::FromArgb(255,0,0,0)
$lblHeaderInfo.ForeColor = 'White'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 500
$System_Drawing_Size.Height = 20
$lblHeaderInfo.Size = $System_Drawing_Size
$lblHeaderInfo.Font = $FontSans9			
$lblHeaderInfo.Text = "A Tool To Create Reports of Access Control Lists In Active Directory"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 380
$System_Drawing_Point.Y = 18
$lblHeaderInfo.Location = $System_Drawing_Point
$lblHeaderInfo.DataBindings.DefaultDataSourceUpdateMode = 0
$lblHeaderInfo.Name = "lblRunScan"

$Form1.Controls.Add($lblHeaderInfo)
	
$lblHeader.BackColor = [System.Drawing.Color]::FromArgb(255,0,0,0)
$lblHeader.ForeColor = 'White'
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 900
$System_Drawing_Size.Height = 38
$lblHeader.Size = $System_Drawing_Size
$lblHeader.Text = "AD ACL Scanner"
$lblHeader.Font = New-Object System.Drawing.Font("Microsoft Sans Serif",18,1,3,1)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 0
$System_Drawing_Point.Y = 0
$lblHeader.Location = $System_Drawing_Point
$lblHeader.DataBindings.DefaultDataSourceUpdateMode = 0
$lblHeader.Name = "lblHeader"

$form1.Controls.Add($lblHeader)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 309
$System_Drawing_Size.Height = 355
$treeView1.Size = $System_Drawing_Size
$treeView1.Name = "treeView1"
$treeView1.BackColor = [System.Drawing.Color]::FromArgb(255,255,255,255)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 220
$treeView1.Location = $System_Drawing_Point
$treeView1.DataBindings.DefaultDataSourceUpdateMode = 0

$form1.Controls.Add($treeView1)

$lblStatusMessage.BackColor = [System.Drawing.Color]::FromArgb(255,255,255,255)
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 550
$System_Drawing_Size.Height = 20
$lblStatusMessage.Size = $System_Drawing_Size
$lblStatusMessage.Text = "Not Connected"
$lblStatusMessage.Font = $FontSans9B	
$lblStatusMessage.ForeColor = [System.Drawing.Color]::FromArgb(0,0,0,0)
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 630
$lblStatusMessage.Location = $System_Drawing_Point
$lblStatusMessage.DataBindings.DefaultDataSourceUpdateMode = 0
$lblStatusMessage.Name = "lblStatusMessage"

$form1.Controls.Add($lblStatusMessage)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 158
$System_Drawing_Size.Height = 16
$lblSelectedNode.Size = $System_Drawing_Size
$lblSelectedNode.Text = "Selected Object:"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 575
$lblSelectedNode.Location = $System_Drawing_Point
$lblSelectedNode.DataBindings.DefaultDataSourceUpdateMode = 0
$lblSelectedNode.Name = "lblSelectedNode"

$form1.Controls.Add($lblSelectedNode)

$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 158
$System_Drawing_Size.Height = 16
$lblStatusBar.Size = $System_Drawing_Size
$lblStatusBar.Text = "Status Message:"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 25
$System_Drawing_Point.Y = 615
$lblStatusBar.Location = $System_Drawing_Point
$lblStatusBar.DataBindings.DefaultDataSourceUpdateMode = 0
$lblStatusBar.Name = "lblStatusBar"

$form1.Controls.Add($lblStatusBar)

$btnExit.TabIndex = 3
$btnExit.Name = "btnExit"
$System_Drawing_Size = New-Object System.Drawing.Size
$System_Drawing_Size.Width = 75
$System_Drawing_Size.Height = 23
$btnExit.Size = $System_Drawing_Size
$btnExit.UseVisualStyleBackColor = $True
$btnExit.Font = $FontSans825B 	
$btnExit.Text = "Exit"
$System_Drawing_Point = New-Object System.Drawing.Point
$System_Drawing_Point.X = 730
$System_Drawing_Point.Y = 510
$btnExit.Location = $System_Drawing_Point
$btnExit.DataBindings.DefaultDataSourceUpdateMode = 0
$btnExit.add_Click($btnExit_OnClick)

$form1.Controls.Add($btnExit)



#endregion Generated Form Code

#Save the initial state of the form
$InitialFormWindowState = $form1.WindowState
#Init the OnLoad event to correct the initial state of the form
$form1.add_Load($OnLoadForm_StateCorrection)
#Show the Form
$form1.ShowDialog()| Out-Null

} #End Function

Function BuildSchemaDic
{
$global:dicSchemaIDGUIDs = @{"BF967ABA-0DE6-11D0-A285-00AA003049E2" ="user";`
"BF967A86-0DE6-11D0-A285-00AA003049E2" = "computer";`
"BF967A9C-0DE6-11D0-A285-00AA003049E2" = "group";`
"BF967ABB-0DE6-11D0-A285-00AA003049E2" = "volume";`
"F30E3BBE-9FF0-11D1-B603-0000F80367C1" = "gPLink";`
"F30E3BBF-9FF0-11D1-B603-0000F80367C1" = "gPOptions";`
"BF967AA8-0DE6-11D0-A285-00AA003049E2" = "printQueue";`
"4828CC14-1437-45BC-9B07-AD6F015E5F28" = "inetOrgPerson";`
"5CB41ED0-0E4C-11D0-A286-00AA003049E2" = "contact";`
"BF967AA5-0DE6-11D0-A285-00AA003049E2" = "organizationalUnit";`
"BF967A0A-0DE6-11D0-A285-00AA003049E2" = "pwdLastSet"}

$global:dicNameToSchemaIDGUIDs = @{"user"="BF967ABA-0DE6-11D0-A285-00AA003049E2";`
"computer" = "BF967A86-0DE6-11D0-A285-00AA003049E2";`
"group" = "BF967A9C-0DE6-11D0-A285-00AA003049E2";`
"volume" = "BF967ABB-0DE6-11D0-A285-00AA003049E2";`
"gPLink" = "F30E3BBE-9FF0-11D1-B603-0000F80367C1";`
"gPOptions" = "F30E3BBF-9FF0-11D1-B603-0000F80367C1";`
"printQueue" = "BF967AA8-0DE6-11D0-A285-00AA003049E2";`
"inetOrgPerson" = "4828CC14-1437-45BC-9B07-AD6F015E5F28";`
"contact" = "5CB41ED0-0E4C-11D0-A286-00AA003049E2";`
"organizationalUnit" = "BF967AA5-0DE6-11D0-A285-00AA003049E2";`
"pwdLastSet" = "BF967A0A-0DE6-11D0-A285-00AA003049E2"}
}
BuildSchemaDic
$global:dicRightsGuids = @{"Seed" = "xxx"}
$global:dicSidToName = @{"Seed" = "xxx"} 
$global:dicDCSpecialSids =@{"BUILTIN\Incoming Forest Trust Builders"="S-1-5-32-557";`
"BUILTIN\Account Operators"="S-1-5-32-548";`
"BUILTIN\Server Operators"="S-1-5-32-549";`
"BUILTIN\Pre-Windows 2000 Compatible Access"="S-1-5-32-554";`
"BUILTIN\Terminal Server License Servers"="S-1-5-32-561";`
"BUILTIN\Windows Authorization Access Group"="S-1-5-32-560"}
$global:dicWellKnownSids = @{"S-1-0"="Null Authority";`
"S-1-0-0"="Nobody";`
"S-1-1"="World Authority";`
"S-1-1-0"="Everyone";`
"S-1-2"="Local Authority";`
"S-1-2-0"="Local ";`
"S-1-2-1"="Console Logon ";`
"S-1-3"="Creator Authority";`
"S-1-3-0"="Creator Owner";`
"S-1-3-1"="Creator Group";`
"S-1-3-2"="Creator Owner Server";`
"S-1-3-3"="Creator Group Server";`
"S-1-3-4"="Owner Rights ";`
"S-1-4"="Non-unique Authority";`
"S-1-5"="NT Authority";`
"S-1-5-1"="Dialup";`
"S-1-5-2"="Network";`
"S-1-5-3"="Batch";`
"S-1-5-4"="Interactive";`
"S-1-5-6"="Service";`
"S-1-5-7"="Anonymous";`
"S-1-5-8"="Proxy";`
"S-1-5-9"="Enterprise Domain Controllers";`
"S-1-5-10"="Principal Self";`
"S-1-5-11"="Authenticated Users";`
"S-1-5-12"="Restricted Code";`
"S-1-5-13"="Terminal Server Users";`
"S-1-5-14"="Remote Interactive Logon ";`
"S-1-5-15"="This Organization ";`
"S-1-5-17"="IUSR";`
"S-1-5-18"="Local System";`
"S-1-5-19"="NT Authority";`
"S-1-5-20"="NT Authority";`
"S-1-5-22"="ENTERPRISE READ-ONLY DOMAIN CONTROLLERS BETA";`
"S-1-5-32-544"="Administrators";`
"S-1-5-32-545"="Users";`
"S-1-5-32-546"="Guests";`
"S-1-5-32-547"="Power Users";`
"S-1-5-32-548"="Account Operators";`
"S-1-5-32-549"="Server Operators";`
"S-1-5-32-550"="Print Operators";`
"S-1-5-32-551"="Backup Operators";`
"S-1-5-32-552"="Replicator";`
"S-1-5-32-554"="BUILTIN\Pre-Windows 2000 Compatible Access";`
"S-1-5-32-555"="BUILTIN\Remote Desktop Users";`
"S-1-5-32-556"="BUILTIN\Network Configuration Operators";`
"S-1-5-32-557"="BUILTIN\Incoming Forest Trust Builders";`
"S-1-5-32-558"="BUILTIN\Performance Monitor Users";`
"S-1-5-32-559"="BUILTIN\Performance Log Users";`
"S-1-5-32-560"="BUILTIN\Windows Authorization Access Group";`
"S-1-5-32-561"="BUILTIN\Terminal Server License Servers";`
"S-1-5-32-562"="BUILTIN\Distributed COM Users";`
"S-1-5-32-568"="BUILTIN\IIS_IUSRS";`
"S-1-5-32-569"="BUILTIN\Cryptographic Operators";`
"S-1-5-32-573"="BUILTIN\Event Log Readers ";`
"S-1-5-32-574"="BUILTIN\Certificate Service DCOM Access";`
"S-1-5-32-575"="BUILTIN\RDS Remote Access Servers";`
"S-1-5-32-576"="BUILTIN\RDS Endpoint Servers";`
"S-1-5-32-577"="BUILTIN\RDS Management Servers";`
"S-1-5-32-578"="BUILTIN\Hyper-V Administrators";`
"S-1-5-32-579"="BUILTIN\Access Control Assistance Operators";`
"S-1-5-32-580"="BUILTIN\Remote Management Users";`
"S-1-5-64-10"="NTLM Authentication";`
"S-1-5-64-14"="SChannel Authentication";`
"S-1-5-64-21"="Digest Authentication";`
"S-1-5-80"="NT Service";`
"S-1-16-0"="Untrusted Mandatory Level";`
"S-1-16-4096"="Low Mandatory Level";`
"S-1-16-8192"="Medium Mandatory Level";`
"S-1-16-8448"="Medium Plus Mandatory Level";`
"S-1-16-12288"="High Mandatory Level";`
"S-1-16-16384"="System Mandatory Level";`
"S-1-16-20480"="Protected Process Mandatory Level";`
"S-1-16-28672"="Secure Process Mandatory Level"}
#==========================================================================
# Function		: Get-Forest 
# Arguments     : string domain controller,credentials
# Returns   	: Forest
# Description   : Get AD Forest
#==========================================================================
function Get-Forest
{
Param($DomainController,[Management.Automation.PSCredential]$Credential)
	if(!$DomainController)
	{
		[DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest()
		return
	  }
	if($Creds)
		{
		$Context = new-object DirectoryServices.ActiveDirectory.DirectoryContext("DirectoryServer",$DomainController,$Creds.UserName,$Creds.GetNetworkCredential().Password)
	}
	else
	{
		$Context = New-Object DirectoryServices.ActiveDirectory.DirectoryContext("DirectoryServer",$DomainController)
	}
	$ojbForest =[DirectoryServices.ActiveDirectory.Forest]::GetForest($Context)

    return $ojbForest
}
#==========================================================================
# Function		: GetConnectedDC
# Arguments     : Domain Name
# Returns   	: Connected Domain Controller
# Description   : Return a domain controller name if connected to one.
#==========================================================================
Function GetConnectedDC{
Param([string] $Domain)

if ($Domain -eq "")
{
    # Connect to RootDSE
    $rootDSE = [ADSI]"LDAP://RootDSE"
    #Connect to the Configuration Naming Context
    $strDomainController = [ADSI]("LDAP://" + $rootDSE.Get("dnsHostName"))
}
else
{
    [void][reflection.assembly]::LoadWithPartialName("System.DirectoryServices.AccountManagement")
    $ctx = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, $Domain)
    $strDomainController = $ctx.ConnectedServer
}

return $strDomainController
}

#==========================================================================
# Function		: GetSchemaObjectGUID
# Arguments     : Object Guid or Rights Guid
# Returns   	: LDAPDisplayName or DisplayName
# Description   : Searches in the dictionaries(Hash) dicRightsGuids and $global:dicSchemaIDGUIDs  and in Schema 
#				for the name of the object or Extended Right, if found in Schema the dicRightsGuids is updated.
#				Then the functions return the name(LDAPDisplayName or DisplayName).
#==========================================================================
Function GetSchemaObjectGUID{
Param([string] $Domain)
	[string] $strOut =""
	[string] $objSchemaRecordset = ""
	[string] $strLDAPname = ""
    
    [void]$combObjectFilter.Items.Clear()
    BuildSchemaDic
    foreach ($ldapDisplayName in $global:dicSchemaIDGUIDs.values)
    {
        [void]$combObjectFilter.Items.Add($ldapDisplayName)
    }
			 if ($Domain -eq "")
			 {
				# Connect to RootDSE
				$rootDSE = [ADSI]"LDAP://RootDSE"
				#Connect to the Configuration Naming Context
				$schemaSearchRoot = [ADSI]("LDAP://" + $rootDSE.Get("schemaNamingContext"))
			 }
			 else
			 {
				$rootDSE = [ADSI]"LDAP://$Domain"
				$schemaSearchRoot = [ADSI]("LDAP://" + $rootDSE.Get("objectCategory"))
				$schemaSearchRoot = $schemaSearchRoot.path.replace("LDAP://CN=Domain-DNS,","")
				$schemaSearchRoot = [ADSI]("LDAP://" + $schemaSearchRoot)
			 }
			 $searcher = new-object System.DirectoryServices.DirectorySearcher($schemaSearchRoot)
			 $searcher.PropertiesToLoad.addrange(('cn','name','distinguishedNAme','lDAPDisplayName','schemaIDGUID'))
			 $searcher.PageSize = 1000
             $searcher.filter = "(&(schemaIDGUID=*))"
			 $colResults = $searcher.FindAll()
 			 $intCounter = 0

	          
		 	foreach ($objResult in $colResults)
			{             
    			$objSchemaObject = $objResult.Properties
				$strLDAPname =$objSchemaObject.item("lDAPDisplayName")[0]
				$guidGUID = [System.GUID]$objSchemaObject.item("schemaIDGUID")[0]
                $strGUID = $guidGUID.toString().toUpper()
				If (!($global:dicSchemaIDGUIDs.ContainsKey($strGUID)))
                {
                    $global:dicSchemaIDGUIDs.Add($strGUID,$strLDAPname)
                    $global:dicNameToSchemaIDGUIDs.Add($strLDAPname,$strGUID)
                    [void]$combObjectFilter.Items.Add($strLDAPname)
                }
				
			 }
        
	return $strOut
}

#==========================================================================
# Function		: Get-ADSchemaClass 
# Arguments     : string class,string domain controller,credentials
# Returns   	: Class Object
# Description   : Get AD Schema Class
#==========================================================================
function Get-ADSchemaClass
{
Param($Class = ".*")

	$ADSchemaClass = $global:Forest.Schema.FindAllClasses() | ?{$_.Name -match "^$Class`$"}
    
    return $ADSchemaClass
}



#==========================================================================
# Function		: CheckDNExist 
# Arguments     : string distinguishedName
# Returns   	: Boolean
# Description   : Check If distinguishedName exist
#==========================================================================
function CheckDNExist
{
Param (
  $sADobjectName
  )
  $sADobjectName = "LDAP://" + $sADobjectName
    $ADobject =  [ADSI] $sADobjectName
    If($ADobject.distinguishedName -eq $null)
    {return $false}
    else
    {return $true}

}
#==========================================================================
# Function		: ReverseString
# Arguments     : string
# Returns   	: string backwards
# Description   : Turn a string backwards
#==========================================================================
Function ReverseString{

param ($string)
ForEach ($char in $string) 
{
    ([regex]::Matches($char,'.','RightToLeft') | ForEach {$_.value}) -join ''
}
 
}


#==========================================================================
# Function		: GetAllChildNodes
# Arguments     : Node distinguishedName 
# Returns   	: List of Nodes
# Description   : Search for a Node and returns distinguishedName
#==========================================================================
function GetAllChildNodes{
param ($firstnode)
$nodelist = New-Object System.Collections.ArrayList
$nodelist2 = New-Object System.Collections.ArrayList
$nodelist.Clear()
$nodelist2.Clear()
# Add all Children found as Sub Nodes to the selected TreeNode 

$strFilterAll = "(&(objectClass=*))"
$strFilterContainer = "(&(|(objectClass=organizationalUnit)(objectClass=container)(objectClass=DomainDNS)(objectClass=dMD)))"
$strFilterOU = "(&(|(objectClass=organizationalUnit)(objectClass=DomainDNS)(objectClass=dMD)))"
$srch = New-Object System.DirectoryServices.DirectorySearcher
$srch.SearchRoot = "GC://$firstnode"
If ($rdbScanAll.checked -eq $true) 
{
	$srch.Filter = $strFilterAll
}
If ($rdbScanOU.checked -eq $true) 
{
	$srch.Filter = $strFilterOU
}
If ($rdbScanContainer.checked -eq $true) 
{
	$srch.Filter = $strFilterContainer
}
$srch.SearchScope = "Subtree"
$srch.PageSize = 1000
$srch.PropertiesToLoad.addrange(('cn','distinguishedNAme'))
foreach ($res in $srch.FindAll())
{
$oNode = $res.GetDirectoryEntry()

[void] $nodelist.Add($(ReverseString -String $oNode.distinguishedName))
}

foreach ($bkwrNode in $($nodelist | Sort-Object))
{
[void] $nodelist2.Add($(ReverseString -String $bkwrNode))

}

return $nodelist2

}

#==========================================================================
# Function		: GetDomainShortName
# Arguments     : domain name 
# Returns   	: N/A
# Description   : Search for short domain name
#==========================================================================
function GetDomainShortName { 
Param($strDomain)
	$objDomain = [ADSI]"LDAP://$strDomain"
	[string]$strDomainObjectCateory = $objDomain.objectCategory
	[array] $dnSplit = $strDomainObjectCateory.split(",")
	$intSplit = ($dnSplit).count -1
	$strConfig = ""
    $intConfig = 0
	$ReturnShortName = ""
	for ($i=$intSplit;$i -ge 0; $i-- )
	{
	 If($dnSplit[$i] -match "CN=Configuration")
	 {
	  	$intConfig = $i
	 	$strDomainConfig = $dnSplit[$i]
	 }
	 If($i -gt $intConfig)
	 {
	 	If ($strConfig.Length -eq 0)
	 	{
	 	$strConfig = $dnSplit[$i]
	 	}
	 	else
	 	{
	 	$strConfig = $dnSplit[$i] + "," + $strConfig
	 	}
	 }
	}
	$strDomainConfig = $strDomainConfig + "," + $strConfig
	$strRootPath = "LDAP://CN=Partitions," + $strDomainConfig
	$root = [ADSI]$strRootPath
	$ads = New-Object System.DirectoryServices.DirectorySearcher($root)
    $ads.PropertiesToLoad.addrange(('cn','distinguishedNAme','nETBIOSName'))
	$ads.filter = "(&(objectClass=crossRef)(nCName=$strDomain))"
	$s = $ads.FindOne()
	If ($s)
	{
		$ReturnShortName = $s.GetDirectoryEntry().nETBIOSName
	}
	else
	{
		$ReturnShortName = ""
	}
return $ReturnShortName
}
#==========================================================================
# Function		: GetNCShortName
# Arguments     : AD NamingContext distinguishedName
# Returns   	: N/A
# Description   : Return CN of NC
#==========================================================================
function GetNCShortName { 
Param($strNode)
	$objNC = [ADSI]"LDAP://$strNode"
	switch -regex ($objNC.objectCategory)
	{
	 "CN=Domain-DNS,CN=Schema,CN=Configuration"
	 {[string]$strNCcn = $objNC.name}
	 "CN=Configuration,CN=Schema,CN=Configuration"
	 {[string]$strNCcn = $objNC.cn}
	 "CN=DMD,CN=Schema,CN=Configuration"
	 {[string]$strNCcn = $objNC.cn}
	}
return $strNCcn
}

#==========================================================================
# Function		: Check-PermDef
# Arguments     : Trustee Name,Right,Allow/Deny,object guid,Inheritance,Inheritance object guid
# Returns   	: Boolean
# Description   : Compares the Security Descriptor with the DefaultSecurity
#==========================================================================
Function Check-PermDef{
Param($objNodeDefSD,
[string]$strTrustee,
[string]$adRights,
[string]$InheritanceType,
[string]$ObjectTypeGUID,
[string]$InheritedObjectTypeGUID,
[string]$ObjectFlags,
[string]$AccessControlType,
[string]$IsInherited,
[string]$InheritedFlags,
[string]$PropFlags)
$SDResult = $false
$Identity = "$strTrustee"

$sdOUDef = $objNodeDefSD | %{$_.DefaultObjectSecurityDescriptor} | %{$objNodeDefSD.DefaultObjectSecurityDescriptor.access} 
$index=0
while($index -le $sdOUDef.count -1) {
			if (($sdOUDef[$index].IdentityReference -eq $strTrustee) -and ($sdOUDef[$index].ActiveDirectoryRights -eq $adRights) -and ($sdOUDef[$index].AccessControlType -eq $AccessControlType) -and ($sdOUDef[$index].ObjectType -eq $ObjectTypeGUID) -and ($sdOUDef[$index].InheritanceType -eq $InheritanceType) -and ($sdOUDef[$index].InheritedObjectType -eq $InheritedObjectTypeGUID))
			{
			$SDResult = $true
			}#} #End If
 $index++
} #End While

return $SDResult

}

#==========================================================================
# Function		: CacheRightsGuids
# Arguments     : none
# Returns   	: nothing
# Description   : Enumerates all Extended Rights and put them in a Hash dicRightsGuids
#==========================================================================
Function CacheRightsGuids([string] $Domain)
{
if (!$Domain)
		{
		# Connect to RootDSE
		$rootDSE = [ADSI]"LDAP://RootDSE"
		#Connect to the Configuration Naming Context
		$configSearchRoot = [ADSI]("LDAP://CN=Extended-Rights," + $rootDSE.Get("configurationNamingContext"))
		}
		else
		{
		$rootDSE = [ADSI]"LDAP://$Domain"
		$configSearchRoot = [ADSI]("LDAP://" + $rootDSE.Get("objectCategory"))
		$configSearchRoot = $configSearchRoot.psbase.path.replace("LDAP://CN=Domain-DNS,CN=Schema,","")
		$configSearchRoot = [ADSI]("LDAP://CN=Extended-Rights," + $configSearchRoot)
		}
		$searcher = new-object System.DirectoryServices.DirectorySearcher($configSearchRoot)
		$searcher.PropertiesToLoad.("cn","name","distinguishedNAme","rightsGuid")
		$searcher.filter = "(&(objectClass=controlAccessRight))"
		$colResults = $searcher.FindAll()
 		$intCounter = 0

	
	foreach ($objResult in $colResults)
	{
		$objExtendedRightsObject = $objResult.Properties
		If (($objExtendedRightsObject.item("validAccesses") -eq 48) -or ($objExtendedRightsObject.item("validAccesses") -eq 256))
		{

		$strRightDisplayName = $objExtendedRightsObject.item("displayName")
		$strRightGuid = $objExtendedRightsObject.item("rightsGuid")
		$strRightGuid = $($strRightGuid).toString()
		$global:dicRightsGuids.Add($strRightGuid,$strRightDisplayName)	
							
		}
		$intCounter++
		}
			 

}
#==========================================================================
# Function		: MapGUIDToMatchingName
# Arguments     : Object Guid or Rights Guid
# Returns   	: LDAPDisplayName or DisplayName
# Description   : Searches in the dictionaries(Hash) dicRightsGuids and $global:dicSchemaIDGUIDs  and in Schema 
#				for the name of the object or Extended Right, if found in Schema the dicRightsGuids is updated.
#				Then the functions return the name(LDAPDisplayName or DisplayName).
#==========================================================================
Function MapGUIDToMatchingName{
Param([string] $strGUIDAsString,[string] $Domain)
	[string] $strOut =""
	[string] $objSchemaRecordset = ""
	[string] $strLDAPname = ""
	If ($strGUIDAsString -eq "") 
	{
	 Break
	 }
	$strGUIDAsString = $strGUIDAsString.toUpper()
	$strOut =""
	if ($global:dicRightsGuids.ContainsKey($strGUIDAsString))
	{
		$strOut =$global:dicRightsGuids.Item($strGUIDAsString)
	}

	If ($strOut -eq "")
	{  #Didn't find a match in extended rights
		If ($global:dicSchemaIDGUIDs.ContainsKey($strGUIDAsString))
		{
			$strOut =$global:dicSchemaIDGUIDs.Item($strGUIDAsString)
		}
		else
		{
		
		 if ($strGUIDAsString -match("^(\{){0,1}[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}(\}){0,1}$"))
		 {
		 	
			 $ConvertGUID = ConvertGUID($strGUIDAsString)
			 if (!($Domain -eq ""))
			 {
				# Connect to RootDSE
				$rootDSE = [ADSI]"LDAP://RootDSE"
				#Connect to the Configuration Naming Context
				$schemaSearchRoot = [ADSI]("LDAP://" + $rootDSE.Get("schemaNamingContext"))
			 }
			 else
			 {
				$rootDSE = [ADSI]"LDAP://$Domain"
				$schemaSearchRoot = [ADSI]("LDAP://" + $rootDSE.Get("objectCategory"))
				$schemaSearchRoot = $schemaSearchRoot.path.replace("LDAP://CN=Domain-DNS,","")
				$schemaSearchRoot = [ADSI]("LDAP://" + $schemaSearchRoot)
			 }
			 $searcher = new-object System.DirectoryServices.DirectorySearcher($schemaSearchRoot)
			 $searcher.PropertiesToLoad.addrange(('cn','name','distinguishedNAme','lDAPDisplayName'))
			 $searcher.filter = "(&(schemaIDGUID=$ConvertGUID))"
			 $Object = $searcher.FindOne()
			 if ($Object)
			 {
				$objSchemaObject = $Object.Properties
				$strLDAPname =$objSchemaObject.item("lDAPDisplayName")[0]
				$global:dicSchemaIDGUIDs.Add($strGUIDAsString.toUpper(),$strLDAPname)
				$strOut=$strLDAPname
				
			 }
		}
	  }
	}
	return $strOut
}
#==========================================================================
# Function		: ConvertGUID
# Arguments     : Object Guid or Rights Guid
# Returns   	: AD Searchable GUID String
# Description   : Convert a GUID to a string

#==========================================================================
 function ConvertGUID($guid)
 {
 
	 $test = "(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})(.{2})"
	 $pattern = '"\$4\$3\$2\$1\$6\$5\$8\$7\$9\$10\$11\$12\$13\$14\$15\$16"'
	 $ConvertGUID = [regex]::Replace($guid.replace("-",""), $test, $pattern).Replace("`"","")
	 return $ConvertGUID
}
#==========================================================================
# Function		: WritePermCSV
# Arguments     : Security Descriptor, OU distinguishedName, Ou put text file
# Returns   	: n/a
# Description   : Writes the SD to a text file.
#==========================================================================
function WritePermCSV($sd,[string]$ou,[string] $fileout, [bool] $ACLMeta,[string]  $strACLDate,[string] $strInvocationID,[string] $strOrgUSN)
{

	$sd  | foreach {
	If ($global:dicDCSpecialSids.ContainsKey($_.IdentityReference.toString()))
	{
		$strAccName = $global:dicDCSpecialSids.Item($_.IdentityReference.toString())
	}
    else
    {
        $strAccName = $_.IdentityReference.toString()
    }
    If ($ACLMeta -eq $true)
    {
	    $ou+";"+`
	    $_.IdentityReference.toString()+";"+`
	    $_.ActiveDirectoryRights.toString()+";"+`
	    $_.InheritanceType.toString()+";"+`
	    $_.ObjectType.toString()+";"+`
	    $_.InheritedObjectType.toString()+";"+`
	    $_.ObjectFlags.toString()+";"+`
	    $_.AccessControlType.toString()+";"+`
	    $_.IsInherited.toString()+";"+`
	    $_.InheritanceFlags.toString()+";"+`
	    $_.PropagationFlags.toString()+";" + `
        $strACLDate.toString()+";" + `
        $strInvocationID.toString()+";" + `
        $strOrgUSN.toString()+";"| Out-File -Append -FilePath $fileout 
    }
    else
    {
	    $ou+";"+`
	    $_.IdentityReference.toString()+";"+`
	    $_.ActiveDirectoryRights.toString()+";"+`
	    $_.InheritanceType.toString()+";"+`
	    $_.ObjectType.toString()+";"+`
	    $_.InheritedObjectType.toString()+";"+`
	    $_.ObjectFlags.toString()+";"+`
	    $_.AccessControlType.toString()+";"+`
	    $_.IsInherited.toString()+";"+`
	    $_.InheritanceFlags.toString()+";"+`
	    $_.PropagationFlags.toString()+";" | Out-File -Append -FilePath $fileout 
    }
	}

}
#==========================================================================
# Function		: ConvertSidTo-Name
# Arguments     : SID string
# Returns   	: Friendly Name of Security Object
# Description   : Try to translate the SID if it fails it try to match a Well-Known.
#==========================================================================
function ConvertSidTo-Name($server,$sid) {
$ID = New-Object System.Security.Principal.SecurityIdentifier($sid)

&{#Try
	$User = $ID.Translate( [System.Security.Principal.NTAccount])
	$strAccName = $User.Value
}
Trap [SystemException]
{
	If ($global:dicWellKnownSids.ContainsKey($sid))
	{
		$strAccName = $global:dicWellKnownSids.Item($sid)
		return $strAccName
	}
	;Continue
} 
If ($global:dicSidToName.ContainsKey($sid))
{
	$strAccName =$global:dicSidToName.Item($sid)
}
else
{
	$objSID = [ADSI]"LDAP://$server/<SID=$sid>"
	$strAccName = $objSID.samAccountName
	$global:dicSidToName.Add($sid,$strAccName)
}
If ($strAccName -eq $nul)
{
	$strAccName =$sid
}

return $strAccName
}

#==========================================================================
# Function		: WriteHTM
# Arguments     : Security Descriptor, OU dn string, Output htm file
# Returns   	: n/a
# Description   : Wites the SD info to a HTM table, it appends info if the file exist
#==========================================================================
function WriteHTM([bool] $bolACLExist,$sd,[string]$ou,[bool] $OUHeader,[string] $strColorTemp,[string] $htmfileout,[bool] $CompareMode,[bool] $FilterMode,[bool] $bolOwner,[string]$strOwner,[bool]$boolReplMetaDate,[string]$strReplMetaDate)
{
$strTHOUColor = "E5CF00"
$strTHColor = "EFAC00"
$strFont =@"
<FONT size="1" face="verdana, hevetica, arial">
"@
$strFontOU =@"
<FONT size="1" face="verdana, hevetica, arial">
"@
$strFontTH =@"
<FONT size="2" face="verdana, hevetica, arial">
"@
If ($OUHeader -eq $true)
{
if ($boolReplMetaDate -eq $true)
{
$strHTMLText =@"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $strReplMetaDate</b><TD><b>$strFontOU $ou</b></TR>
"@
}
else
{
$strHTMLText =@"
<TR bgcolor="$strTHOUColor"><TD><b>$strFontOU $ou</b></TR>
"@
}
} #End If
switch ($strColorTemp) 
{

"1"
	{
	$strColor = "DDDDDD"
	$strColorTemp = "2"
	}
	"2"
	{
	$strColor = "AAAAAA"
	$strColorTemp = "1"
	}		
"3"
	{
	$strColor = "FF1111"
}
"4"
	{
	$strColor = "00FFAA"
}     
"5"
	{
	$strColor = "FFFF00"
}          
	}# End Switch
if ($bolOwner -eq $true)
{

if ($boolReplMetaDate -eq $true)
{
$strOwnerText=@"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont $strOwner</TD><TD>
$strFont Owner </TD><TD>
$strFont False</TD><TD>
$strFont This Object Only</TD><TD>
$strFont Full Control</TD>
</TR>
"@

}
else
{
$strOwnerText=@"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $ou</TD><TD>
$strFont $strOwner</TD><TD>
$strFont Owner </TD><TD>
$strFont False</TD><TD>
$strFont This Object Only</TD><TD>
$strFont Full Control</TD>
</TR>
"@
}
$strHTMLText = $strHTMLText + $strOwnerText
}
if ($bolACLExist)
{
	$sd  | foreach{
	$objFlags = $($_.ObjectFlags.toString())
	$objType = $($_.ObjectType.toString())
	$objInheritedType = $($_.InheritedObjectType.toString())
	$objRights = $($_.ActiveDirectoryRights.toString())
	Switch ($objRights)
	{
		"DeleteChild, DeleteTree, Delete"
		{
			$objRights = "DeleteChild, DeleteTree, Delete"
		}
		"GenericRead"
		{
			$objRights = "Read Permissions,List Contents,Read All Properties,List"
		}
		"CreateChild"
		{
			$objRights = "Create"	
		}
		"DeleteChild"
		{
			$objRights = "Delete"		
		}
		"GenericAll"
		{
			$objRights = "Full Control"		
		}
		"CreateChild, DeleteChild"
		{
			$objRights = "Create/Delete"		
		}
		"ReadProperty"
		{
			$objRights = "Read"		
		}
		"ReadProperty, WriteProperty" 
		{
			$objRights = "Read All Properties;Write All Properties"			
		}
		"WriteProperty" 
		{
			$objRights = "Write"				
		}
	}# End Switch
	$strNTAccount = $($_.IdentityReference.toString())
  
	If ($strNTAccount.contains("S-1-5"))
	{
	 $strNTAccount = ConvertSidTo-Name -server $global:strDomainLongName -Sid $strNTAccount

	}
   
    switch ($strColorTemp) 
    {

    "1"
	{
	$strColor = "DDDDDD"
	$strColorTemp = "2"
	}
	"2"
	{
	$strColor = "AAAAAA"
	$strColorTemp = "1"
	}		
    "3"
	{
	$strColor = "FF1111"
    }
    "4"
	{
	$strColor = "00FFAA"
    }     
    "5"
	{
	$strColor = "FFFF00"
    }          
	}# End Switch
	 switch ($($_.InheritanceType.toString())) 
	 {
	 	"All"
	 	{
	 		switch ($objFlags) 
	    	{ 
		      	"InheritedObjectAceTypePresent"
		      	{
		      		$strPerm =  "$strFont This object and all child objects</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainFqdnName)</TD>"
		      	}    	
		      	"ObjectAceTypePresent"
		      	{
		      		$strPerm =  "$strFont This object and all child objects</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainFqdnName)</TD>"
		      	} 
		      	"ObjectAceTypePresent, InheritedObjectAceTypePresent"
		      	{
		      		$strPerm =  "$strFont $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainFqdnName)</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainFqdnName)</TD>"
		      	} 	      	
		      	"None"
		      	{
		      		$strPerm ="$strFont This object and all child objects</TD><TD>$strFont $objRights</TD>"
		      	} 
		      		default
	 		    {
		      		$strPerm = "Error: Failed to display permissions 1K"
		      	} 	 
	
		    }# End Switch
	 		
	 	}
	 	"Descendents"
	 	{
	
	 		switch ($objFlags)
	    	{ 
		      	"InheritedObjectAceTypePresent"
		      	{
		      	$strPerm = "$strFont $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainFqdnName)</TD><TD>$strFont $objRights</TD>"
		      	}
		      	"None"
		      	{
		      		$strPerm ="$strFont Child Objects Only</TD><TD>$strFont $objRights</TD>"
		      	} 	      	
		      	"ObjectAceTypePresent"
		      	{
		      		$strPerm = "$strFont Child Objects Only</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainFqdnName)</TD>"
		      	} 
		      	"ObjectAceTypePresent, InheritedObjectAceTypePresent"
		      	{
		      		$strPerm =	"$strFont $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainFqdnName)</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainFqdnName)</TD>"
		      	}
		      	default
	 			{
		      		$strPerm = "Error: Failed to display permissions 2K"
		      	} 	 
	
		    } 		
	 	}
	 	"None"
	 	{
	 		switch ($objFlags)
	    	{ 
		      	"ObjectAceTypePresent"
		      	{
		      		$strPerm = "$strFont This Object Only</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainFqdnName)</TD>"
		      	} 
		      	"None"
		      	{
		      		$strPerm ="$strFont This Object Only</TD><TD>$strFont $objRights</TD>"
		      	} 
		      		default
	 		{
		      		$strPerm = "Error: Failed to display permissions 4K"
		      	} 	 
	
			}
	 	}
	 	"SelfAndChildren"
	 	{
	 	 		switch ($objFlags)
	    	{ 
		      	"ObjectAceTypePresent"
	      		{
		      		$strPerm = "$strFont This object and all child objects within this conatainer only</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainFqdnName)</TD>"
		      	}
		      	"InheritedObjectAceTypePresent"
		      	{
		      		$strPerm = "$strFont Children within this conatainer only</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainFqdnName)</TD>"
		      	} 

		      	"ObjectAceTypePresent, InheritedObjectAceTypePresent"
		      	{
		      		$strPerm =  "$strFont $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainFqdnName)</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainFqdnName)</TD>"
		      	} 	      	
		      	"None"
		      	{
		      		$strPerm ="$strFont This object and all child objects</TD><TD>$strFont $objRights</TD>"
		      	}                                  	   
		      	default
	 		    {
		      		$strPerm = "Error: Failed to display permissions 5K"
		      	} 	 
	
			}   	
	 	} 	
	 	"Children"
	 	{
	 	 		switch ($objFlags)
	    	{ 
		      	"InheritedObjectAceTypePresent"
		      	{
		      		$strPerm = "$strFont Children within this conatainer only</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainFqdnName)</TD>"
		      	} 
		      	"None"
		      	{
		      		$strPerm = "$strFont Children  within this conatainer only</TD><TD>$strFont $objRights</TD>"
		      	} 	      	
		      	"ObjectAceTypePresent, InheritedObjectAceTypePresent"
	      		{
		      		$strPerm = "$strFont $(MapGUIDToMatchingName -strGUIDAsString $objInheritedType -Domain $global:strDomainFqdnName)</TD><TD>$strFont $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainFqdnName) $objRights</TD>"
		      	} 	
		      	"ObjectAceTypePresent"
	      		{
		      		$strPerm = "$strFont Children within this conatainer only</TD><TD>$strFont $objRights $(MapGUIDToMatchingName -strGUIDAsString $objType -Domain $global:strDomainFqdnName)</TD>"
		      	} 		      	
		      	default
	 			{
		      		$strPerm = "Error: Failed to display permissions 6K"
		      	} 	 
	
	 		}
	 	}
	 	default
	 		{
		      		$strPerm = "Error: Failed to display permissions 7K"
		    } 	 
	}# End Switch
if($CompareMode)
{
if ($boolReplMetaDate -eq $true)
{
$objColor = $($_.Color.toString())
$strStatus = "<TD>$strFont $objColor</TD>"
$strACLHTMLText =@"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
$strStatus
</TR>
"@
}
else
{
$objColor = $($_.Color.toString())
$strStatus = "<TD>$strFont $objColor</TD>"
$strACLHTMLText =@"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm
$strStatus
</TR>
"@
} #End If ReplMeta Data

}
else
{
if ($boolReplMetaDate -eq $true)
{
$strACLHTMLText =@"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm

</TR>
"@
}
else
{
$strACLHTMLText =@"
$strACLHTMLText
<TR bgcolor="$strColor"><TD>
$strFont $ou</TD><TD>
$strFont $strNTAccount</TD><TD>
$strFont $($_.AccessControlType.toString()) </TD><TD>
$strFont $($_.IsInherited.toString())</TD><TD>
$strPerm

</TR>
"@
} #End If ReplMeta Data
}# End if CompareMode
	
	}# End foreach
}
else
{
if (!$CompareMode)
{
if ($FilterMode)
{
if ($boolReplMetaDate -eq $true)
{
$strACLHTMLText=@"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Matching Permissions Set</TD>
</TR>
"@
}
else
{
$strACLHTMLText=@"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Matching Permissions Set</TD>
</TR>
"@
}#End If ReplMeta Data
}
else
{
if ($boolReplMetaDate -eq $true)
{
$strACLHTMLText=@"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $strReplMetaDate</TD><TD>
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD>
</TR>
"@
}
else
{
$strACLHTMLText=@"
<TR bgcolor="$strColor"><TD>$strFont
$strFont $ou</TD><TD>
$strFont N/A</TD><TD>
$strFont N/A </TD><TD>
$strFont N/A</TD><TD>
$strFont N/A</TD><TD>
$strFont No Permissions Set</TD>
</TR>
"@
}#End If ReplMeta Data
}
}# End if
}# End If

$strHTMLText = $strHTMLText + $strACLHTMLText

Out-File -InputObject $strHTMLText -Append -FilePath $htmfileout 
Out-File -InputObject $strHTMLText -Append -FilePath $strFileHTM

$strHTMLText = ""

}

#==========================================================================
# Function		: InitiateHTM
# Arguments     : Output htm file
# Returns   	: n/a
# Description   : Wites base HTM table syntax, it appends info if the file exist
#==========================================================================
Function InitiateHTM([string] $htmfileout,[bool]$RepMetaDate)
{
$strHTMLText ="<TABLE BORDER=1>" 
$strTHOUColor = "E5CF00"
$strTHColor = "EFAC00"
$strFont =@"
<FONT size="1" face="verdana, hevetica, arial">
"@
$strFontOU =@"
<FONT size="1" face="verdana, hevetica, arial">
"@
$strFontTH =@"
<FONT size="2" face="verdana, hevetica, arial">
"@
if ($RepMetaDate -eq $true)
{
$strHTMLText =@"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH ACL Modified</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th>
"@
}
else
{
$strHTMLText =@"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th>
"@
}
Out-File -InputObject $strHTMLText -Append -FilePath $htmfileout 
}
#==========================================================================
# Function		: InitiateCompareHTM
# Arguments     : Output htm file
# Returns   	: n/a
# Description   : Wites base HTM table syntax, it appends info if the file exist
#==========================================================================
Function InitiateCompareHTM([string] $htmfileout,[boolean]$RepMetaDate)
{
$strHTMLText ="<TABLE BORDER=1>" 
$strTHOUColor = "E5CF00"
$strTHColor = "EFAC00"
$strFont =@"
<FONT size="1" face="verdana, hevetica, arial">
"@
$strFontOU =@"
<FONT size="1" face="verdana, hevetica, arial">
"@
$strFontTH =@"
<FONT size="2" face="verdana, hevetica, arial">
"@
if ($RepMetaDate -eq $true)
{
$strHTMLText =@"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH ACL Modified</font><th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH State</font></th>
"@
}
else
{
$strHTMLText =@"
$strHTMLText
<th bgcolor="$strTHColor">$strFontTH OU</font></th><th bgcolor="$strTHColor">$strFontTH Trustee</font></th><th bgcolor="$strTHColor">$strFontTH Right</font></th><th bgcolor="$strTHColor">$strFontTH Inherited</font></th><th bgcolor="$strTHColor">$strFontTH Apply To</font></th><th bgcolor="$strTHColor">$strFontTH Permission</font></th><th bgcolor="$strTHColor">$strFontTH State</font></th>
"@
}
Out-File -InputObject $strHTMLText -Append -FilePath $htmfileout 
}
#==========================================================================
# Function		: CreateHTA
# Arguments     : OU Name, Ou put HTA file
# Returns   	: n/a
# Description   : Initiates a base HTA file with Export(Save As),Print and Exit buttons.
#==========================================================================
function CreateHTA([string]$NodeName,[string]$htafileout,[string]$htmfileout,[string] $folder)
{
$strHTAText =@"
<html>
<head>
<hta:Application ID="hta"
ApplicationName="Report">
<title>Report on $NodeName</title>
<script type="text/vbscript">
Sub ExportToCSV()
Dim objFSO,objFile,objNewFile,oShell,oEnv
Set oShell=CreateObject("wscript.shell")
Set oEnv=oShell.Environment("System")
strTemp=oShell.ExpandEnvironmentStrings("%USERPROFILE%")
strTempFile="$htmfileout"
strOutputFolder="$folder"
strFile=SaveAs("$NodeName.htm",strOutputFolder)
If strFile="" Then Exit Sub
Set objFSO=CreateObject("Scripting.FileSystemObject")
objFSO.CopyFile strTempFile,strFile, true
MsgBox "Finished exporting to " & strFile,vbOKOnly+vbInformation,"Export"
End Sub
Function SaveAs(strFile,strOutFolder)
Dim objDialog
SaveAs=InputBox("Enter the filename and path."&vbCrlf&vbCrlf&"Example: "&strOutFolder&"\CONTOSO-contoso.htm","Export",strOutFolder&"\"&strFile)
End Function
</script>
</head>
<body>
<input type="button" value="Export" onclick="ExportToCSV" tabindex="9">
<input id="print_button" type="button" value="Print" name="Print_button" class="Hide" onClick="Window.print()">
<input type="button" value="Exit" onclick=self.close name="B3" tabindex="1" class="btn">
"@
Out-File -InputObject $strHTAText -Force -FilePath $htafileout 
}
#==========================================================================
# Function		: CreateHTM
# Arguments     : OU Name, Ou put HTM file
# Returns   	: n/a
# Description   : Initiates a base HTM file with Export(Save As),Print and Exit buttons.
#==========================================================================
function CreateHTM([string]$NodeName,[string]$htmfileout)
{
$strHTAText =@"
<html>
<head>
<title>Report on $NodeName</title>
"@
Out-File -InputObject $strHTAText -Force -FilePath $htmfileout 
}
#==========================================================================
# Function		: BuildTree
# Arguments     : TreeView Node
# Returns   	: TreeView Node
# Description   : Build the Tree with AD objects
#==========================================================================
Function BuildTree($treeNode)
{
		$de = New-Object system.directoryservices.directoryEntry("LDAP://$($treeNode.Name)") 
      # Add all Children found as Sub Nodes to the selected TreeNode 

		$strFilterOUCont = "(&(|(objectClass=organizationalUnit)(objectClass=container)))"
		$strFilterAll = "(&(name=*))"
		$srch = New-Object System.DirectoryServices.DirectorySearcher
		$srch.SizeLimit = 100
		$srch.SearchRoot = "LDAP://"+$treeNode.name
		If ($rdbBrowseAll.checked -eq $true)
		{
		$srch.Filter = $strFilterAll
		
		}
		else
		{
 		$srch.Filter = $strFilterOUCont
		}
		$srch.SearchScope = "OneLevel"
		foreach ($res in $srch.FindAll())
		{
			$oOU = $res.GetDirectoryEntry()
			If ($oOU.name -ne $null)
			{
				$TN = New-Object System.Windows.Forms.TreeNode 
				$TN.Name = $oOU.distinguishedName 
				$TN.Text = $oOU.name 
				$TN.tag = "NotEnumerated" 
				$treeNode.Nodes.Add($TN) 
			}
		}
		$treeNode.tag = "Enumerated" 

}
#==========================================================================
# Function		: GetADPartitions
# Arguments     : domain name 
# Returns   	: N/A
# Description   : Returns AD Partitions
#==========================================================================
function GetADPartitions { 
Param($strDomain)
	$ADPartlist= @{"domain" = $strDomain}
	$objDomain = [ADSI]"LDAP://$strDomain"
	[string]$strDomainObjectCateory = $objDomain.objectCategory
	[array] $dnSplit = $strDomainObjectCateory.split(",")
	$intSplit = ($dnSplit).count -1
	$strConfig = ""
	for ($i=$intSplit;$i -ge 0; $i-- )
	{
	 If($dnSplit[$i] -match "CN=Configuration")
	 {
	  	$intConfig = $i
	 	$strDomainConfig = $dnSplit[$i]
	 }
	 If($i -gt $intConfig)
	 {
	 	If ($strConfig.Length -eq 0)
	 	{
	 	$strConfig = $dnSplit[$i]
	 	}
	 	else
	 	{
	 	$strConfig = $dnSplit[$i] + "," + $strConfig
	 	}
	 }
	}
	$strDomainConfig = $strDomainConfig + "," + $strConfig
	$strDNSchema = "LDAP://CN=Enterprise Schema,CN=Partitions," + $strDomainConfig
	$ojbSchema = [ADSI]$strDNSchema
	
	$ADPartlist.Add("config",$strDomainConfig)
	$ADPartlist.Add("schema",$ojbSchema.nCName)
	
return $ADPartlist
}
#==========================================================================
# Function		: Select-File
# Arguments     : n/a
# Returns   	: folder path
# Description   : Dialogbox for selecting a file
#==========================================================================
function Select-File
{
    param (
        [System.String]$Title = "Select Template File", 
        [System.String]$InitialDirectory = $CurrentFSPath, 
        [System.String]$Filter = "All Files(*.csv)|*.csv"
    )
    
    $dialog = New-Object System.Windows.Forms.OpenFileDialog
    $dialog.Filter = $filter
    $dialog.InitialDirectory = $initialDirectory
    $dialog.ShowHelp = $true
    $dialog.Title = $title
    $result = $dialog.ShowDialog($owner)

    if ($result -eq "OK")
    {
        return $dialog.FileName
    }
    else
    {
        return ""

    }
}
#==========================================================================
# Function		: Select-Folder
# Arguments     : n/a
# Returns   	: folder path
# Description   : Dialogbox for selecting a folder
#==========================================================================
function Select-Folder($message='Select a folder', $path = 0) {  
    $object = New-Object -comObject Shell.Application   
      
    $folder = $object.BrowseForFolder(0, $message, 0, $path)  
    if ($folder -ne $null) {  
        $folder.self.Path  
    }  
} 
#==========================================================================
# Function		: Get-Perm
# Arguments     : List of OU Path
# Returns   	: All Permissions on a speficied object
# Description   : Enumerates all access control entries on a speficied object
#==========================================================================
Function Get-Perm{
Param([System.Collections.ArrayList]$ALOUdn,[string]$DomainNetbiosName,[boolean]$SkipDefaultPerm,[boolean]$FilterEna,[boolean]$GetOwnerEna,[boolean]$bolCSVOnly,[boolean]$bolRepMeta)
$SDResult = $false
$strOwner = ""
$aclcount = 0
If ($bolCSV)
{
	If ((Test-Path $strFileCSV) -eq $true)
	{
	Remove-Item $strFileCSV
	}
}
$count = 0
while($count -le $ALOUdn.count -1)
{

	$DSobject = [adsi]("LDAP://$($ALOUdn[$count])")
 	If ($SkipDefaultPerm)
	{
        $strNodeObjectClass = $DSobject.objectClass.tostring()
	    [array] $arrObjClassSplit = $strNodeObjectClass.split(" ")
	    foreach($strObjClass in $arrObjClassSplit)
        {
        }    
        $objNodeDefSD = Get-ADSchemaClass $strObjClass
    }
    if ($bolRepMeta -eq $true)
    {
    
        $AclChange = $(GetACLMeta  $global:strDomainController $($ALOUdn[$count]))
        $objLastChange = $AclChange.split(";")[0]
        $strOrigInvocationID = $AclChange.split(";")[1]
        $strOrigUSN = $AclChange.split(";")[2]
    }
    If ($GetOwnerEna -eq $true)
    {
        $strOwner = $DSobject.psbase.get_objectSecurity().getOwner([System.Security.Principal.NTAccount])
    }      
    $sd = $DSobject.psbase.get_objectSecurity().getAccessRules($true, $chkInheritedPerm.checked, [System.Security.Principal.NTAccount])
    
    If ($FilterEna -eq $true)    
    {
        If ($chkBoxType.Checked)
        {
            if ($combAccessCtrl.SelectedIndex -gt -1)
            {
            $sd = $sd | ?{$_.AccessControlType -eq $combAccessCtrl.SelectedItem}
            }
        }    
        If ($chkBoxObject.Checked)
        {
            if ($combObjectFilter.SelectedIndex -gt -1)
            {

                $sd = $sd | ?{($_.ObjectType -eq $global:dicNameToSchemaIDGUIDs.Item($combObjectFilter.SelectedItem)) -or ($_.InheritedObjectType -eq $global:dicNameToSchemaIDGUIDs.Item($combObjectFilter.SelectedItem))}
            }
        }
        If ($chkBoxTrustee.Checked)
        {
            if ($txtFilterTrustee.Text.Length -gt 0)
            {
            $sd = $sd | ?{$_.IdentityReference -eq $txtFilterTrustee.Text}
            }
        }
    }
    $intSDCount =  $sd.count
    
    if (!($sd -eq $null))
    {

        If ($GetOwnerEna -eq $true)
        {

            $strOwner = $DSobject.psbase.get_objectSecurity().getOwner([System.Security.Principal.NTAccount])
            $newSdOwnerObject = New-Object Object | `
            Add-Member NoteProperty IdentityReference $strOwner -PassThru |`
            Add-Member NoteProperty ActiveDirectoryRights "Full Control" -PassThru |`
            Add-Member NoteProperty InheritanceType "None" -PassThru |`
            Add-Member NoteProperty ObjectType  "None" -PassThru |`
            Add-Member NoteProperty ObjectFlags "None" -PassThru |`
            Add-Member NoteProperty AccessControlType "Owner" -PassThru |`
            Add-Member NoteProperty IsInherited "False" -PassThru |`
            Add-Member NoteProperty InheritanceFlags "None" -PassThru |`
            Add-Member NoteProperty InheritedObjectType "None" -PassThru |`
            Add-Member NoteProperty PropagationFlags "None"  -PassThru

         If($bolCSV -or $bolCSVOnly)
         {
          WritePermCSV $newSdOwnerObject $DSobject.distinguishedName.toString() $strFileCSV $bolRepMeta $objLastChange $strOrigInvocationID $strOrigUSN
          $aclcount++
         }
         if(!($bolCSVOnly))
         {
         #WriteHTM $true $newSdOwnerObject $DSobject.distinguishedName.toString() $true $strColorTemp $strFileHTA $false $FilterEna $GetOwnerEna $strOwner $bolRepMeta $objLastChange 
         $aclcount++
         }
        }

		$index=0
		$permcount = 0

    if ($intSDCount -gt 0)
    {        
    
		while($index -le $sd.count -1) 
		{

				if(($SkipDefaultPerm) -and (Check-PermDef $objNodeDefSD $sd[$index].IdentityReference $sd[$index].ActiveDirectoryRights $sd[$index].InheritanceType $sd[$index].ObjectType $sd[$index].InheritedObjectType $sd[$index].ObjectFlags $sd[$index].AccessControlType $sd[$index].IsInherited $sd[$index].InheritanceFlags $sd[$index].PropagationFlags))
				{
				}
				else
				{
					If ($bolCSV -or $bolCSVOnly)
					{

				 		WritePermCSV $sd[$index] $DSobject.distinguishedName.toString() $strFileCSV $bolRepMeta $objLastChange $strOrigInvocationID $strOrigUSN

				 	}# End If
                    If (!($bolCSVOnly))
                    {
					    If ($strColorTemp -eq "1")
					    {
						    $strColorTemp = "2"
					    }# End If
					    else
					    {
						    $strColorTemp = "1"
					    }# End If				 	
				 	    if ($permcount -eq 0)
				 	    {
             
				 		    WriteHTM $true $sd[$index] $DSobject.distinguishedName.toString() $true $strColorTemp $strFileHTA $false $FilterEna $GetOwnerEna $strOwner $bolRepMeta $objLastChange

				 	    }
				 	    else
				 	    {
          
				 		    WriteHTM $true $sd[$index] $DSobject.distinguishedName.toString() $false $strColorTemp $strFileHTA $false $FilterEna $false $strOwner $bolRepMeta $objLastChange

				 	    }# End If
                    }
                    $aclcount++
					$permcount++
				}# End If
				$index++
		}# End while

    }
    else
    {
        if(($SkipDefaultPerm) -and (Check-PermDef $objNodeDefSD $sd.IdentityReference $sd.ActiveDirectoryRights $sd.InheritanceType $sd.ObjectType $sd.InheritedObjectType $sd.ObjectFlags $sd.AccessControlType $sd.IsInherited $sd.InheritanceFlags $sd.PropagationFlags))
		{

		}
		else
		{

            If (!($bolCSVOnly))
            {            
			    If ($strColorTemp -eq "1")
			    {
			    $strColorTemp = "2"
			    }
			    else
			    {
			    $strColorTemp = "1"
			    }		
		 	    if ($permcount -eq 0)
		 	    {
		 		    WriteHTM $true $sd $DSobject.distinguishedName.toString() $true $strColorTemp $strFileHTA $false $FilterEna $GetOwnerEna $strOwner $bolRepMeta $objLastChange

                   
		 	    }
		 	    else
		 	    {
                    $GetOwnerEna = $false
                    WriteHTM $true $sd $DSobject.distinguishedName.toString() $false $strColorTemp $strFileHTA $false $FilterEna $GetOwnerEna $strOwner $bolRepMeta $objLastChange
                                        $aclcount++
		 	    }
            }

            $permcount++
        }#End if Check-PermDef
 
    }#End if array        
    
    If (!($bolCSVOnly))
    {
        if (($permcount -eq 0) -and ($index -gt 0))
        {
	    WriteHTM $false $sd $DSobject.distinguishedName.toString() $true "1" $strFileHTA $false $FilterEna $GetOwnerEna $strOwner $bolRepMeta $objLastChange
        $aclcount++
        }# End If
        }
        else #if isNull
        {
            WriteHTM $false $sd $DSobject.distinguishedName.toString() $true "1" $strFileHTA $false $FilterEna $GetOwnerEna $strOwner $bolRepMeta $objLastChange

        }# End if isNull
    }
	$count++
}# End while
    

    if (($count -gt 0))
    {
if ($aclcount -eq 0)
{
[System.Windows.Forms.MessageBox]::Show("No Permissions found!" , "Status") 
}  
else
{
        if ($bolCSVOnly)
        {

           [System.Windows.Forms.MessageBox]::Show("Done!" , "Status") 
        }
        else
        {
	        Invoke-Item $strFileHTA
        }

    }# End If
}
else
{
[System.Windows.Forms.MessageBox]::Show("No objects found!" , "Status") 
}

return $SDResult

}
#==========================================================================
# Function		: Get-PermCompare
# Arguments     : OU Path 
# Returns   	: N/A
# Description   : Compare Permissions on node with permissions in CSV file
#==========================================================================
Function Get-PermCompare{
Param([System.Collections.ArrayList]$ALOUdn,[boolean]$SkipDefaultPerm,[boolean]$bolReplMeta,[boolean]$GetOwnerEna)
&{#Try
$arrFilecheck = New-Object System.Collections.ArrayList

$bolAClMeta = $false
$strOwner = ""
$count = 0
$aclcount = 0
If ($bolReplMeta -eq $true)
{
    If ($HistACLs[0].split(";")[13].length -gt 1)
    {
    $bolAClMeta = $true
    }
    else
    {
    $bolReplMeta = $false
    }
}

while($count -le $ALOUdn.count -1)
{
$SDUsnCheck = $false
$OUMatchResultOverall = $false
$OUdn = $($ALOUdn[$count])
If ($bolAClMeta -eq $true)
{
  
    $AclChange = $(GetACLMeta  $global:strDomainController $OUdn)
    $objLastChange = $AclChange.split(";")[0]
    $strOrigInvocationID = $AclChange.split(";")[1]
    $strOrigUSN = $AclChange.split(";")[2]
}
$DSobject = [adsi]("LDAP://$OUdn")

WriteHTM $false $sd $DSobject.distinguishedName.toString() $true $strColorTemp $strFileHTA $true $false $false "" $bolAClMeta $objLastChange

$sd = $DSobject.psbase.get_objectSecurity().getAccessRules($true, $chkInheritedPerm.checked, [System.Security.Principal.NTAccount])
$rar = @($($sd | select -p *))


    $index = 0
    $SDResult = $false
    $OUMatchResult = $false
            
    $strOwner = $DSobject.psbase.get_objectSecurity().getOwner([System.Security.Principal.NTAccount])
    $newSdObject = New-Object Object | `
    Add-Member NoteProperty IdentityReference $strOwner -PassThru |`
    Add-Member NoteProperty ActiveDirectoryRights "Full Control" -PassThru |`
    Add-Member NoteProperty InheritanceType "None" -PassThru |`
    Add-Member NoteProperty ObjectType  "None" -PassThru |`
    Add-Member NoteProperty ObjectFlags "None" -PassThru |`
    Add-Member NoteProperty AccessControlType "Owner" -PassThru |`
    Add-Member NoteProperty IsInherited "False" -PassThru |`
    Add-Member NoteProperty InheritanceFlags "None" -PassThru |`
    Add-Member NoteProperty InheritedObjectType "None" -PassThru |`
    Add-Member NoteProperty PropagationFlags "None"  -PassThru |`
    Add-Member NoteProperty Color "Match"  -PassThru

        If ($GetOwnerEna -eq $true)
        {

            $strOwner = $DSobject.psbase.get_objectSecurity().getOwner([System.Security.Principal.NTAccount])
            $newSdOwnerObject = New-Object Object | `
            Add-Member NoteProperty IdentityReference $strOwner -PassThru |`
            Add-Member NoteProperty ActiveDirectoryRights "Full Control" -PassThru |`
            Add-Member NoteProperty InheritanceType "None" -PassThru |`
            Add-Member NoteProperty ObjectType  "None" -PassThru |`
            Add-Member NoteProperty ObjectFlags "None" -PassThru |`
            Add-Member NoteProperty AccessControlType "Owner" -PassThru |`
            Add-Member NoteProperty IsInherited "False" -PassThru |`
            Add-Member NoteProperty InheritanceFlags "None" -PassThru |`
            Add-Member NoteProperty InheritedObjectType "None" -PassThru |`
            Add-Member NoteProperty PropagationFlags "None"  -PassThru |`
            Add-Member NoteProperty Color "Match"  -PassThru

            $aclcount++


	while($index -le $HistACLs.count -1) 
	{
		$txtPerm = $HistACLs[$index].split(";")
		if (($OUdn -eq $txtPerm[0] ) -and ($txtPerm[7] -eq "Owner")) 
		{
            $OUMatchResult = $true
            $OUMatchResultOverall = $true
			$strIdentityReference = $txtPerm[1]
			$strTmpActiveDirectoryRights = $txtPerm[2]				
			$strTmpInheritanceType = $txtPerm[3]				
			$strTmpObjectTypeGUID = $txtPerm[4]
			$strTmpInheritedObjectTypeGUID = $txtPerm[5]
			$strTmpObjectFlags = $txtPerm[6]
			$strTmpAccessControlType = $txtPerm[7]
			$strTmpIsInherited = $txtPerm[8]
			$strTmpInheritedFlags = $txtPerm[9]
			$strTmpPropFlags = $txtPerm[10]
            $strTmpACLDate = $txtPerm[11]
            $strTmpOrigInvocationID = $txtPerm[12]
            $strTmpOrigUSN = $txtPerm[13]

            if ($bolAClMeta -eq $true)
            {
                If (($strOrigInvocationID -eq $strTmpOrigInvocationID) -and ($strOrigUSN -eq $strTmpOrigUSN))
                {
                    $SDResult = $true
                    $SDUsnCheck = $true
                    break 
                }
            }

            If (($newSdObject.IdentityReference -eq $strIdentityReference) -and ($newSdObject.ActiveDirectoryRights -eq $strTmpActiveDirectoryRights) -and ($newSdObject.AccessControlType -eq $strTmpAccessControlType) -and ($newSdObject.ObjectType -eq $strTmpObjectTypeGUID) -and ($newSdObject.InheritanceType -eq $strTmpInheritanceType) -and ($newSdObject.InheritedObjectType -eq $strTmpInheritedObjectTypeGUID))
		 	{
				$SDResult = $true
		 	}
 
		}
		$index++
	}# End While


    if ($SDResult)
    {

                WriteHTM $true $newSdObject $OUdn $false "4" $strFileHTA $true $false $false $strOwner $bolAClMeta $objLastChange

       
    }
	If ($OUMatchResult -And !($SDResult))
	{

        $newSdObject.Color = "New"
        WriteHTM $true $newSdObject $OUdn $false "5" $strFileHTA $true $false $false $strOwner $bolAClMeta $objLastChange
            
    }

                }        


If ($SkipDefaultPerm)
    {


        $strNodeObjectClass = $DSobject.objectClass.tostring()
	    [array] $arrObjClassSplit = $strNodeObjectClass.split(" ")
	    foreach($strObjClass in $arrObjClassSplit)
        {
        }
    	$objNodeDefSD = Get-ADSchemaClass $strObjClass    
    }

	foreach($sdObject in $rar)
	{

           if(($SkipDefaultPerm) -and (Check-PermDef $objNodeDefSD $sdObject.IdentityReference $sdObject.ActiveDirectoryRights $sdObject.InheritanceType $sdObject.ObjectType $sdObject.InheritedObjectType $sdObject.ObjectFlags $sdObject.AccessControlType $sdObject.IsInherited $sdObject.InheritanceFlags $sdObject.PropagationFlags))
   			{
        }
        else
        {


		$index = 0
		$SDResult = $false
        $OUMatchResult = $false
            $aclcount++
            $newSdObject = New-Object Object | `
            Add-Member NoteProperty IdentityReference $sdObject.IdentityReference.value -PassThru |`
            Add-Member NoteProperty ActiveDirectoryRights $sdObject.ActiveDirectoryRights -PassThru |`
            Add-Member NoteProperty InheritanceType $sdObject.InheritanceType -PassThru |`
            Add-Member NoteProperty ObjectType  $sdObject.ObjectType -PassThru |`
            Add-Member NoteProperty ObjectFlags $sdObject.ObjectFlags -PassThru |`
            Add-Member NoteProperty AccessControlType $sdObject.AccessControlType -PassThru |`
            Add-Member NoteProperty IsInherited $sdObject.IsInherited -PassThru |`
            Add-Member NoteProperty InheritanceFlags $sdObject.InheritanceFlags -PassThru |`
            Add-Member NoteProperty InheritedObjectType $sdObject.InheritedObjectType -PassThru |`
            Add-Member NoteProperty PropagationFlags $sdObject.PropagationFlags  -PassThru|`
            Add-Member NoteProperty Color "Match"  -PassThru
                
            if ($SDUsnCheck -eq $true)
            {
            $SDResult = $true
            }
            else
            {
		    while($index -le $HistACLs.count -1) 
		    {
			    $txtPerm = $HistACLs[$index].split(";")
			    if ($OUdn -eq $txtPerm[0] )
			    {
                    $OUMatchResult = $true
                    $OUMatchResultOverall = $true
				    $strIdentityReference = $txtPerm[1]
				    $strTmpActiveDirectoryRights = $txtPerm[2]				
				    $strTmpInheritanceType = $txtPerm[3]				
				    $strTmpObjectTypeGUID = $txtPerm[4]
				    $strTmpInheritedObjectTypeGUID = $txtPerm[5]
				    $strTmpObjectFlags = $txtPerm[6]
				    $strTmpAccessControlType = $txtPerm[7]
				    $strTmpIsInherited = $txtPerm[8]
				    $strTmpInheritedFlags = $txtPerm[9]
				    $strTmpPropFlags = $txtPerm[10]

                    If (($newSdObject.IdentityReference -eq $strIdentityReference) -and ($newSdObject.ActiveDirectoryRights -eq $strTmpActiveDirectoryRights) -and ($newSdObject.AccessControlType -eq $strTmpAccessControlType) -and ($newSdObject.ObjectType -eq $strTmpObjectTypeGUID) -and ($newSdObject.InheritanceType -eq $strTmpInheritanceType) -and ($newSdObject.InheritedObjectType -eq $strTmpInheritedObjectTypeGUID))
		 		    {
					    $SDResult = $true
		 		    }
 
		 	    }
			    $index++
		    }# End While
        }

        if ($SDResult)
        {

                    WriteHTM $true $newSdObject $OUdn $false "4" $strFileHTA $true $false $false $strOwner $bolAClMeta $objLastChange
       
        }
		If ($OUMatchResult -And !($SDResult))
		{

            $newSdObject.Color = "New"
            WriteHTM $true $newSdObject $OUdn $false "5" $strFileHTA $true $false $false $strOwner $bolAClMeta $objLastChange
            
         }

}

        
	}

If ($SDUsnCheck -eq $false)
{
$index = 0
while($index -le $HistACLs.count -1) 
{
       $SDHistResult = $false
			$txtPerm = $HistACLs[$index].split(";")
			if ($OUdn -eq $txtPerm[0] )
			{
                $OUMatchResult = $true
				$strIdentityReference = $txtPerm[1]
				$strTmpActiveDirectoryRights = $txtPerm[2]				
				$strTmpInheritanceType = $txtPerm[3]				
				$strTmpObjectTypeGUID = $txtPerm[4]
				$strTmpInheritedObjectTypeGUID = $txtPerm[5]
				$strTmpObjectFlags = $txtPerm[6]
				$strTmpAccessControlType = $txtPerm[7]
				$strTmpIsInherited = $txtPerm[8]
				$strTmpInheritedFlags = $txtPerm[9]
				$strTmpPropFlags = $txtPerm[10]
 If ($GetOwnerEna -eq $true)
        {

                $strOwner = $DSobject.psbase.get_objectSecurity().getOwner([System.Security.Principal.NTAccount])
                $newSdObject = New-Object Object | `
                Add-Member NoteProperty IdentityReference $strOwner -PassThru |`
                Add-Member NoteProperty ActiveDirectoryRights "Full Control" -PassThru |`
                Add-Member NoteProperty InheritanceType "None" -PassThru |`
                Add-Member NoteProperty ObjectType  "None" -PassThru |`
                Add-Member NoteProperty ObjectFlags "None" -PassThru |`
                Add-Member NoteProperty AccessControlType "Owner" -PassThru |`
                Add-Member NoteProperty IsInherited "False" -PassThru |`
                Add-Member NoteProperty InheritanceFlags "None" -PassThru |`
                Add-Member NoteProperty InheritedObjectType "None" -PassThru |`
                Add-Member NoteProperty PropagationFlags "None"  -PassThru 

                If (($newSdObject.IdentityReference -eq $strIdentityReference) -and ($newSdObject.ActiveDirectoryRights -eq $strTmpActiveDirectoryRights) -and ($newSdObject.AccessControlType -eq $strTmpAccessControlType) -and ($newSdObject.ObjectType -eq $strTmpObjectTypeGUID) -and ($newSdObject.InheritanceType -eq $strTmpInheritanceType) -and ($newSdObject.InheritedObjectType -eq $strTmpInheritedObjectTypeGUID))
                {
                    $SDHistResult = $true
                }#End If $newSdObject
            }
                $sdHistCheck = $DSobject.psbase.get_objectSecurity().getAccessRules($true, $chkInheritedPerm.checked, [System.Security.Principal.NTAccount])
                $rarHistCheck = @($($sdHistCheck | select -p *))

	               foreach($sdObject in $rarHistCheck)
	               {
                        if(($SkipDefaultPerm) -and (Check-PermDef $objNodeDefSD $sdObject.IdentityReference $sdObject.ActiveDirectoryRights $sdObject.InheritanceType $sdObject.ObjectType $sdObject.InheritedObjectType $sdObject.ObjectFlags $sdObject.AccessControlType $sdObject.IsInherited $sdObject.InheritanceFlags $sdObject.PropagationFlags))
   		                    {
                        }
                        else
                        {                        
                            $newSdObject = New-Object Object | `
                            Add-Member NoteProperty IdentityReference $sdObject.IdentityReference.value -PassThru |`
                            Add-Member NoteProperty ActiveDirectoryRights $sdObject.ActiveDirectoryRights -PassThru |`
                            Add-Member NoteProperty InheritanceType $sdObject.InheritanceType -PassThru |`
                            Add-Member NoteProperty ObjectType  $sdObject.ObjectType -PassThru |`
                            Add-Member NoteProperty ObjectFlags $sdObject.ObjectFlags -PassThru |`
                            Add-Member NoteProperty AccessControlType $sdObject.AccessControlType -PassThru |`
                            Add-Member NoteProperty IsInherited $sdObject.IsInherited -PassThru |`
                            Add-Member NoteProperty InheritanceFlags $sdObject.InheritanceFlags -PassThru |`
                            Add-Member NoteProperty InheritedObjectType $sdObject.InheritedObjectType -PassThru |`
                            Add-Member NoteProperty PropagationFlags $sdObject.PropagationFlags  -PassThru
           

                            If (($newSdObject.IdentityReference -eq $strIdentityReference) -and ($newSdObject.ActiveDirectoryRights -eq $strTmpActiveDirectoryRights) -and ($newSdObject.AccessControlType -eq $strTmpAccessControlType) -and ($newSdObject.ObjectType -eq $strTmpObjectTypeGUID) -and ($newSdObject.InheritanceType -eq $strTmpInheritanceType) -and ($newSdObject.InheritedObjectType -eq $strTmpInheritedObjectTypeGUID))
                            {
                                $SDHistResult = $true
                            }#End If $newSdObject
                        }
                    }# End foreach 
                    


                If ($OUMatchResult -And !($SDHistResult))
                {
                    $histSDObject = New-Object Object | `
                    Add-Member NoteProperty IdentityReference $txtPerm[1] -PassThru |`
                    Add-Member NoteProperty ActiveDirectoryRights $txtPerm[2] -PassThru |`
                    Add-Member NoteProperty InheritanceType $txtPerm[3] -PassThru |`
                    Add-Member NoteProperty ObjectType  $txtPerm[4] -PassThru |`
                    Add-Member NoteProperty ObjectFlags $txtPerm[6] -PassThru |`
                    Add-Member NoteProperty AccessControlType $txtPerm[7] -PassThru |`
                    Add-Member NoteProperty IsInherited $txtPerm[8] -PassThru |`
                    Add-Member NoteProperty InheritanceFlags $txtPerm[9] -PassThru |`
                    Add-Member NoteProperty InheritedObjectType $txtPerm[5] -PassThru |`
                    Add-Member NoteProperty PropagationFlags $txtPerm[10] -PassThru   |`
                    Add-Member NoteProperty Color "Missing" -PassThru   

                    WriteHTM $true $histSDObject $OUdn $false "3" $strFileHTA $true $false $false "" $bolAClMeta $objLastChange
                    $histSDObject = ""
                }# End If $OUMatchResult
            }# End if $OUdn
			$index++
		}# End While
} #End If If ($SDUsnCheck -eq $false)

If (!$OUMatchResultOverall)        
{
 If ($GetOwnerEna -eq $true)
        {

                $strOwner = $DSobject.psbase.get_objectSecurity().getOwner([System.Security.Principal.NTAccount])
                $MissingOUOwnerObject = New-Object Object | `
                Add-Member NoteProperty IdentityReference $strOwner -PassThru |`
                Add-Member NoteProperty ActiveDirectoryRights "Full Control" -PassThru |`
                Add-Member NoteProperty InheritanceType "None" -PassThru |`
                Add-Member NoteProperty ObjectType  "None" -PassThru |`
                Add-Member NoteProperty ObjectFlags "None" -PassThru |`
                Add-Member NoteProperty AccessControlType "Owner" -PassThru |`
                Add-Member NoteProperty IsInherited "False" -PassThru |`
                Add-Member NoteProperty InheritanceFlags "None" -PassThru |`
                Add-Member NoteProperty InheritedObjectType "None" -PassThru |`
                Add-Member NoteProperty PropagationFlags "None"  -PassThru |`
                Add-Member NoteProperty Color "Node not in file"  -PassThru
                
                WriteHTM $true $MissingOUOwnerObject $OUdn $false "5" $strFileHTA $true $false $false "" $bolAClMeta $objLastChange
}
	foreach($sdObject in $rar)
	{
            
            $MissingOUSdObject = New-Object Object | `
            Add-Member NoteProperty IdentityReference $sdObject.IdentityReference.value -PassThru |`
            Add-Member NoteProperty ActiveDirectoryRights $sdObject.ActiveDirectoryRights -PassThru |`
            Add-Member NoteProperty InheritanceType $sdObject.InheritanceType -PassThru |`
            Add-Member NoteProperty ObjectType  $sdObject.ObjectType -PassThru |`
            Add-Member NoteProperty ObjectFlags $sdObject.ObjectFlags -PassThru |`
            Add-Member NoteProperty AccessControlType $sdObject.AccessControlType -PassThru |`
            Add-Member NoteProperty IsInherited $sdObject.IsInherited -PassThru |`
            Add-Member NoteProperty InheritanceFlags $sdObject.InheritanceFlags -PassThru |`
            Add-Member NoteProperty InheritedObjectType $sdObject.InheritedObjectType -PassThru |`
            Add-Member NoteProperty PropagationFlags $sdObject.PropagationFlags  -PassThru|`
            Add-Member NoteProperty Color "Node not in file"  -PassThru
            
            WriteHTM $true $MissingOUSdObject $OUdn $false "5" $strFileHTA $true $false $false "" $bolAClMeta $objLastChange
      }
  }
  $count++
}# End While

    if (($count -gt 0))
    {
        if ($aclcount -eq 0)
        {
        [System.Windows.Forms.MessageBox]::Show("No Permissions found!" , "Status") 
        }  
        else
        {
                if ($bolCSVOnly)
                {

                   [System.Windows.Forms.MessageBox]::Show("Done!" , "Status") 
                }
                else
                {
	                Invoke-Item $strFileHTA
                }

            }# End If
        }
else
{
[System.Windows.Forms.MessageBox]::Show("No objects found!" , "Status") 
}
}# End Try
 Trap [SystemException]
 {
#
Invoke-Item $strFileHTA
;Continue
 }  

 $histSDObject = ""
 $sdObject = ""   
 $arrObjClassSplit = ""   
 $MissingOUSdObject = ""
 $newSdObject = ""
 $DSobject = ""
 $strOwner = ""
 $HistACLs = ""
 $txtPerm = ""
 $objNodeDefSD = ""
 $MissingOUOwnerObject = ""

}

#==========================================================================
# Function		:  ConvertCSVtoHTM
# Arguments     : Fle Path 
# Returns   	: N/A
# Description   : Convert CSV file to HTM Output
#==========================================================================
Function ConvertCSVtoHTM{
Param($CSVInput)
$bolRepMeta = $false
If(Test-Path $CSVInput)
{

    $fileName = $(Get-ChildItem $CSVInput).BaseName
	$strFileHTA = $env:temp + "\ACLHTML.hta" 
	$strFileHTM = $env:temp + "\"+"$fileName"+".htm" 	

    $fs = [System.IO.File]::OpenText($CSVInput)
    while ($fs.Peek() -ne -1) 
    {
	    $line = $fs.ReadLine();
		$arrline = $line.split(";")
        If ($arrline[13].length -gt 1)
        {		
         $bolRepMeta = $true
         }
     }
    $fs.close()

    CreateHTA $fileName $strFileHTA $strFileHTM $CurrentFSPath
    CreateHTM $fileName $strFileHTM	
    InitiateHTM $strFileHTA $bolRepMeta
	InitiateHTM $strFileHTM $bolRepMeta

    $tmpOU = ""
    $fs = [System.IO.File]::OpenText($CSVInput)
    while ($fs.Peek() -ne -1) 
    {
	    $line = $fs.ReadLine();
		
		    $arrline = $line.split(";")



    If ($bolRepMeta -eq $true)
    {

		    $strOU = $arrline[0] 
		    $strOU = ($strOU.Replace($OldDomDN,$strDomainDN))
		    $strTrustee = $arrline[1]
		    $strRights = $arrline[2]				
		    $strInheritanceType = $arrline[3]				
		    $strObjectTypeGUID = $arrline[4]
		    $strInheritedObjectTypeGUID = $arrline[5]
		    $strObjectFlags = $arrline[6]
		    $strAccessControlType = $arrline[7]
		    $strIsInherited = $arrline[8]
		    $strInheritedFlags = $arrline[9]
		    $strPropFlags = $arrline[10]
            $strTmpACLDate = $arrline[11]

    }
    else
    {

		    $strOU = $arrline[0] 
		    $strOU = ($strOU.Replace($OldDomDN,$strDomainDN))
		    $strTrustee = $arrline[1]
		    $strRights = $arrline[2]				
		    $strInheritanceType = $arrline[3]				
		    $strObjectTypeGUID = $arrline[4]
		    $strInheritedObjectTypeGUID = $arrline[5]
		    $strObjectFlags = $arrline[6]
		    $strAccessControlType = $arrline[7]
		    $strIsInherited = $arrline[8]
		    $strInheritedFlags = $arrline[9]
		    $strPropFlags = $arrline[10]

    }                                
            $txtSdObject = New-Object Object | `
            Add-Member NoteProperty IdentityReference $strTrustee -PassThru |`
            Add-Member NoteProperty ActiveDirectoryRights $strRights -PassThru |`
            Add-Member NoteProperty InheritanceType $strInheritanceType -PassThru |`
            Add-Member NoteProperty ObjectType  $strObjectTypeGUID -PassThru |`
            Add-Member NoteProperty ObjectFlags $strObjectFlags -PassThru |`
            Add-Member NoteProperty AccessControlType $strAccessControlType -PassThru |`
            Add-Member NoteProperty IsInherited $strIsInherited -PassThru |`
            Add-Member NoteProperty InheritanceFlags $strInheritedFlags -PassThru |`
            Add-Member NoteProperty InheritedObjectType $strInheritedObjectTypeGUID -PassThru |`
            Add-Member NoteProperty PropagationFlags $strPropFlags -PassThru
    
                        

	    If ($strColorTemp -eq "1")
	    {
		    $strColorTemp = "2"
	    }# End If
	    else
	    {
		    $strColorTemp = "1"
	    }# End If                  
        if ($tmpOU -ne $strOU)      
        {
    WriteHTM $true $txtSdObject $strOU $true $strColorTemp $strFileHTA $false $false $false $strOwner $bolRepMeta $strTmpACLDate
    
    $tmpOU = $strOU
    }
    else
    {
    WriteHTM $true $txtSdObject $strOU $false $strColorTemp $strFileHTA $false $false $false $strOwner $bolRepMeta $strTmpACLDate

    }
			

				
    }
    #Close the CSV file
    $fs.close()
    Invoke-Item $strFileHTA
}
else
{
    $lblStatusMessage.ForeColor = "red"
    $lblStatusMessage.Text = "Failed! $CSVInput does not exist!"
}

}# End Function


#==========================================================================
# Function		: ImportADSettings
# Arguments     : strDN
# Returns   	: n/a
# Description   : bla bla
#==========================================================================
 function ImportADSettings
 {
Param ([string] $Template )
  
[void] $HistACLs.Clear()
 $fs = [System.IO.File]::OpenText($Template)
while ($fs.Peek() -ne -1) 
{
    $line = $fs.ReadLine();
    [void] $HistACLs.Add($line)
}#End While

#Close the CSV file
$fs.close()
 

}
#==========================================================================
# Function		: New-Type
# Arguments     : C# Code, dll 
# Returns   	: n/a
# Description   : Takes C# source code, and compiles it (in memory) for use in scri ...
#==========================================================================
function New-Type {
   param([string]$TypeDefinition,[string[]]$ReferencedAssemblies)
   
   $provider = New-Object Microsoft.CSharp.CSharpCodeProvider
   $dllName = [PsObject].Assembly.Location
   $compilerParameters = New-Object System.CodeDom.Compiler.CompilerParameters

   $assemblies = @("System.dll", $dllName)
   $compilerParameters.ReferencedAssemblies.AddRange($assemblies)
   if($ReferencedAssemblies) { 
      $compilerParameters.ReferencedAssemblies.AddRange($ReferencedAssemblies) 
   }

   $compilerParameters.IncludeDebugInformation = $true
   $compilerParameters.GenerateInMemory = $true

   $compilerResults = $provider.CompileAssemblyFromSource($compilerParameters, $TypeDefinition)
   if($compilerResults.Errors.Count -gt 0) {
     $compilerResults.Errors | % { Write-Error ("{0}:`t{1}" -f $_.Line,$_.ErrorText) }
   }
}
#==========================================================================
# Function		: GetACLMeta
# Arguments     : Domain Controller, AD Object DN 
# Returns   	: Semi-colon separated string
# Description   : Get AD Replication Meta data LastOriginatingChange, LastOriginatingDsaInvocationID
#                  usnOriginatingChange and returns as string
#==========================================================================
Function GetACLMeta()
{
    Param($DomainController,$objDN)

    $objADObj = [ADSI]"LDAP://$DomainController/$objDN"
    $objADObj.psbase.RefreshCache("msDS-ReplAttributeMetaData")
         foreach($childMember in $objADObj.psbase.Properties.Item("msDS-ReplAttributeMetaData"))

         {
            If ($([xml]$childMember).DS_REPL_ATTR_META_DATA.pszAttributeName -eq "nTSecurityDescriptor")
            {
            $strLastChangeDate = $([xml]$childMember).DS_REPL_ATTR_META_DATA.ftimeLastOriginatingChange
            $strInvocationID = $([xml]$childMember).DS_REPL_ATTR_META_DATA.uuidLastOriginatingDsaInvocationID
            $strOriginatingChange = $([xml]$childMember).DS_REPL_ATTR_META_DATA.usnOriginatingChange
            }
         }

$ACLdate = $(get-date $strLastChangeDate -UFormat "%Y-%m-%d %H:%M:%S")
  return "$ACLdate;$strInvocationID;$strOriginatingChange"
}




$HistACLs = New-Object System.Collections.ArrayList
$CurrentFSPath = split-path -parent $MyInvocation.MyCommand.Path
$strLastCacheGuidsDom = ""
$TNRoot = ""
$prevNodeText = ""
$sd = ""
##Call the Function
GenerateForm

