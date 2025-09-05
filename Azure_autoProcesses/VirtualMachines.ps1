# Remember: Log in to Azure and set the subscription context

# Virtual Machine details

param(
    [string]$resourceGroupName = "resource-group-name",  # Replace with your resource group name
    [string]$vmName = "your-vm-name"                     # Replace with your VM name
)

################
# Start the VM #
################

Write-Output "Starting VM: $vmName in Resource Group: $resourceGroupName"

Write-Output "Checking the status of the VM..."
$vmStatus = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Status

if ($vmStatus.Statuses[1].Code -eq "PowerState/running") {
    Write-Output "The VM is already running."
} else {
    Write-Output "The VM is not running. Starting the VM..."
    Start-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
    Write-Output "The VM has been started."
}

# Wait until the VM is running
do {
    Start-Sleep -Seconds 10
    $vmStatus = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Status
    Write-Output "Current VM Status: $($vmStatus.Statuses[1].DisplayStatus)"
} while ($vmStatus.Statuses[1].Code -ne "PowerState/running")

Write-Output "The VM is now running."

###############
# Stop the VM #
###############

Stop-AzVM -ResourceGroupName $resourceGroupName -Name $vmName -Force
Write-Output "The VM has been stopped at $(Get-Date -Format 'yyyy-MM-ddTHH:ssz')."

##################
# Resize the VM  #
##################

$vm = Get-AzVM -ResourceGroupName $resourceGroupName -Name $vmName
Write-Output "Current VM Size: $($vm.HardwareProfile.VmSize)"

Write-Output "Resizing the VM to Standard_DS2_v2..."
$vm.HardwareProfile.VmSize = "Standard_DS2_v2"  # Replace with desired size
Update-AzVM -ResourceGroupName $resourceGroupName -VM $vm