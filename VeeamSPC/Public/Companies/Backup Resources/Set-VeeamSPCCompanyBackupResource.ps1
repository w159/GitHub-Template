function Set-VeeamSPCCompanyBackupResource {
    param(
        [Parameter(Mandatory)]
        $Company,
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
    $URI = "organizations/companies/$($Company)/sites/$($Site)}/backupResources/$($Resource)"
    Invoke-VeeamSPCRequest -URI $URI -Method Patch
}