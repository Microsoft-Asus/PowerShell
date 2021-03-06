Function Get-Uptime {
#To run against servers in a domain review the below examples
#Get all enabled servers that are in the domain.
#$Servers = Get-ADComputer -Filter {(OperatingSystem -like "*Server*") -and (Enabled -eq $true)} -Properties OperatingSystem | select -ExpandProperty Name | Sort-Object
#Get all reboot times and put them in a variable to reference later.
#$Reboots = Get-Uptime -ComputerName $Servers
 
#Sorting by Lastboot time. 
#$Reboots | Sort-Object LastBoot | Export-CSV -Path c:\uptime.csv -notypeinformation

    [CmdletBinding()]
 
    Param (
        [Parameter(
                ValueFromPipeline=$true,
                ValueFromPipelineByPropertyName=$true,
                Position=0)]
 
        [string[]]
            $ComputerName = $env:COMPUTERNAME,
         
        [Switch]  
            $ShowOfflineComputers
     
        )
 
    BEGIN {
        $ErroredComputers = @()
    }
 
    PROCESS {
        Foreach ($Computer in $ComputerName) {
            Try {
                $OS = Get-WmiObject Win32_OperatingSystem -ComputerName $Computer -ErrorAction Stop
                $Uptime = (Get-Date) - $OS.ConvertToDateTime($OS.LastBootUpTime)
                $Properties = @{ComputerName  = $Computer
                                LastBoot      = $OS.ConvertToDateTime($OS.LastBootUpTime)
                                Uptime        = ([String]$Uptime.Days + " Days " + $Uptime.Hours + " Hours " + $Uptime.Minutes + " Minutes")
                                }
 
                $Object = New-Object -TypeName PSObject -Property $Properties | Select-Object ComputerName, LastBoot, UpTime
 
            } catch {
                if ($ShowOfflineComputers) {
                    $ErrorMessage = $Computer + " Error: " + $_.Exception.Message
                    $ErroredComputers += $ErrorMessage
 
                    $Properties = @{ComputerName  = $Computer
                                    LastBoot      = "Unable to Connect"
                                    Uptime        = "Error Shown Below"
                                    }
 
                    $Object = New-Object -TypeName PSObject -Property $Properties | Select-Object ComputerName, LastBoot, UpTime
                }
                
            } finally {
                Write-Output $Object       
 
                $Object       = $null
                $OS           = $null
                $Uptime       = $null
                $ErrorMessage = $null
                $Properties   = $null
            }
        }
     
        if ($ShowOfflineComputers) {
            Write-Output ""
            Write-Output "Errors for Computers not able to connect."
            Write-Output $ErroredComputers
        }
    }
 
    END {}
 
}