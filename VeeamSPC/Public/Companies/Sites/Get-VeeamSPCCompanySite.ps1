function Get-VeeamSPCCompanySite {
    param(
        $Company,
        $Site,
        $Resource
    )
    $URI = 'organizations/companies/sites'
    Invoke-VeeamSPCRequest -URI $URI -Method Get
}