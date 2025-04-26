# Scripts/Lib/Config.ps1

function Get-TranslatorConfiguration {
    [CmdletBinding()]
    param(
        # Project Root Path - Mandatory
        [Parameter(Mandatory=$true)]
        [string]$ProjectRoot
    )

    # Removed internal calculation logic - ProjectRoot must be provided by caller.

    Write-Verbose "Using Project Root: $ProjectRoot"

    # Define Default Paths (relative to Project Root)
    $DefaultArticlesDir = Join-Path $ProjectRoot "Articles"
    $DefaultJobsDir = Join-Path $ProjectRoot "Jobs"
    $DefaultPromptsDir = Join-Path $ProjectRoot "Prompts"

    # Read from Environment Variables or use Defaults
    $ArticlesDir = $env:ARTICLES_DIR # Test requires reading this
    $JobsDir = $env:JOBS_DIR # Add reading JOBS_DIR
    # $PromptsDir = $env:PROMPTS_DIR -or $DefaultPromptsDir
    # $OpenAiApiKey = $env:OPENAI_API_KEY

    # Construct and return configuration object
    $Config = [PSCustomObject]@{
        ProjectRoot   = $ProjectRoot
        ArticlesDir   = $ArticlesDir
        JobsDir       = $JobsDir # Add JobsDir to the output object
        # PromptsDir    = $PromptsDir
        # OpenAiApiKey  = $OpenAiApiKey
    }

    Write-Verbose "Loaded configuration: $($Config | ConvertTo-Json -Depth 3)"
    return $Config
} 