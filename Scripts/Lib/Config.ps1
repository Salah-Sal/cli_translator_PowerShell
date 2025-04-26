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
    $ArticlesDir = $env:ARTICLES_DIR # Read env var first
    if ([string]::IsNullOrEmpty($ArticlesDir)) {
        $ArticlesDir = $DefaultArticlesDir # Assign default if env var was null or empty
    }
    $JobsDir = $env:JOBS_DIR # Read env var first
    if ([string]::IsNullOrEmpty($JobsDir)) {
        $JobsDir = $DefaultJobsDir # Assign default if env var was null or empty
    }
    $PromptsDir = $env:PROMPTS_DIR
    # $OpenAiApiKey = $env:OPENAI_API_KEY

    # Construct and return configuration object
    $Config = [PSCustomObject]@{
        ProjectRoot   = $ProjectRoot
        ArticlesDir   = $ArticlesDir
        JobsDir       = $JobsDir
        PromptsDir    = $PromptsDir # Add PromptsDir to the output object
        # OpenAiApiKey  = $OpenAiApiKey
    }

    Write-Verbose "Loaded configuration: $($Config | ConvertTo-Json -Depth 3)"
    return $Config
} 