@{
    Severity = @('Error', 'Warning')

    # Exclude rules that conflict with module design decisions
    ExcludeRules = @(
        # Plural nouns are intentional for clarity (Get-UnifiDevices, Get-UnifiSites, etc.)
        'PSUseSingularNouns'

        # WiFi passphrase parameters are industry standard as plain strings
        # The UniFi API requires passphrases as strings, not SecureString
        'PSAvoidUsingUsernameAndPasswordParams'
        'PSAvoidUsingPlainTextForPassword'
    )

    Rules = @{
        PSPlaceOpenBrace           = @{
            Enable             = $true
            OnSameLine         = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
        }

        PSPlaceCloseBrace          = @{
            Enable             = $true
            NewLineAfter       = $true
            IgnoreOneLineBlock = $true
            NoEmptyLineBefore  = $false
        }

        PSUseConsistentIndentation = @{
            Enable              = $true
            Kind                = 'space'
            PipelineIndentation = 'IncreaseIndentationForFirstPipeline'
            IndentationSize     = 4
        }

        PSUseConsistentWhitespace  = @{
            Enable                                  = $true
            CheckInnerBrace                         = $true
            CheckOpenBrace                          = $true
            CheckOpenParen                          = $true
            CheckOperator                           = $true
            CheckPipe                               = $true
            CheckPipeForRedundantWhitespace         = $false
            CheckSeparator                          = $true
            CheckParameter                          = $false
            IgnoreAssignmentOperatorInsideHashTable = $true
        }

        PSProvideCommentHelp       = @{
            Enable                  = $true
            ExportedOnly            = $true
            BlockComment            = $true
            VSCodeSnippetCorrection = $false
            Placement               = 'begin'
        }

        PSAlignAssignmentStatement = @{
            Enable         = $false
            CheckHashtable = $false
        }
    }
}
