**Project Implementation Plan: Markdown Translator CLI (PowerShell) - v1.4**

**Prepared For:** Project Lead Developer
**Date:** 2025-04-26 (Placeholder - Updated)
**Version:** 1.4 (Reflects completion of Issue #3)

**1. Introduction**

This document outlines the proposed implementation plan for the Markdown Translator CLI project. The goal is to build a PowerShell-based command-line tool for translating Markdown files using external LLM tools, adhering strictly to Test-Driven Development (TDD) principles with Pester. This plan breaks down the project into logical phases and tasks, incorporating stages for Real-World User Experience (UX) Testing. **Phase 1 and Issue #3 of Phase 2 are complete.**

**2. Project Goal Recap**

To create a robust, testable, and user-friendly PowerShell CLI application for translating Markdown files via the `llm` CLI, featuring chunking, model selection, prompt usage, and job management capabilities.

**3. Core Methodology**

*   **Language:** PowerShell 7+
*   **Testing:** Pester (TDD), Manual UX Testing
*   **Version Control:** Git, GitHub
*   **Workflow:** Issue-Driven Development via `gh`, Conventional Commits, PRs.
*   **External Tools:** `llm`, `jq`, `git`, `gh`.

**4. Assumptions**

*   Development environment is set up.
*   Pester is functional.
*   Permissions available.
*   Lead Developer provides detailed Issue content.
*   Developer has access to configured `llm` CLI for UX testing phases.

**5. Phased Implementation Plan**

*(Note: Issue numbers are sequential placeholders. UX Testing tasks are added.)*

**Phase 1: Foundation & Setup (Issues #1-2) - ✅ COMPLETED**

*   **Goal:** Establish repository, tooling, configuration, basic testing setup.
*   **Issue #1: Project Setup & Foundational Structure** - ✅ **Done**
*   **Issue #2: Implement Core Configuration Loading** - ✅ **Done**

**Phase 2: Core Article & Chunking Logic (Issues #3-5) - 🟡 IN PROGRESS**

*   **Goal:** Implement the ability to find, read, and split Markdown articles.
*   **Issue #3: Implement Basic Article Discovery** - ✅ **Done**
    *   **Status:** `Get-MarkdownArticle` function implemented and tested (using mock for `Get-ChildItem` due to Pester context issues). Missing test scenarios for empty/non-existent dirs noted for follow-up.
*   **Issue #4: Implement Basic Article Reading** - ▶️ **Next Task**
    *   **Overall Fit:** Allows the application to load the content of a specific Markdown file into memory.
    *   **TDD Focus:**
        *   **Part 1:** Add missing tests to `Tests\ArticleManagement.Tests.ps1` for `Get-MarkdownArticle` (empty dir, no `.md` files, non-existent dir), ensuring they pass with the existing mock strategy.
        *   **Part 2:** Write failing tests in `Tests\ArticleManagement.Tests.ps1` (new `Describe` block) mocking `Get-Content` for `Read-MarkdownArticle` function (success case, non-existent file case).
    *   **Tasks:**
        *   Add missing tests for `Get-MarkdownArticle`.
        *   Implement `Read-MarkdownArticle` function in `Scripts\Lib\ArticleManagement.ps1` using `Test-Path` and `Get-Content -Raw`. Handle errors gracefully (return null/empty + warning).
        *   Add `Export-ModuleMember` for the new function.
    *   **Review:** Lead reviews TDD cycle for both parts, test coverage (including added tests), error handling, function implementation.
*   **Issue #5: Implement Basic Chunking Logic (Paragraph Split)**
    *   **Overall Fit:** Provides the core mechanism for breaking down article content into smaller pieces.
    *   **TDD Focus:** (`Chunking.Tests.ps1` - new file) Write failing tests for splitting multi-paragraph strings based on blank lines (using `-split` or regex). Test edge cases (empty string, no blank lines, multiple blank lines, whitespace only).
    *   **Tasks:** Implement `Split-MarkdownToParagraph` function (`Scripts/Lib/Chunking.ps1`). Handle different line endings, trim whitespace, filter empty results. Return array of paragraph strings.
    *   **Review:** TDD, edge case test coverage, splitting logic robustness.

**Phase 3: LLM Interaction & Basic Translation (Issues #6-7)**

*   **Goal:** Connect to `llm.exe` and establish a basic translation pathway.
*   **Issue #6: Implement LLM Interaction Wrapper**
    *   *(Details as before - Implement `Invoke-LLMPrompt`, mock `llm.exe`)*
*   **Issue #7: Implement Basic Single-Chunk Translation Flow**
    *   *(Details as before - Test orchestration logic using mocks)*

**Phase 4: CLI Structure & Initial User Interaction (Issues #8-~11)**

*   **Goal:** Build the main CLI entry point and basic user interaction menus.
*   **Issue #8: Implement Main CLI Entry Point & Basic Menu**
    *   *(Details as before - Structure `Start-MarkdownTranslatorCli.ps1`, basic `Show-MainMenu`, menu loop)*
*   **Issue #9 (Example): Implement Article Selection Menu**
    *   *(Details as before - Use `Get-MarkdownArticle`, mock `Read-Host`)*
*   **Issue #10 (Example): Implement Model Selection Menu (Basic)**
    *   *(Details as before - Hardcoded list initially)*
*   **Issue #11 (Example): Implement Prompt Selection Menu (Basic)**
    *   *(Details as before - List files from `Prompts/`)*

**Phase 5: First End-to-End Workflow & UX Test (Issues #12-13)**

*   **Goal:** Achieve basic end-to-end translation of a single chunk and perform initial usability testing.
*   **Issue #12: Integrate Basic End-to-End Translation (First Chunk)**
    *   *(Details as before - Connect selections to backend logic, display result)*
*   **Issue #13: Initial Real-World UX Test (Single Chunk)**
    *   *(Details as before - Manual testing, evaluate menus, basic translation, error handling)*

**Phase 6: Full Translation Workflow & Chunk Handling (Issues #14-TBD)**

*   **Goal:** Implement the complete multi-chunk translation process and saving.
*   **Issue #14 (Example): Implement Multi-Chunk Processing Loop & Assembly**
*   **Issue #15 (Example): Implement Saving Final Translation**
*   **Issue #16 (Example): Refine Chunking (Size/Overlap)**

**Phase 7: Second End-to-End Workflow & UX Test (Issue #17)**

*   **Goal:** Test the complete multi-chunk workflow with real files.
*   **Issue #17: Full Workflow Real-World UX Test**
    *   *(Details as before - Manual testing, evaluate chunking, performance, output quality, error handling)*

**Phase 8: Job Management & Resumption (Issues #18-TBD)**

*   **Goal:** Add persistence and resumption capabilities using `jq`.
*   **Tasks:** Implement Job Directory creation, Metadata Handling (mocking `jq.exe`), saving intermediate results, status checking, resumption logic.

**Phase 9: Job Management UX Test (Issue #X)**

*   **Goal:** Test the job management features from a user perspective.
*   **Issue #X: Job Management Real-World UX Test**
    *   *(Details as before - Manual testing of start, interrupt, resume, view, delete)*

**Phase 10: Enhancements & Refinement (Issues TBD)**

*   **Goal:** Improve usability, error handling, robustness based on prior phases and UX feedback.
*   **Tasks:** Advanced error handling, UI improvements, retry logic, refactoring into Modules.

**6. Timeline**

*   **Phase 1:** Completed.
*   **Phase 2:** In Progress (Issue #4 next). Estimated 1-2 days remaining.
*   **Phase 3:** Estimated 2-3 days.
*   Subsequent phases TBD, adjusted for UX feedback.

**7. Review Process**

*   Includes review of documented UX testing feedback in addition to PR reviews.

**8. Potential Risks & Challenges**

*   Risks remain the same, particularly around external tool integration (`llm`, `jq`) and Pester mocking complexity. UX testing may introduce scope changes.

---
