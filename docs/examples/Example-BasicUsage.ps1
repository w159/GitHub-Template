#requires -Version 7.0

<#
.SYNOPSIS
Example script demonstrating basic usage of ModuleName

.DESCRIPTION
This example shows how to use the core functions of the ModuleName module.
Update this with actual examples from your module once functions are implemented.

.NOTES
Author: Your Name
Date: YYYY-MM-DD
#>

# Import the module
Import-Module ModuleName -Force

# Example 1: Basic function usage
Write-Host "Example 1: Basic Usage" -ForegroundColor Cyan
$result = Get-Something -Name "Example"
$result | Format-Table -AutoSize

# Example 2: Pipeline usage
Write-Host "`nExample 2: Pipeline Usage" -ForegroundColor Cyan
@('Item1', 'Item2', 'Item3') | Get-Something | Format-Table -AutoSize

# Example 3: Error handling
Write-Host "`nExample 3: Error Handling" -ForegroundColor Cyan
try {
    Get-Something -Name "InvalidInput"
}
catch {
    Write-Host "Caught error: $($_.Exception.Message)" -ForegroundColor Yellow
}

# Example 4: Using parameters
Write-Host "`nExample 4: Using Parameters" -ForegroundColor Cyan
$params = @{
    Name    = "Example"
    Verbose = $true
}
Get-Something @params
