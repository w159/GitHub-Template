function Get-VeeamSPCCompanyBackupResources {
    param(
        $Company,
        $Site,
        $Resource
    )
    $URI = "organizations/companies/$($Company)/sites/$($Site)/backupResources"
    Invoke-VeeamSPCRequest -URI $URI -Method Get
}