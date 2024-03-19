function Get-VeeamSPCDiscoveredComputer {
    param()
    $URI = 'discovery/computers'
    Invoke-VeeamSPCRequest -URI $URI -Method Get
}