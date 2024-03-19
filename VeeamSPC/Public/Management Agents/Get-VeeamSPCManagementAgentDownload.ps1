function Get-VeeamSPCManagementAgentDownload {
    param()
    $URI = 'infrastructure/managementAgents/packages/windows'
    Invoke-VeeamSPCRequest -URI $URI -Method Get
}