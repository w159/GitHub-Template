function Verb-Noun {
    <#
    .SYNOPSIS
    Brief description of what the function does

    .DESCRIPTION
    Detailed description of the function's purpose and behavior.
    This is where you explain what the function does in more detail.

    .PARAMETER ParameterName
    Description of the parameter and what it accepts

    .INPUTS
    The .NET types of objects that can be piped to this function.
    Example: System.String

    .OUTPUTS
    The .NET type(s) of objects that this function returns.
    Example: System.Management.Automation.PSCustomObject

    .NOTES
    Version:        1.0.0
    Author:         Your Name
    Creation Date:  YYYY-MM-DD
    Purpose/Change: Initial function development

    .LINK
    https://github.com/YOUR-USERNAME/YOUR-REPO

    .EXAMPLE
    Verb-Noun -ParameterName "Value"

    Description of what this example does

    .EXAMPLE
    Get-Something | Verb-Noun

    Description of pipeline example
    #>
    [CmdletBinding(SupportsShouldProcess = $false)]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param(
        [Parameter(
            Mandatory = $true,
            Position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            HelpMessage = "Enter a brief help message for this parameter"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$ParameterName,

        [Parameter(Mandatory = $false)]
        [switch]$OptionalSwitch
    )

    begin {
        Write-Verbose -Message "Starting $($MyInvocation.MyCommand)"
        Write-Debug -Message "Parameters: $($PSBoundParameters | Out-String)"

        # Initialize any variables needed for the entire function
        $results = [System.Collections.Generic.List[PSCustomObject]]::new()
    }

    process {
        try {
            Write-Verbose -Message "Processing: $ParameterName"

            # Main function logic here
            $output = [PSCustomObject]@{
                PSTypeName = 'ModuleName.ObjectType'
                Property1  = $ParameterName
                Property2  = 'Value'
                Timestamp  = Get-Date
            }

            $results.Add($output)

            Write-Verbose -Message "Successfully processed: $ParameterName"
        }
        catch {
            Write-Error -Message "Failed to process $ParameterName" -ErrorRecord $_
            throw
        }
    }

    end {
        Write-Verbose -Message "Completed $($MyInvocation.MyCommand)"

        # Return results
        return $results
    }
}
