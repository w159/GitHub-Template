function Set-VeeamSPCCompany {
    param(
        [Parameter(Mandatory)]
        $CompanyID,
        [Parameter(Mandatory)]
        $Site,
        [Parameter(Mandatory)]
        $Resource,
        [ValidateSet('add', 'replace', 'test', 'remove', 'move', 'copy')]
        [Parameter(Mandatory)]
        $OP,
        [Parameter(Mandatory)]
        $Value,
        [Parameter(Mandatory)]
        $Path,
        $From
    )
    $URI = "/organizations/companies/$($CompanyID)"
    Invoke-VeeamSPCRequest -URI $URI -Method Patch
}