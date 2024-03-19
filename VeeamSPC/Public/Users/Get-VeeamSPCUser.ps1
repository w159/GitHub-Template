function Get-VeeamSPCUser {
    param()
    $URI = 'users/logins'
    Invoke-VeeamSPCRequest -URI $URI -Method Get
}