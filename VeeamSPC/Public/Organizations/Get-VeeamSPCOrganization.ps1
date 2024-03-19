function Get-VeeamSPCOrganization {
    param()
    $URI = 'organizations'
    Invoke-VeeamSPCRequest -URI $URI -Method Get
}