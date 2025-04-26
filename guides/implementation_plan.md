**Project Implementation Plan: Markdown Translator CLI (PowerShell)**

**Prepared For:** Project Lead Developer
**Date:** 2025-04-25 (Placeholder)
**Version:** 1.0

**1. Introduction**

This document outlines the proposed implementation plan for the Markdown Translator CLI project. The goal is to build a PowerShell-based command-line tool for translating Markdown files using external LLM tools, adhering strictly to Test-Driven Development (TDD) principles with the Pester framework. This plan breaks down the project into logical phases and tasks, each corresponding to a planned GitHub Issue.

**2. Project Goal Recap**

To create a robust, testable PowerShell CLI application for translating Markdown files via the `llm` CLI, featuring chunking, model selection, prompt usage, and job management capabilities.

**3. Core Methodology**

*   **Language:** PowerShell 7+
*   **Testing:** Pester (TDD: Red-Green-Refactor)
*   **Version Control:** Git, GitHub
*   **Workflow:** Issue-Driven Development via GitHub CLI (`gh`), Conventional Commits, Mandatory PRs for merges to `main`.
*   **External Tools:** `llm`, `jq`, `git`, `gh`.

**4. Assumptions**

*   The development environment (Windows 11) is set up as per the Project Lead Guide (PowerShell 7+, Git, gh, llm, jq installed and configured).
*   Pester module is installed and functional.
*   Developer has necessary permissions on the shared GitHub account/repository.
*   The Lead Developer will provide detailed Issue content (including specific test scenarios) before the developer starts each task.

**5. Phased Implementation Plan**

*(Note: Issue numbers are sequential placeholders)*

