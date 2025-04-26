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
    # For now, just read the one needed for the current test
    $ArticlesDir = $env:ARTICLES_DIR # Test requires reading this
    # $JobsDir = $env:JOBS_DIR -or $DefaultJobsDir
    # $PromptsDir = $env:PROMPTS_DIR -or $DefaultPromptsDir
    # $OpenAiApiKey = $env:OPENAI_API_KEY

    # Construct and return configuration object
    $Config = [PSCustomObject]@{
        ProjectRoot   = $ProjectRoot
        ArticlesDir   = $ArticlesDir # Populate from env var
        # JobsDir       = $JobsDir
        # PromptsDir    = $PromptsDir
        # OpenAiApiKey  = $OpenAiApiKey
    }

    Write-Verbose "Loaded configuration: $($Config | ConvertTo-Json -Depth 3)"
    return $Config
} 