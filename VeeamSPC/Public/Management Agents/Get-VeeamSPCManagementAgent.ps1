function Get-VeeamSPCManagementAgent {
    param()
    $URI = 'infrastructure/managementAgents'
    Invoke-VeeamSPCRequest -URI $URI -Method Get
}