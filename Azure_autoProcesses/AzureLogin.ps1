# Azure CLI login
az login

# Get and Set the subscription context

## Replace with your subscription ID
$subscriptionId = "your-subscription-id" 

## OR use the ID subscription from the az login command
$subscriptionId = (Get-AzContext).Subscription.Id

## Set the subscription context
if (-not $subscriptionId) {
    Write-Error "Subscription ID is not set. Please provide a valid subscription ID."
} 

Write-Output "Setting subscription context to ID: $subscriptionId"
Set-AzContext -SubscriptionId $subscriptionId -ErrorAction Stop