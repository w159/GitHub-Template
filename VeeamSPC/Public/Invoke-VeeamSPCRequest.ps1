function Invoke-VeeamSPCRequest {
    param (
        $URI,
        $Method,
        $Body
    )
    if (!$script:VeeamSPCConnection) { throw 'Use Connect-VeeamSPC first.' }

    $Splat = @{
        Method      = $Method
        ContentType = 'application/json'
        Headers     = $script:VeeamSPCConnection.Headers
    }
    if ($Body) {
        $Splat.Body = $Body
        Write-Verbose $Body
    }

    $URL = [System.UriBuilder]$script:VeeamSPCConnection.Server
    $URL.Scheme = 'https'
    $URL.Port = $script:VeeamSPCConnection.Port
    $URL.Path = Join-URL '/api/v3' $URI

    $Offset = 0
    do {
        $Query = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
        if ($Offset -gt 0) { $Query.add('offset', $Offset) }
        $URL.Query = $Query.ToString()
        $Result = Invoke-RestMethod @Splat -Uri $URL.Uri.OriginalString
        $Offset = $Result.meta.pagingInfo.count
        # Needed to adjust throttle settings
        # https://helpcenter.veeam.com/docs/vac/rest/throttling.html
        # if ($Offset -gt 0) { Start-Sleep -Milliseconds 500 }
        $Result.data
    }
    while ($Result.meta -and $Result.meta.pagingInfo.count + $Result.meta.pagingInfo.offset -lt $Result.meta.pagingInfo.total)
}