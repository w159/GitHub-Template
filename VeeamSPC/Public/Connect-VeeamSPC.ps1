function Connect-VeeamSPC {
    param(
        $Server,
        $Port,
        $Key
    )
    $Script:VeeamSPCConnection = @{
        Headers = @{ Authorization = "Bearer $($Key)" }
        Server  = $Server
        Port    = $Port
        BaseURI = "https://$($Server):$($Port)/api/v3"
    }
}