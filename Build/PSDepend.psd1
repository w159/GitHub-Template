@{
    # Build dependencies
    # These modules are required for building, testing, and publishing the module
    # Install with: Invoke-PSDepend -Path .\Build\PSDepend.psd1 -Install -Import -Force

    PSDependOptions  = @{
        Target    = 'CurrentUser'
        AddToPath = $true
    }

    # Build Automation
    'InvokeBuild'    = @{
        Version    = 'latest'
        Parameters = @{
            SkipPublisherCheck = $true
        }
    }

    # Testing Framework
    'Pester'         = @{
        Version    = '5.6.1'
        Parameters = @{
            SkipPublisherCheck = $true
        }
    }

    # Code Quality Analysis
    'PSScriptAnalyzer' = @{
        Version    = 'latest'
        Parameters = @{
            SkipPublisherCheck = $true
        }
    }

    # Documentation Generation
    'platyPS'        = @{
        Version    = 'latest'
        Parameters = @{
            SkipPublisherCheck = $true
        }
    }
}
