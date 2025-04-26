# Project Lead Guide: Markdown Translator CLI (PowerShell)

Welcome! You are the Lead Developer for the **Markdown Translator CLI** project. This document is your primary, comprehensive guide to understanding the project's goals, technical details, and the **strict Test-Driven Development (TDD)** workflow you must manage and enforce using **PowerShell** on Windows 11.

**Please read this entire document carefully before supervising development.**

## 1. Project Vision & Goal

*   **Goal:** To create a robust, reusable, and well-tested **PowerShell** command-line application (and potentially supporting modules) that translates Markdown (`.md`) files using Large Language Models (LLMs) via an external CLI tool. The tool should handle large files via chunking, allow selection of different LLMs, utilize system prompts, and manage translation jobs for potential resumption.
*   **Primary Use Case:** Provide an efficient way for users on Windows to translate technical or content-heavy Markdown documents, generating output suitable for review or further processing, while abstracting the complexities of LLM APIs and file handling through scripting.
*   **Core Tools & Frameworks:** Leverage the external `llm` command-line tool (by Simon Willison) for flexible interaction with various LLM providers, **Pester** as the testing framework for PowerShell TDD, and standard PowerShell cmdlets for file/JSON handling.

## 2. Current Project Status (Initial State)

*   **Repository:** TBD (e.g., `YourGitHubUsername/MarkdownTranslatorCLI-PS` - needs creation on GitHub). **Starts completely empty.**
*   **Main Branch (`main`):** Will contain all successfully integrated and reviewed code. Development starts by initializing the repository.
*   **Completed & Merged Features:** None. This is the absolute beginning.
*   **Work In Progress / Next Steps:**
    *   **(FIRST TASK): Project Setup & Foundational Structure (PowerShell)** - *Requires New Issue (e.g., #1)*. Includes initializing the Git repository, setting up the basic directory structure, installing/configuring Pester, creating `.gitignore`, initial `README.md`, and `CONTRIBUTING.md`.
    *   See the project's GitHub Issues (once created) for the active task log.

## 3. Technical Overview

*   **Language:** **PowerShell** (Targeting PowerShell 7.x recommended for modern features and cross-platform compatibility, but core functionality might work on Windows PowerShell 5.1).
*   **Key Tools & Dependencies:**
    *   **External CLIs:**
        *   `llm` (by Simon Willison) - For interacting with various LLMs. **Must be installed separately.**
        *   `jq` - For parsing and manipulating JSON data (like job metadata). **Must be installed separately.**
        *   `git` - For version control. **Must be installed separately.**
        *   `gh` (GitHub CLI) - For workflow management. **Must be installed separately.**
    *   **PowerShell Modules:**
        *   `Pester` - The testing framework for PowerShell. (Usually needs installation: `Install-Module Pester -Scope CurrentUser`).
        *   `PSReadLine` (Usually built-in) - For enhanced console experience.
    *   *(Future):* Potentially custom PowerShell modules (`.psm1`) for better code organization.
*   **Initial Project Structure (Proposed):**
    ```
    MarkdownTranslatorCLI-PS/
    ├── .git/
    ├── Modules/              # Optional: For reusable PowerShell modules later
    │   └── MdTranslator/
    │       ├── MdTranslator.psd1
    │       └── ...
    ├── Scripts/              # Core PowerShell scripts (.ps1 files)
    │   ├── Lib/              # Helper scripts/functions sourced by main scripts
    │   │   ├── Config.ps1
    │   │   ├── UIHelpers.ps1
    │   │   ├── ArticleManagement.ps1
    │   │   ├── Chunking.ps1
    │   │   ├── LLMInteraction.ps1
    │   │   └── JobManagement.ps1
    │   └── Start-MarkdownTranslatorCli.ps1 # Main entry point script
    ├── Tests/                # Pester tests (.Tests.ps1 files)
    │   ├── Config.Tests.ps1
    │   ├── UIHelpers.Tests.ps1
    │   # ... mirroring scripts/functions needing tests
    ├── Articles/             # Default location for user's Markdown files
    ├── Jobs/                 # Directory for storing translation job data
    ├── Prompts/              # Directory for system prompts
    ├── .env.example          # Example environment file structure for API keys etc.
    ├── .gitignore
    ├── CONTRIBUTING.md       # Detailed workflow guide for the developer
    ├── LICENSE               # Choose an appropriate license (e.g., MIT)
    └── README.md             # General project overview
    ```
*   **Core Design:** Script-based initially, potentially evolving to use PowerShell modules. Relies heavily on calling external CLIs (`llm`, `jq`). TDD using Pester is central, requiring mocking of external commands and file system interactions. Functions defined within scripts or sourced from the `Lib` directory.

## 4. Development Workflow & Rules (CRITICAL - TDD Focused)

This project utilizes a **specific and strict** development workflow centered around **Test-Driven Development (TDD)** using **Pester**. Your primary role is to **understand, model, and enforce** this workflow with the developer. (Refer to `CONTRIBUTING.md` which will detail the steps the developer follows).

**Key Constraints & Rules Recap:**

1.  **Shared GitHub Account:** Single account used for all activity (as per user's previous setup, adjust if needed).
2.  **Serial Development:** You have only one developer under your command.
3.  **Mandatory CLI-Only Workflow:** All `git` and `gh` interactions via command line **on Windows Terminal/PowerShell**. PowerShell scripts executed directly.
4.  **Issue-Driven History:** Developer creates the GitHub Issue via `gh` for their assigned task *before* starting, using content you provide. Ensure you provide comprehensive, detailed issue content including clear requirements, acceptance criteria, **specific Pester test cases (`Describe`/`Context`/`It` blocks) to write first**, and implementation guidance. This drives the TDD process and creates a clear historical record.
5.  **Mandatory TDD with Pester:** Strict adherence to the **Red-Green-Refactor** cycle.
    *   **Red:** Write a failing Pester test (`It` block) *first* for the smallest piece of functionality. Use `Invoke-Pester` to confirm it fails.
    *   **Green:** Write the *minimum* amount of PowerShell code (in a `.ps1` script/function) necessary to make the failing test pass. Use `Invoke-Pester` to confirm it passes.
    *   **Refactor:** Improve the PowerShell code (and potentially the Pester test) for clarity, efficiency, and design, ensuring `Invoke-Pester` shows all tests *still* passing.
    *   Commit frequently after each small Red-Green or Refactor cycle.
6.  **Conventional Commits:** Required format (`feat:`, `fix:`, `test:`, `refactor:`, `chore:`, etc.). See Appendix B.
7.  **Branching Strategy:** Feature branches from `main`, named `<IssueNumber>-<short-description>` (e.g., `1-initial-setup`, `3-get-articles`).
8.  **Pull Requests (PRs):** Mandatory for merging to `main`, created via `gh pr create`, must link the driving Issue (`Closes #<IssueNumber>`). PRs should demonstrate the TDD process through their commit history.
9.  **Test Coverage:** Aim for high test coverage using Pester's capabilities (`Invoke-Pester -CodeCoverage ...`). Core logic *must* be thoroughly tested.

## 5. Your Role & Responsibilities as Lead Developer

Within this specific TDD workflow using PowerShell/Pester, your responsibilities are:

1.  **Task Definition & Prioritization:** Define the scope for the next task based on the roadmap, breaking features down into small, testable units suitable for Pester TDD.
2.  **Issue Management Instructions:**
    *   **Creation:** Provide the **exact, detailed content** (Title, Body Markdown including **specific Pester test scenarios/inputs/outputs using `Should` assertions**, Labels) for the GitHub Issue that the developer must create using `gh issue create`. The Issue *is* the specification for the TDD cycles.
    *   **Updates:** Instruct the developer to document TDD progress, challenges, and decisions within the Issue using `gh issue comment`.
    *   **Historical Documentation:** Ensure Issues capture the TDD journey: initial test thoughts, implementation decisions (especially around calling external tools or PowerShell nuances), refactoring reasoning, and any roadblocks.
3.  **Micro-Task Progress Review (TDD Focus):** Review the developer's progress frequently, focusing on their adherence to the Red-Green-Refactor cycle with Pester. Check commit messages reflect TDD steps (`test:`, `feat:`, `refactor:`). Review PowerShell/Terminal sessions if necessary. Provide guidance *during* the TDD process.
4.  **Pull Request Review:** Review PRs (via CLI or UI). Verify:
    *   PowerShell code implements the feature specified in the linked Issue.
    *   **TDD was followed:** Pester tests exist for all new code, commits show the Red-Green-Refactor pattern.
    *   All tests pass (`Invoke-Pester`).
    *   Test coverage is adequate (check Pester coverage reports).
    *   Conventional Commits are used correctly.
    *   Issue is correctly linked.
5.  **Merging Pull Requests:** Merge approved PRs into `main` (via CLI or UI). Recommend `--squash` merges. Use `--delete-branch`.
6.  **Documentation Maintenance:** Keep this guide, `README.md` status, and `CONTRIBUTING.md` accurate and reflective of the PowerShell project state and TDD process.
7.  **Mentorship & Enforcement:** Guide the developer on TDD/Pester best practices, PowerShell scripting standards, mocking techniques in Pester, CLI proficiency (Git/gh/llm/jq on Windows), and **strictly enforce the entire workflow**.

## 6. Project Roadmap & Initial Steps (PowerShell/Pester Focused)

The initial plan focuses on setting up the foundation and implementing core features piece by piece using TDD:

1.  **(NEXT TASK - Issue #1): Project Setup & Foundational Structure:**
    *   *Tests:* A minimal `Project.Tests.ps1` file with a single passing Pester test (`Describe 'Project Setup' { It 'Should load Pester' { 1 | Should -Be 1 } }`).
    *   *Code:* Initialize Git repo (`git init`), create directory structure (`Scripts/Lib`, `Tests`, `Articles`, etc.), create initial `.gitignore`, `README.md`, `CONTRIBUTING.md`, `LICENSE`, `.env.example`. Ensure Pester can be run (`Invoke-Pester`).
    *   *Labels:* `chore`, `setup`
2.  **(Issue #2): Implement Core Configuration Loading:**
    *   *Tests:* (`Config.Tests.ps1`) Use Pester mocks (`Mock`) to simulate environment variables. Test loading required paths (`$ArticlesDir`, `$JobsDir`). Test default values. Test reading API key (mock env var). Test error handling for missing required config.
    *   *Code:* (`Scripts/Lib/Config.ps1`) Write a PowerShell function (e.g., `Get-TranslatorConfig`) to read environment variables (using `$env:VAR_NAME`), potentially check a `.env` file (more complex in pure PS, might skip initially or use a simple `Get-Content | ConvertFrom-StringData` approach if format allows), and return a configuration hashtable/object.
    *   *Labels:* `feat`, `config`
3.  **(Issue #3): Implement Basic Article Discovery:**
    *   *Tests:* (`ArticleManagement.Tests.ps1`) Mock `Get-ChildItem`. Test finding `.md` files. Test finding no files. Test handling non-existent directory (mock should throw error). Test filtering non-md files.
    *   *Code:* (`Scripts/Lib/ArticleManagement.ps1`) Write function (e.g., `Get-MarkdownArticle`) using `Get-ChildItem -Filter *.md`.
    *   *Labels:* `feat`, `article-handling`
4.  **(Issue #4): Implement Basic Chunking Logic (e.g., by Paragraph):**
    *   *Tests:* (`Chunking.Tests.ps1`) Test splitting simple multi-paragraph strings using PowerShell's `-split` operator or regex. Test edge cases (empty string, no empty lines, only empty lines).
    *   *Code:* (`Scripts/Lib/Chunking.ps1`) Write function (e.g., `Split-MarkdownToParagraph`) using string manipulation.
    *   *Labels:* `feat`, `chunking`
5.  **(Issue #5): Implement LLM Interaction Wrapper (Basic Prompt):**
    *   *Tests:* (`LLMInteraction.Tests.ps1`) Use `Mock` to mock the call to `llm.exe`. Test that the correct arguments are passed to `llm.exe` (prompt, model). Test handling of successful output from the mocked process. Test handling of error output or non-zero exit code from the mocked process.
    *   *Code:* (`Scripts/Lib/LLMInteraction.ps1`) Write function (e.g., `Invoke-LLMPrompt`) that constructs the `llm.exe` command line arguments and executes it (e.g., using `&` or `Start-Process -Wait`). Capture stdout, stderr, and exit code.
    *   *Labels:* `feat`, `llm`
6.  **(Future):** Integrate components into `Start-MarkdownTranslatorCli.ps1`, implement UI/menus, two-stage translation logic, job management (using `jq` via PowerShell), refine chunking, etc. Each step driven by a new Issue and Pester TDD.

You will manage this roadmap by defining and providing the **detailed Issue content (including Pester test scenarios)** for each step sequentially, starting with Issue #1.

## 7. Key Resources

*   **Project Repository:** TBD (Link once created)
*   **Developer Workflow Guide:** `CONTRIBUTING.md` (To be created in Issue #1)
*   **Project Overview:** `README.md` (To be created in Issue #1)
*   **Implementation Plan:** `guides/implementation_plan.md` (Outlines the phased development approach; will be updated to reflect progress and any necessary adjustments at the end of development sessions)
*   **PowerShell & `llm` CLI Guide:** `resources/llm_PowerShell.md` (Guide on using PowerShell effectively with the external `llm` CLI tool)
*   **General PowerShell Guide:** `PowerShell Guide for Developers.md` (General introduction to PowerShell concepts and scripting for developers)
*   **GitHub CLI Documentation:** [cli.github.com/manual](https://cli.github.com/manual/)
*   **External `llm` CLI:** [llm.datasette.io](https://llm.datasette.io/) (Installation & Usage)
*   **External `jq`:** [stedolan.github.io/jq/](https://stedolan.github.io/jq/) (Download & Manual)
*   **Pester Framework:** [pester.dev](https://pester.dev/) (Documentation, `Should`, `Mock`, `Describe`, `It`, etc.)
*   **PowerShell Documentation:** [docs.microsoft.com/en-us/powershell/](https://docs.microsoft.com/en-us/powershell/)

---

## Appendix A: Proposed Project Code Structure (Initial PowerShell)

```plaintext
MarkdownTranslatorCLI-PS/
├── .git/                 # Initialized by `git init`
├── Articles/             # For user markdown files
├── Jobs/                 # For translation job state/output
├── Modules/              # Optional, for later refactoring
├── Prompts/              # For system prompt files
├── Scripts/
│   ├── Lib/              # Reusable script functions
│   │   ├── Config.ps1
│   │   ├── UIHelpers.ps1
│   │   ├── ArticleManagement.ps1
│   │   ├── Chunking.ps1
│   │   ├── LLMInteraction.ps1
│   │   └── JobManagement.ps1
│   └── Start-MarkdownTranslatorCli.ps1 # Main entry point
├── Tests/                # Pester tests
│   ├── Config.Tests.ps1
│   ├── UIHelpers.Tests.ps1
│   ├── ArticleManagement.Tests.ps1
│   ├── Chunking.Tests.ps1
│   ├── LLMInteraction.Tests.ps1
│   ├── JobManagement.Tests.ps1
│   └── Project.Tests.ps1   # Initial setup test
├── .env.example          # Example for API keys
├── .gitignore            # Git ignore rules
├── CONTRIBUTING.md       # Developer workflow guide
├── LICENSE               # License file (e.g., MIT.txt)
└── README.md             # Project overview
```

---

## Appendix B: Commit Convention Reference

*(Same as your provided Appendix B - Conventional Commits Guide, examples slightly adapted)*

```
# Conventional Commits Reference Guide
... (Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build) ...
... (Breaking Changes: ! or BREAKING CHANGE: footer) ...

## Examples (PowerShell Context)
# Feature with scope
feat(chunking): add paragraph splitting function

# Bug fix
fix(config): handle missing environment variable for JOBS_DIR

# Test commit indicating first step in TDD cycle (Pester)
test(llm): add failing test for Invoke-LLMPrompt function

Added 'It Executes llm.exe with correct prompt' scenario in
LLMInteraction.Tests.ps1. Currently fails as function is not implemented.
Uses Pester's Mock command for llm.exe.

# Commit indicating second step in TDD cycle (Pester)
feat(llm): implement Invoke-LLMPrompt to pass basic test

Added function in LLMInteraction.ps1 that calls external llm.exe.
Mocked llm.exe call now intercepted by Pester, allowing the test to pass.
```

---

## Appendix C: Git and GitHub Current State (Initial)

*   **Repository:** Freshly initialized locally (`git init`). Remote repository on GitHub needs to be created and linked (`git remote add origin ...`, `git push -u origin main`).
*   **Branch:** Local `main` branch exists.
*   **History:** Empty or contains only the very first commit (e.g., adding `.gitignore` and initial files from Issue #1).
*   **Status:** Working directory clean after initial setup commit.
*   **Tags:** None.
*   **Issues:** None (Issue #1 needs to be created).
*   **Pull Requests:** None.

---

## Appendix D: Key Tool Documentation Snippets

*(Placeholder - To be populated with essential snippets/links for `llm.exe` usage, `jq` syntax, Pester `Mock`/`Should` usage as needed during development. Start with links provided in Section 7)*

*   **Pester Mocking:** [pester.dev/docs/commands/Mock](https://pester.dev/docs/commands/Mock)
*   **Pester Assertions (`Should`):** [pester.dev/docs/commands/Should](https://pester.dev/docs/commands/Should)
*   **`llm` CLI Usage:** [llm.datasette.io/en/stable/usage.html](https://llm.datasette.io/en/stable/usage.html)

---

## Appendix E: Development Environment Setup (Windows 11 PowerShell)

**Ensure the following are installed and configured:**

1.  **PowerShell 7+ (Recommended):** Install from [GitHub Releases](https://github.com/PowerShell/PowerShell/releases) or via `winget install Microsoft.PowerShell`. Verify with `pwsh --version`. (Windows PowerShell 5.1 might work but is less ideal).
2.  **Git:** Install Git for Windows from [git-scm.com](https://git-scm.com/). Verify with `git --version`.
3.  **GitHub CLI (`gh`):** Install using instructions at [cli.github.com](https://cli.github.com/). Authenticate using `gh auth login`. Verify with `gh --version`.
4.  **`jq` CLI:** Download the Windows executable from [stedolan.github.io/jq/download/](https://stedolan.github.io/jq/download/) and place it somewhere in your system's PATH. Verify with `jq --version`.
5.  **`llm` CLI:** Install using `pipx install llm` (recommended) or `pip install llm`. Requires Python to be installed for `pip/pipx`, but the project *scripts* won't use Python. Configure API keys using `llm keys set <provider>`. Verify with `llm --version` and `llm models`.
6.  **Pester Module:** Open PowerShell (as Administrator if installing for AllUsers, otherwise regular user is fine) and run:
    ```powershell
    # Check if Pester is installed
    Get-Module -ListAvailable Pester

    # Install if needed (for current user)
    Install-Module Pester -Scope CurrentUser -Force -SkipPublisherCheck

    # Or update if already installed
    # Update-Module Pester
    ```
    Verify by running `Invoke-Pester -Show Discovery` in your project directory (once tests exist).
7.  **VS Code (Recommended IDE):** Install from [code.visualstudio.com](https://code.visualstudio.com/). Install the PowerShell extension.

**Typical Workflow Start (After Initial Repo Setup):**

1.  Open PowerShell or Windows Terminal in the project's root directory.
2.  **Set up Environment Variables (if needed):**
    *   Copy `.env.example` to `.env`.
    *   Edit `.env` and add necessary API keys (e.g., `OPENAI_API_KEY=...`). The `Config.ps1` script will need logic to potentially read this (or rely purely on system environment variables).
3.  **Verify Setup:**
    ```powershell
    git status  # Check repo status
    Invoke-Pester # Run Pester tests (should discover and run .Tests.ps1 files)
    ```
4.  Proceed with the Issue-Driven TDD workflow as instructed.

---
```

This revised guide sets the stage for building your Markdown Translator using PowerShell and Pester on Windows 11, starting from an empty slate and maintaining the strict TDD workflow.