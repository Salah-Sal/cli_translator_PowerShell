# Contributing Guidelines for Markdown Translator CLI (PowerShell)

Welcome, Developer! This document is your primary guide for contributing to the **Markdown Translator CLI (PowerShell)** project. Adhering to these guidelines is essential for maintaining code quality, consistency, and a clear project history.

We use a strict **Test-Driven Development (TDD)** methodology with **Pester** and specific **Git/GitHub CLI workflows**. Please read this guide carefully before starting any development task.

## Table of Contents

1.  [Getting Started](#1-getting-started)
    *   [Prerequisites](#prerequisites)
    *   [Initial Setup](#initial-setup)
2.  [Development Workflow](#2-development-workflow)
    *   [Issue Assignment](#issue-assignment)
    *   [Creating the Issue](#creating-the-issue)
    *   [Branching](#branching)
    *   [Test-Driven Development (TDD) Cycle](#test-driven-development-tdd-cycle)
    *   [Committing Changes](#committing-changes)
    *   [Keeping Your Branch Updated](#keeping-your-branch-updated)
    *   [Creating a Pull Request (PR)](#creating-a-pull-request-pr)
    *   [Code Review](#code-review)
    *   [Merging and Cleanup](#merging-and-cleanup)
3.  [Coding Standards](#3-coding-standards)
    *   [PowerShell Style](#powershell-style)
    *   [Pester Tests](#pester-tests)
    *   [Error Handling](#error-handling)
4.  [Commit Message Conventions](#4-commit-message-conventions)
5.  [Tooling](#5-tooling)

## 1. Getting Started

### Prerequisites

Ensure you have the following tools installed and configured on your Windows 11 machine:

*   **PowerShell 7+:** Verify with `pwsh --version`.
*   **Git:** Verify with `git --version`.
*   **GitHub CLI (`gh`):** Verify with `gh --version`. Authenticate using `gh auth login`.
*   **Pester Module:** Verify with `Get-Module -ListAvailable Pester`. Install/Update if necessary (`Install-Module Pester -Scope CurrentUser -Force -SkipPublisherCheck`).
*   **`jq` CLI:** Download/install, ensure it's in PATH. Verify with `jq --version`.
*   **`llm` CLI:** Install (`pipx install llm` or `pip install llm`). Verify with `llm --version`. Configure API keys as needed later (`llm keys set <provider>`).
*   **(Recommended):** VS Code with the PowerShell Extension.

### Initial Setup

1.  **Clone the Repository:** (If not already done) `gh repo clone YourGitHubUsername/MarkdownTranslatorCLI-PS`
2.  **Navigate to Project Directory:** `cd MarkdownTranslatorCLI-PS`
3.  **Environment Variables:** Copy `.env.example` to `.env` (`Copy-Item .env.example .env`). Edit `.env` to add any necessary API keys (e.g., `OPENAI_API_KEY="..."`). **Never commit the `.env` file.**
4.  **Verify Setup:** Run `Invoke-Pester` in the project root. Ensure it runs without errors (it might show 0 tests initially, or pass the basic setup test after Issue #1).

## 2. Development Workflow

We follow an Issue-driven, TDD workflow using feature branches and Pull Requests. **All Git and GitHub operations must be performed via the command line (`git`, `gh`).**

### Issue Assignment

*   The Lead Developer will define tasks and provide detailed specifications for each GitHub Issue, including acceptance criteria and specific Pester test scenarios to implement first.

### Creating the Issue

*   Before starting work, you **must** create the corresponding GitHub Issue using the `gh` command line tool with the exact Title, Body, Labels, and Assignee provided by the Lead Developer.
    ```powershell
    # Example:
    gh issue create --title "feat: Implement basic article discovery (#3)" --body "Details provided by Lead Dev..." --label "feature,article-handling" --assignee "@me"
    ```
*   Note the Issue number created.

### Branching

*   Always work on a feature branch, never directly on `main`.
*   Checkout the latest `main` branch:
    ```powershell
    git checkout main
    git pull origin main
    ```
*   Create a new branch named according to the Issue number and a short description:
    ```powershell
    # Example for Issue #3:
    git checkout -b 3-article-discovery
    ```

### Test-Driven Development (TDD) Cycle

We use Pester for TDD. Follow the **Red-Green-Refactor** cycle strictly for *every* piece of functionality:

1.  **RED:**
    *   Write a **minimal failing Pester test** (`It` block within a `Describe` or `Context` block in the relevant `*.Tests.ps1` file) that defines the *next small piece* of behavior required by the Issue specification.
    *   Use Pester's assertion library (`Should`).
    *   If testing functions that interact with external commands (`llm.exe`, `jq.exe`) or PowerShell cmdlets (`Get-ChildItem`, `Get-Content`, `$env:`), use Pester's `Mock` command extensively within your test's `Context` or `It` block to isolate the code under test.
    *   Run `Invoke-Pester` and **verify the new test fails** for the expected reason.
2.  **GREEN:**
    *   Write the **absolute minimum amount of PowerShell code** (in the corresponding `*.ps1` script/function) required to make the failing test pass. Do *not* add extra features or unrelated code.
    *   Run `Invoke-Pester` again and **verify the new test passes**, and no existing tests have broken.
3.  **REFACTOR:**
    *   Look at the code you just wrote (and potentially the test). Can it be made clearer, more efficient, or better designed *without changing its behavior*?
    *   Make necessary refactoring changes.
    *   Run `Invoke-Pester` **again** to ensure all tests still pass after refactoring.
4.  **REPEAT:** Go back to RED for the next small piece of functionality required by the Issue.

### Committing Changes

*   **Commit frequently**, ideally after each successful Red-Green cycle or significant Refactor step. Small, atomic commits make the history easier to understand and review.
*   **Use Conventional Commits format** (See Section 4). This is mandatory.
*   Reference the driving Issue number in your commit messages (e.g., `feat(config): implement env var loading (#2)`).
    ```powershell
    git add . # Stage changes
    git status # Review staged changes
    git commit -m "test(config): add failing test for default path loading (#2)"
    # ... implement code ...
    git add .
    git commit -m "feat(config): implement default path loading (#2)"
    # ... refactor ...
    git add .
    git commit -m "refactor(config): improve project root calculation (#2)"
    ```

### Keeping Your Branch Updated

*   Periodically, update your feature branch with the latest changes from `main` to avoid large merge conflicts later:
    ```powershell
    git fetch origin # Get latest changes from remote without merging
    git rebase origin/main # Replay your branch's commits on top of the latest main
    # Resolve any conflicts if they occur, then 'git rebase --continue'
    # Run Invoke-Pester after rebasing to ensure nothing broke
    ```
*   Push your local branch changes regularly (e.g., end of day):
    ```powershell
    git push origin HEAD # Pushes the current branch
    # Or: git push --set-upstream origin <branch-name> # First time pushing branch
    ```

### Creating a Pull Request (PR)

*   Once all requirements for the Issue are met, all tests pass, and you are ready for review:
    1.  Ensure your branch is up-to-date with `main` (`git rebase origin/main`).
    2.  Push your final changes (`git push origin HEAD`).
    3.  Create the PR using the `gh` CLI:
        ```powershell
        gh pr create --fill --assignee @me --label "feature" # Add other relevant labels
        ```
        *   `--fill`: Uses your commit messages to pre-populate the PR title and body.
        *   **Crucially, review the PR description** generated by `gh`. **Ensure it clearly states `Closes #<IssueNumber>`** to automatically link the PR to the Issue. Add any extra context needed for the reviewer.
    4.  *(Optional but good practice):* Use `gh pr view --web` to open the PR in the browser and double-check everything looks correct.

### Code Review

*   The Lead Developer will review your PR. They will check:
    *   Code functionality against the Issue requirements.
    *   Adherence to the TDD process (commit history, test coverage).
    *   Code quality and PowerShell best practices.
    *   Correct use of Conventional Commits.
    *   Passing Pester tests.
*   Address any feedback provided by making changes on your feature branch and pushing the updates. The PR will update automatically.

### Merging and Cleanup

*   Once the PR is approved, the Lead Developer will merge it into `main` (likely using a squash merge).
*   After the merge, clean up your local repository:
    ```powershell
    git checkout main          # Switch back to main
    git pull origin main       # Get the merged changes
    git branch -d <feature-branch-name> # Delete the local feature branch
    # The remote branch might be deleted automatically on merge, or use:
    # git push origin --delete <feature-branch-name>
    ```

## 3. Coding Standards

### PowerShell Style

*   Follow common PowerShell naming conventions (Verb-Noun for functions, PascalCase for parameters and variables).
*   Use approved verbs (`Get-`, `Set-`, `New-`, `Invoke-`, `Test-`, etc.).
*   Write comment-based help for functions (`<# .SYNOPSIS ... #>`).
*   Keep functions focused on a single task.
*   Aim for readable and maintainable code.

### Pester Tests

*   Use clear `Describe`, `Context`, and `It` blocks to structure tests logically.
*   Test names (`It 'Should do X when Y'`) should clearly state the expected behavior.
*   Use specific `Should` assertions. Avoid generic checks where possible.
*   Mock dependencies effectively using `Mock` to isolate the unit under test.
*   Use `BeforeEach`/`AfterEach` for setup/teardown within `Context` blocks to ensure test isolation.

### Error Handling

*   Use `try`/`catch` blocks for operations that might fail (e.g., external process calls, file I/O).
*   Use `Write-Error` for terminating errors within functions where appropriate.
*   Use `Write-Warning` for non-critical issues.
*   Use `Write-Verbose` for detailed operational messages (useful for debugging).

## 4. Commit Message Conventions

We use **Conventional Commits**. This is mandatory for clear history and potential automated tooling later.

*   **Format:** `<type>[optional scope]: <description>`
    *   **Types:** `feat`, `fix`, `test`, `refactor`, `chore`, `docs`, `style`, `perf`, `ci`, `build`
    *   **Scope:** Optional, indicates the part of the codebase affected (e.g., `config`, `chunking`, `llm`, `ui`).
    *   **Description:** Short summary in present tense (e.g., "add function" not "added function"). Lowercase. No period at the end.
*   **Body (Optional):** Explain *why* the change was made.
*   **Footer (Optional):** Reference issues (`Refs: #123`), indicate breaking changes (`BREAKING CHANGE: ...`).

*   **Examples:**
    *   `test(config): add failing test for env var loading (#2)`
    *   `feat(config): implement env var loading (#2)`
    *   `fix(llm): handle empty output from llm.exe (#5)`
    *   `docs(readme): update installation instructions`
    *   `chore: update .gitignore`
    *   `refactor(chunking)!: change Split-Markdown function signature`\
        `BREAKING CHANGE: Split-MarkdownToParagraph now requires MaxLength parameter.`

## 5. Tooling

*   **Primary Interface:** PowerShell Terminal
*   **Version Control:** `git` CLI
*   **GitHub Interaction:** `gh` CLI
*   **Testing:** `Invoke-Pester` command
*   **LLM Interaction:** `llm.exe` CLI (called from scripts)
*   **JSON Processing:** `jq.exe` CLI (called from scripts)
*   **Editor:** VS Code with PowerShell Extension (recommended)

---

By following these guidelines, we can build a high-quality, maintainable, and well-tested application efficiently. Please refer back to this document frequently and ask questions if anything is unclear. Let's get started!

## Troubleshooting Notes

### Initial Pester Discovery Issue (Resolved)

During initial project setup (Issue #1), we encountered a persistent issue where `Invoke-Pester` failed to discover the test file (`Tests\Project.Tests.ps1`) when run from the project root, consistently reporting 0 tests found.

**Symptoms:**
*   `Invoke-Pester` (run from project root) output: `Tests Passed: 0, Failed: 0, Skipped: 0...`
*   Confirmed Pester v5.7.1 was installed and active.
*   Test file `Tests\Project.Tests.ps1` existed with correct naming and basic Pester v5 syntax.
*   Execution Policy (`RemoteSigned`) was confirmed not to be the cause.
*   Recreating the test file (to rule out encoding issues) did not help.
*   Explicitly targeting the path (`Invoke-Pester -Path .\Tests`, `Invoke-Pester -Script .\Tests\Project.Tests.ps1`) did not help when run from the root.

**Troubleshooting Steps:**
Several commands required manual execution by the developer due to limitations or errors in the AI assistant's terminal interaction tooling, particularly with complex commands, interactive prompts, or specific path types:
*   `gh issue create` (initially)
*   `git commit`
*   `Install-Module Pester` (due to NuGet prompt)
*   Various `Invoke-Pester` variations for diagnostics.
*   File creation (`Set-Content`) and inspection (`Get-Content -Encoding Byte`) outside the primary workspace during diagnostics.

**Resolution/Diagnosis:**
A diagnostic test was performed by creating a minimal test file (`minimal.Tests.ps1`) in a temporary subdirectory (`D:\ML-Projects\machine-translation\translator_win\.tmp\PesterCheck`) and running `Invoke-Pester` *from within that subdirectory*.
*   **Result:** Pester **successfully** discovered and ran the test (1 test passed) in this isolated scenario.
*   **Conclusion:** The core Pester v5 installation is functional. The issue is specific to test *discovery* when `Invoke-Pester` is executed from the project root (`D:\ML-Projects\machine-translation\translator_win`) and targets the `.\Tests` subdirectory. The exact cause (e.g., hidden configuration, permissions on `.\Tests`, path resolution quirk from root) is still under investigation but localized to this specific context.

**Tooling Note:**
The AI assistant encountered limitations executing certain commands involving interactive prompts, multi-line inputs, absolute paths outside the workspace for file edits, and potentially complex PowerShell variable/command chaining via its `run_terminal_cmd` tool. Manual execution was used as a workaround for these specific commands. 
*   **Commit Verification:** Additionally, the assistant may sometimes fail to recognize if a `git commit` command succeeded on the first try, potentially due to incomplete terminal output capture. It might retry the command unnecessarily. Developer confirmation of successful commits is helpful in these cases. 

### Testing Dot-Sourced Scripts (Issue #2 - Config.ps1)

When testing functions loaded via dot-sourcing (`. "path\to\script.ps1"`) from a `.Tests.ps1` file, several issues were encountered:

*   **Issue:** `Export-ModuleMember` in the dot-sourced script (`Config.ps1`) caused an `InvalidOperationException` because it's only valid within modules (`.psm1`).
    *   **Solution:** Removed the `Export-ModuleMember` line from `Config.ps1`.
*   **Issue:** Function relying on `$MyInvocation.MyCommand.Path` to calculate the project root failed when dot-sourced, as `$MyInvocation` context differs.
    *   **Solution:** Refactored the function (`Get-TranslatorConfiguration`) to accept the project root path as a mandatory parameter (`[Parameter(Mandatory=$true)][string]$ProjectRoot`).
*   **Issue:** The test script (`Config.Tests.ps1`) needed to calculate and pass the project root.
    *   **Solution:** Used `$script:ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..")` in the `BeforeAll` block of the test script and passed `$script:ProjectRoot` to the function call.
*   **Issue:** Direct parameter passing (`FunctionName -Parameter $Value`) sometimes resulted in unexpected interactive prompts for mandatory parameters during test runs.
    *   **Solution:** Switched to using parameter splatting (`$Params = @{ Parameter = $Value }; FunctionName @Params`) in the test's `It` block for cleaner and more reliable parameter binding.
*   **Issue:** Initial dot-sourcing at the top level of the test script sometimes led to `CommandNotFoundException` for the function.
    *   **Solution:** Moved the dot-sourcing command (`. (Join-Path $script:ProjectRoot 'Scripts\Lib\Config.ps1')`) inside the `BeforeAll` block, after the `$script:ProjectRoot` was defined. 