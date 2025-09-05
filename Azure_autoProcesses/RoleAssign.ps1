# Assign the role ro the suscription
# Note: Ensure you have the necessary permissions to assign roles in the specified scope.

# Connect-AzAccount
# Select-AzSubscription -SubscriptionId "your-subscription-id"

param(
    [string]$roleName = "Reader",               # Replace with the desired role name
    [string]$scope = "/subscriptions/your-subscription-id",  # Replace with your subscription ID
    [string]$assignee = "email@example.com",  # Replace with the user or service principal to assign the role to
    [string]$resourceGroupName = "your-resource-group"  # Optional: specify a resource group for more granular scope
)

#############################
# Assign the role to a user #
#############################

Write-Output "Assigning role '$roleName' to '$assignee' at scope '$scope'..."

New-AzRoleAssignment -RoleDefinitionName $roleName 
    -Scope $scope 
    -SignInName $assignee

Write-Output "Role '$roleName' has been assigned to '$assignee' at scope '$scope'."

#######################################
# Assign the role to a resource group #
#######################################

Write-Output "Assigning role '$roleName' to '$assignee' at resource group scope '$resourceGroupName'..."

New-AzRoleAssignment -RoleDefinitionName $roleName 
    -ResourceGroupName $resourceGroupName 
    -SignInName $assignee

Write-Output "Role '$roleName' has been assigned to '$assignee' at resource group scope '$resourceGroupName'."