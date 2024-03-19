function New-VeeamSPCCompany {
    param(
        $Name,
        $ExternalId
    )
    $URI = '/organizations/companies'
    $Body = @{
        organizationInput = @{
            'name'    = $Name
            'country' = 1
            notes     = 'Created by ART'
            companyId = $ExternalId
        }
        companyServices   = @{
            'isBackupAgentManagementEnabled'   = $true
            'isFileLevelRestoreEnabled'        = $false
            'isBackupServerManagementEnabled'  = $true
            'isVBPublicCloudManagementEnabled' = $true
        } 
    } | ConvertTo-Json -Depth 10
    Invoke-VeeamSPCRequest -URI $URI -Method Post -Body $Body
}