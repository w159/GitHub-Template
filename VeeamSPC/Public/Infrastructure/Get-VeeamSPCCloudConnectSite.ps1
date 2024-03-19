function Get-VeeamSPCCloudConnectSite {
    param()
    $URI = 'infrastructure/sites'
    Invoke-VeeamSPCRequest -URI $URI -Method Get
}