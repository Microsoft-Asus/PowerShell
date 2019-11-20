#Log in to Az account
Connect-AzAccount
#Based on script from Pixel Robot's site
#Get list of Az Subscription ID's
#$Subs = (get-AzSubscription).ID
$sub = "f8bf7adc-eeed-4320-b9e4-b30e582ef115"

#Loop through the subscriptions to find all empty Resource Groups and store them in $EmptyRGs
#ForEach ($sub in $Subs) {
Select-AzSubscription -SubscriptionId $sub
$AllRGs = (Get-AzResourceGroup).ResourceGroupName
$UsedRGs = (Get-AzResource | Group-Object ResourceGroupName).Name
$EmptyRGs = $AllRGs | Where-Object {$_ -notin $UsedRGs}


#Loop through the empty Resorce Groups asking if you would like to delete them. And then deletes them.
foreach ($EmptyRG in $EmptyRGs){
#$Confirmation = Read-Host "Would you like to delete $EmptyRG '(Y)es' or '(N)o'"
#IF ($Confirmation -eq "y" -or $Confirmation -eq "Yes"){
#Write-Host "Deleting" $EmptyRG "Resource Group" 
Remove-AzResourceGroup -Name $EmptyRG -Force -AsJob
} 
#}
