function Get-VeeamSPCCompany {
    param()
    $URI = 'organizations/companies'
    Invoke-VeeamSPCRequest -URI $URI -Method Get
}