**Phase 1: Foundation & Setup (Issues #1-2)**

*   **Goal:** Establish the repository structure, core tooling, configuration handling, and basic testing setup.
*   **Issue #1: Project Setup & Foundational Structure**
    *   **TDD Focus:** Create a minimal Pester test (`Project.Tests.ps1`) to ensure the test runner works.
    *   **Tasks:**
        *   Initialize local Git repository.
        *   Create remote GitHub repository via `gh repo create`.
        *   Create initial directory structure (`Scripts/Lib`, `Tests`, `Articles`, etc.).
        *   Create initial `.gitignore`, `README.md`, `CONTRIBUTING.md`, `LICENSE`.
        *   Create `.env.example`.
        *   Commit and push initial structure to `main`.
    *   **Review:** Lead reviews repository setup, file structure, and basic Pester execution.
*   **Issue #2: Implement Core Configuration Loading**
    *   **TDD Focus:** (`Config.Tests.ps1`) Write failing tests (using Pester `Mock` for environment variables) for loading essential paths (Articles, Jobs, Prompts), handling defaults, reading an API key (mocked), and erroring on missing required configs.
    *   **Tasks:**
        *   Implement `Get-TranslatorConfig` function in `Scripts/Lib/Config.ps1`.
        *   Implement logic to read from environment variables (`$env:`).
        *   (Optional Stretch) Add simple logic to read a key=value `.env` file if needed.
        *   Ensure function returns a consistent object/hashtable.
        *   Refactor based on passing tests.
    *   **Review:** Lead reviews TDD cycle (commits), Pester tests, mocking strategy, and PowerShell implementation for config loading.

**Phase 2: Core Article & Chunking Logic (Issues #3-5)**

*   **Goal:** Implement the ability to find, read, and split Markdown articles into manageable units.
*   **Issue #3: Implement Basic Article Discovery**
    *   **TDD Focus:** (`ArticleManagement.Tests.ps1`) Write failing tests mocking `Get-ChildItem` to verify finding `.md` files, handling empty/non-existent directories, and filtering.
    *   **Tasks:**
        *   Implement `Get-MarkdownArticle` function in `Scripts/Lib/ArticleManagement.ps1` using `Get-ChildItem`.
        *   Refactor for clarity.
    *   **Review:** Lead reviews TDD cycle, tests, and file discovery logic.
*   **Issue #4: Implement Basic Article Reading**
    *   **TDD Focus:** (`ArticleManagement.Tests.ps1`) Write failing tests mocking `Get-Content` to verify reading file content, handling encoding (assume UTF-8 initially), and errors for non-existent files.
    *   **Tasks:**
        *   Implement `Read-MarkdownArticle` function in `Scripts/Lib/ArticleManagement.ps1` using `Get-Content`.
        *   Refactor.
    *   **Review:** Lead reviews TDD cycle, tests, and file reading logic.
*   **Issue #5: Implement Basic Chunking Logic (Paragraph Split)**
    *   **TDD Focus:** (`Chunking.Tests.ps1`) Write failing tests for splitting multi-paragraph strings based on blank lines (using `-split` or regex). Test edge cases (empty string, no blank lines, multiple blank lines).
    *   **Tasks:**
        *   Implement `Split-MarkdownToParagraph` function in `Scripts/Lib/Chunking.ps1`.
        *   Refactor string splitting logic.
    *   **Review:** Lead reviews TDD cycle, tests (especially edge cases), and chunking implementation.

**Phase 3: LLM Interaction & Basic Translation (Issues #6-7)**

*   **Goal:** Establish the ability to send text to the `llm` tool and get a response back.
*   **Issue #6: Implement LLM Interaction Wrapper**
    *   **TDD Focus:** (`LLMInteraction.Tests.ps1`) Write failing tests using Pester `Mock` for `llm.exe`. Test passing correct arguments (prompt, model). Test handling stdout, stderr, and exit codes from the mocked process.
    *   **Tasks:**
        *   Implement `Invoke-LLMPrompt` function in `Scripts/Lib/LLMInteraction.ps1` to execute `llm.exe` externally.
        *   Handle process execution and output capture.
        *   Refactor process calling logic.
    *   **Review:** Lead reviews TDD cycle, comprehensive mocking of the external process, argument handling, and error condition checks.
*   **Issue #7: Implement Basic Single-Chunk Translation Flow**
    *   **TDD Focus:** (`TranslationFlow.Tests.ps1` - new file or integrated) Write failing integration-style tests (mocking file read, chunking, and LLM calls) for translating a single, simple chunk of text.
    *   **Tasks:**
        *   Create a simple function/script section (maybe in `Start-MarkdownTranslatorCli.ps1` initially) that orchestrates:
            *   Reading a (mocked) simple article string.
            *   Splitting it into one (mocked) chunk.
            *   Calling `Invoke-LLMPrompt` (mocked) with the chunk.
            *   Returning the (mocked) result.
    *   **Review:** Lead reviews the basic orchestration logic and how mocks are used to test the flow without actual file I/O or LLM calls.

**Phase 4: CLI Structure & User Interaction (Issues #8-TBD)**

*   **Goal:** Build the main CLI entry point and basic user interaction menus.
*   **Issue #8: Implement Main CLI Entry Point & Basic Menu**
    *   **TDD Focus:** (`Cli.Tests.ps1`) Write tests for parsing basic command-line arguments (if any initially). Mock helper functions (`Get-MarkdownArticle`, `Show-MainMenu`) and test that the main script calls them appropriately. Test basic menu display and input handling (mock `Read-Host`).
    *   **Tasks:**
        *   Structure `Start-MarkdownTranslatorCli.ps1` as the main entry point.
        *   Implement a basic `Show-MainMenu` function in `Scripts/Lib/UIHelpers.ps1` (with TDD).
        *   Implement simple menu loop logic in the main script.
    *   **Review:** Lead reviews CLI structure, argument parsing (if applicable), menu logic, and testability of the UI components (via mocking).
*   **Further Issues in Phase 4:**
    *   Implement Article Selection Menu (calling `Get-MarkdownArticle`).
    *   Implement Model Selection (potentially hardcoded list initially, later using `llm models`).
    *   Implement Prompt Selection (listing files from `Prompts/`).
    *   Integrate selections into the main state/variables.

**Phase 5: Full Translation Workflow & Chunk Handling (Issues TBD)**

*   **Goal:** Integrate all components for a multi-chunk translation process.
*   **Tasks (Driven by TDD Issues):**
    *   Implement loop in main script/function to process all chunks from `Split-MarkdownToParagraph`.
    *   Call `Invoke-LLMPrompt` for each chunk.
    *   Implement logic to assemble results (simple concatenation initially).
    *   Add basic progress indication (e.g., "Translating chunk X of Y...").
    *   Implement saving the final assembled translation to a file.
    *   Refine chunking logic (character limits, overlap - more complex TDD needed).
    *   Implement two-stage translation (fast pass, then refinement pass with prompt).

**Phase 6: Job Management & Resumption (Issues TBD)**

*   **Goal:** Add persistence for translation jobs, allowing status tracking and resumption.
*   **Tasks (Driven by TDD Issues):**
    *   Implement Job Directory Creation (`Scripts/Lib/JobManagement.ps1`).
    *   Implement Metadata Handling (using `jq.exe` via PowerShell, requires careful mocking/testing). Write/Read `metadata.json`.
    *   Implement saving intermediate chunk results to job directories.
    *   Implement logic to check job status and identify resumable chunks.
    *   Implement `Resume-TranslationJob` functionality.
    *   Implement `Show-JobArchive` menu/listing.

**Phase 7: Enhancements & Refinement (Issues TBD)**

*   **Goal:** Improve usability, error handling, and robustness.
*   **Tasks (Driven by TDD Issues):**
    *   Implement advanced error handling and logging.
    *   Improve UI (potentially using modules like `Terminal.Gui` for PowerShell if desired, or just better text formatting).
    *   Add more sophisticated chunking strategies.
    *   Implement retry logic for LLM calls (`run_with_retry` equivalent in PowerShell).
    *   Refactor into PowerShell Modules (`.psm1`) for better organization.

**6. Timeline**

This is a sequential plan. Progress depends on the developer's speed and complexity encountered. Each Issue represents a distinct unit of work. The focus is on completing each phase with tested, working code before moving to the next major dependency. A rough goal might be:

*   Phase 1: 1-2 days
*   Phase 2: 2-3 days
*   Phase 3: 2-3 days
*   Subsequent phases depend heavily on complexity discovered.

**7. Review Process**

*   **Issue Definition:** Lead provides detailed Issue content -> Developer Creates Issue.
*   **TDD Cycle:** Developer commits frequently (`test:`, `feat:`, `refactor:`) -> Lead provides feedback on approach/progress via Issue comments or brief syncs.
*   **Pull Request:** Developer creates PR linking Issue -> Lead performs detailed code/test/workflow review -> Merge on approval.

**8. Potential Risks & Challenges**

*   **External Tool Changes:** `llm` CLI or `jq` changes could break interactions. Requires robust mocking and testing of the wrappers.
*   **PowerShell Complexity:** Advanced PowerShell scripting (complex mocking, robust error handling, module creation) can be challenging.
*   **Pester Mocking:** Mocking external processes (`llm.exe`, `jq.exe`) effectively in Pester requires careful setup.
*   **LLM API Issues:** Rate limits, API errors, inconsistent output from LLMs. Requires error handling and potentially retry logic.
*   **Chunking Complexity:** Getting chunking (especially with overlap and context preservation) correct is non-trivial.
*   **Performance:** PowerShell script performance for very large files or many chunks might become a concern.

---

Please review this plan for feasibility, logical flow, TDD integration, and alignment with the project goals and constraints. Provide feedback on phasing, task breakdown, potential omissions, or areas requiring further detail.


---
