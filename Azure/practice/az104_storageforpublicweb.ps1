# Provide Storage for a Public Website

# This script creates an Azure Storage Account configured to host a public website.

# 1. Create a storage account with high availability

# Access to Azue subscription
Connect-AzAccount

# Create a resource group and storage account ("publiwebsite")
$resourceGroupName = "az104_PublicWebsite_rg"
$location = "westeurope"
$storageaccountName = "publicwebsite1unico"

New-AzResourceGroup -Name $resourceGroupName -Location $location

New-AzStorageAccount -ResourceGroupName $resourceGroupName `
                    -Name $storageaccountName `
                    -Location $location `
                    -SkuName Standard_RAGRS `
                    -Kind StorageV2 `
                    -AllowBlobPublicAccess $true `
                    -MinimumTlsVersion TLS1_2

# Ensure that the option Geographic redundancy storage with read access is selected.

$account = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageaccountName
$account.PrimaryLocation
$account.SecondaryLocation

# Ensure that the option Allow anonymous access to blobs is enabled.
$account.AllowBlobPublicAccess 

# 2. Create a blob storage container with anonymous read access

# Create a blob container in the storage account
$Context = $account.Context
$ContainerName = 'newstartblobs'
New-AzStorageContainer -Name $ContainerName -Context $Context

# Configure anonymous read access for blobs in the public container
# Read the container's anonymous access setting.
Get-AzStorageContainerAcl -Container $ContainerName -Context $Context
# Update the container's anonymous access setting to Blob.
Set-AzStorageContainerAcl -Container $ContainerName -Permission Blob -Context $Context

# 3. Upload website files to the blob container
$Blob1HT = @{
  File             = 'C:\Repos\testblob.docx'
  Container        = $ContainerName
  Blob             = "testblob.docx"
  Context          = $Context
  StandardBlobTier = 'Hot'
}
Set-AzStorageBlobContent @Blob1HT

# Determine the URL of your uploaded file