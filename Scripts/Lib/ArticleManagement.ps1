# Scripts/Lib/ArticleManagement.ps1

function Get-MarkdownArticle {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ArticlesDirectory
    )

    Write-Verbose "Get-MarkdownArticle called for directory: $ArticlesDirectory"

    Write-Verbose "Searching for *.md files in: $ArticlesDirectory"

    # Initial implementation returns empty array
    # return @() 

    # Implementation refined via TDD:
    if (-not (Test-Path -Path $ArticlesDirectory -PathType Container)) {
        # Handle non-existent directory later based on tests
        # Write-Warning "Article directory not found: $ArticlesDirectory"
        return @() # Return empty array if directory doesn't exist (for now)
    }

    try {
        # Restore -File parameter
        $MarkdownFiles = Get-ChildItem -Path $ArticlesDirectory -Filter *.md -File 
        Write-Verbose "Found $($MarkdownFiles.Count) markdown files."
        return $MarkdownFiles # Return array of FileInfo objects
    } catch {
        Write-Error "An error occurred while accessing '$ArticlesDirectory': $($_.Exception.Message)"
        return @() # Return empty on other errors
    }
}

# Export-ModuleMember -Function Get-MarkdownArticle # Keep commented out for dot-sourcing 