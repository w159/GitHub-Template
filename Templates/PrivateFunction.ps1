function ConvertTo-InternalFormat {
    <#
    .SYNOPSIS
    Brief description of what this private/helper function does

    .DESCRIPTION
    Detailed description of the internal function's purpose.
    Private functions typically support public functions and are not exported.

    .PARAMETER InputData
    Description of the parameter

    .NOTES
    This is a private function and is not exported from the module.
    It is designed to be called by other functions within the module.

    Version:        1.0.0
    Author:         Your Name
    Creation Date:  YYYY-MM-DD

    .EXAMPLE
    ConvertTo-InternalFormat -InputData $data

    Internal usage example
    #>
    [CmdletBinding()]
    [OutputType([System.Object])]
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [object]$InputData
    )

    begin {
        Write-Debug -Message "Starting private function: $($MyInvocation.MyCommand)"
    }

    process {
        try {
            Write-Debug -Message "Processing input data: $($InputData.GetType().Name)"

            # Internal processing logic
            $result = [PSCustomObject]@{
                ProcessedData = $InputData
                ProcessedAt   = Get-Date
            }

            return $result
        }
        catch {
            Write-Error -Message "Error in private function" -ErrorRecord $_
            throw
        }
    }

    end {
        Write-Debug -Message "Completed private function: $($MyInvocation.MyCommand)"
    }
}
