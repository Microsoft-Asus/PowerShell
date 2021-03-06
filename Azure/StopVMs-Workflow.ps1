Workflow test {

    $vms = Get-AzVM | Where-Object {$_.tags['shutDown'] -eq "19:00"} 
    foreach -parallel ($vm in $vms) {
        #The following commands will be executed in parallel
        Get-AzVM | Where-Object {$_.tags['shutDown'] -eq "19:00"}  | Stop-AZVM  -Force   
    }
}
test