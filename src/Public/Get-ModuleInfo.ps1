function Get-ModuleInfo {
    <#
    .SYNOPSIS
    Gets information about the ModuleName module

    .DESCRIPTION
    Returns version, author, and other metadata about the ModuleName module.
    This is an example function to demonstrate the module structure.

    .OUTPUTS
    System.Management.Automation.PSCustomObject
    Returns an object with module information

    .NOTES
    Version:        1.0.0
    Author:         Your Name
    Creation Date:  2024-01-01
    Purpose/Change: Example function for module template

    .LINK
    https://github.com/YOUR-USERNAME/ModuleName

    .EXAMPLE
    Get-ModuleInfo

    Returns information about the ModuleName module

    .EXAMPLE
    Get-ModuleInfo | Format-List

    Displays module information as a formatted list
    #>
    [CmdletBinding()]
    [OutputType([System.Management.Automation.PSCustomObject])]
    param()

    begin {
        Write-Verbose -Message "Starting $($MyInvocation.MyCommand)"
    }

    process {
        try {
            # Get module manifest
            $ModuleRoot = Split-Path -Parent $PSScriptRoot
            $ManifestPath = Join-Path $ModuleRoot 'ModuleName.psd1'

            if (-not (Test-Path $ManifestPath)) {
                throw "Module manifest not found at: $ManifestPath"
            }

            Write-Debug -Message "Reading manifest from: $ManifestPath"
            $Manifest = Import-PowerShellDataFile -Path $ManifestPath

            # Build output object
            $ModuleInfo = [PSCustomObject]@{
                PSTypeName        = 'ModuleName.ModuleInfo'
                Name              = $Manifest.RootModule -replace '\.psm1$', ''
                Version           = $Manifest.ModuleVersion
                Author            = $Manifest.Author
                CompanyName       = $Manifest.CompanyName
                Copyright         = $Manifest.Copyright
                Description       = $Manifest.Description
                PowerShellVersion = $Manifest.PowerShellVersion
                RequiredModules   = $Manifest.RequiredModules
                FunctionsExported = $Manifest.FunctionsToExport.Count
                ProjectUri        = $Manifest.PrivateData.PSData.ProjectUri
                LicenseUri        = $Manifest.PrivateData.PSData.LicenseUri
            }

            Write-Verbose -Message "Retrieved module info: $($ModuleInfo.Name) v$($ModuleInfo.Version)"

            return $ModuleInfo
        } catch {
            Write-Error -Message "Failed to get module information" -ErrorRecord $_
            throw
        }
    }

    end {
        Write-Verbose -Message "Completed $($MyInvocation.MyCommand)"
    }
}
