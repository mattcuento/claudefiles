# Claude Configuration

This file contains preferences and guidelines for how Claude should work with me.

## Communication Style

**Preference: Detailed Explanations**

- Provide thorough explanations of decisions and approaches
- Explain the reasoning behind code choices
- Describe what you're doing and why before doing it
- Walk through your thought process for complex problems
- When you find issues or patterns, explain what you discovered
- After making changes, explain what was changed and why

**Progress updates:**
- For multi-step tasks, use todo lists to track progress
- Update task status as you work (pending → in_progress → completed)
- Explain what you're doing at each major step

**Asking questions:**
- Ask clarifying questions before starting ambiguous work
- Don't make assumptions about requirements
- If there are multiple valid approaches, present options with trade-offs

**Explaining decisions:**
- When choosing between alternatives, explain your reasoning
- Cite existing patterns in the codebase as justification
- If you deviate from preferences, explain why

## Approval & Planning

**Preference: Use Plan Mode Often**

- Enter plan mode for non-trivial implementation tasks
- Present a plan before making significant changes
- Allow me to review and approve the approach before proceeding
- Use plan mode when:
  - Adding new features
  - Refactoring existing code
  - Making architectural decisions
  - Changes that affect multiple files
  - Anything beyond simple bug fixes

## Coding Style

**Preference: Minimal/Clean Code**

- **Simplicity first**: Prefer simple, straightforward solutions
- **Avoid over-engineering**: Don't add features or abstractions that weren't requested
- **No premature optimization**: Only optimize when there's a clear need
- **Minimal abstractions**: Three similar lines of code is better than a premature abstraction
- **No unnecessary comments**: Code should be self-documenting; only add comments where logic isn't self-evident
- **No extra features**: Stick to exactly what was requested
- **Delete unused code**: Remove it completely rather than commenting it out or using compatibility hacks
- **Trust internal code**: Don't add defensive checks for scenarios that can't happen
- **Keep it focused**: A bug fix should just fix the bug, not refactor surrounding code

### What NOT to Add Unless Requested
- Extra error handling for impossible scenarios
- Feature flags or configuration options
- Helper functions for one-time operations
- Type annotations to unchanged code
- Docstrings or comments to existing code
- Validation for internal/trusted code

## Design Principles

**Requirement: SOLID Principles**

Apply SOLID principles consistently across all code:

- **Single Responsibility**: Each class/module should have one reason to change. When designing features, identify clear boundaries and responsibilities.
- **Open/Closed**: Extend behavior through interfaces/traits rather than modifying existing code. Consider extension points during architecture.
- **Liskov Substitution**: Subtypes must be substitutable for their base types. Ensure polymorphic code works with all implementations.
- **Interface Segregation**: Create focused interfaces rather than large, monolithic ones. Split interfaces when clients need different subsets.
- **Dependency Inversion**: Depend on abstractions, not concretions. Use dependency injection and define clear interfaces.

**Balance with Minimal Code Philosophy**: Apply SOLID where it adds clear value. Don't create abstractions prematurely - wait until you have 2-3 concrete use cases. SOLID guides structure; minimalism guides when to add that structure.

**Inline Architecture Guidance**: During planning, provide concise explanations of architectural decisions inline (2-3 sentences). Explain trade-offs, why a particular pattern fits, and how it aligns with SOLID. No separate design documents.

## Development Methodology

**Preference: Test-Driven Development (Default)**

- **By default, use TDD**: Write tests first, then implement to make them pass
- **When writing tests first**:
  - New features and functionality
  - Refactoring existing code
  - Bug fixes where test coverage helps prevent regression
  - Complex business logic that benefits from examples
  - API or interface design (tests document usage)

**When to be flexible with TDD**:
- **Quick bug fixes**: If the bug is trivial and a test would take longer than the fix
- **Prototyping**: When exploring ideas or proof-of-concepts before committing to design
- **Emergency fixes**: Production issues where speed matters most
- **Spike work**: Investigating feasibility or technical approaches
- **Scripts/tooling**: One-off scripts or simple automation that don't need formal testing

**Testing approach**:
- Write clear, focused tests that document intent
- Test behavior, not implementation details
- Use descriptive test names that explain the scenario
- Prefer integration tests for end-to-end workflows, unit tests for complex logic
- Don't test framework code or trivial getters/setters

**When skipping TDD**: Briefly explain why (e.g., "This is a trivial bug fix, writing test first would be overkill" or "Prototyping approach before committing to design").

## Tool Preferences

### Post-Task Verification

**Always run at the end of every task:**

1. **Linting** (if linter is configured for the language)
2. **Unit Tests** (at minimum - run the test suite)

**Per-Language Linting & Testing:**

**Rust:**
```bash
cargo clippy -- -D warnings  # Lint (fail on warnings)
cargo test                    # Run all tests
```

**Node.js/TypeScript:**
```bash
pnpm lint                     # Or npm/yarn lint (check package.json)
pnpm test                     # Run test suite
```

**Python:**
```bash
ruff check .                  # Or flake8, pylint (check project config)
pytest                        # Or python -m pytest
```

**Java:**
```bash
mvn checkstyle:check         # Or ./gradlew checkstyle
mvn test                     # Or ./gradlew test
```

**Go:**
```bash
golangci-lint run            # If available, otherwise go vet
go test ./...
```

**What to do if they fail:**

- **Linting failures**: Fix the issues before marking the task complete
- **Test failures**:
  - Investigate and fix the broken tests
  - If tests were passing before your changes, you introduced a regression
  - Don't mark the task complete until tests pass
- **If unsure**: Explain the failure and ask before proceeding

**Exceptions:**
- Skip if explicitly working on a broken/WIP branch
- Skip if user says "don't run tests" or "quick prototype"
- For exploration/research tasks (no code changes), verification not needed

### Language-Specific Tools

**Rust Projects**
- Package management: `cargo` for all dependency operations
- Building: `cargo build` / `cargo build --release`
- Testing: `cargo test` (or `cargo nextest` if nextest is configured)
- Formatting: `cargo fmt` (auto-approved)
- Linting: `cargo clippy`
- Documentation: `cargo doc`
- Running: `cargo run`

**Node.js/TypeScript Projects**
- Package management: Detect from lockfile:
  - `pnpm` if `pnpm-lock.yaml` exists
  - `yarn` if `yarn.lock` exists
  - `npm` if `package-lock.json` exists
- Building: Check `package.json` scripts first, prefer `pnpm build`
- Testing: Check `package.json` scripts, prefer `pnpm test`
- Running: `pnpm dev` or `pnpm start`

**Python Projects**
- Package management: Detect from project:
  - `poetry` if `pyproject.toml` with `[tool.poetry]` exists
  - `uv` if `.python-version` or `uv.lock` exists
  - `pip` as fallback
- Virtual environments: Activate existing venv if present
- Testing: `pytest` (prefer over `unittest`)
- Formatting: `black` or `ruff format` if configured

**Java Projects**
- Build tool: Detect from project:
  - `./mvnw` (Maven wrapper) if present
  - `mvn` if `pom.xml` exists
  - `./gradlew` (Gradle wrapper) if present
  - `gradle` if `build.gradle` exists
- Testing: Use project's test command (`mvn test` or `./gradlew test`)
- Formatting: `mvn spotless:apply` (auto-approved)

**Go Projects**
- Package management: `go mod` for dependencies
- Building: `go build`
- Testing: `go test ./...`
- Formatting: `go fmt` (auto-approved)
- Linting: `golangci-lint` if available

### Cross-Language Tool Preferences

**Version Control & GitHub**
- Always use `gh` CLI for GitHub operations (issues, PRs, releases, checks)
- Use `gh pr view/diff/checks` instead of web scraping
- Use `gh issue list/view/create` for issue management
- Use `gh api` for operations not covered by standard gh commands

**Container Operations**
- Use `docker compose` (not legacy `docker-compose`)
- Check for compose.yaml or docker-compose.yaml
- Prefer project-specific compose files over system-wide

**Project Scripts**
- Always check for project-specific task runners first:
  - `Makefile` → use `make <target>`
  - `justfile` → use `just <recipe>`
  - `package.json` scripts → use package manager to run
  - `.github/scripts/` → project-specific automation
- Prefer project scripts over direct tool invocation

**Testing**
- Run tests from project root unless specified otherwise
- Show full test output (don't suppress with quiet flags)
- Run formatters before running tests if code was modified

### Detection Strategy

When starting work on a project:
1. Check for language-specific files (Cargo.toml, package.json, pom.xml, go.mod, etc.)
2. Check for lockfiles to determine specific tools (pnpm-lock.yaml, poetry.lock, etc.)
3. Check for project scripts/task runners (Makefile, justfile, package.json scripts)
4. Apply the relevant language-specific preferences
5. Fall back to language defaults if no specific config found

### General Principles

- **Prefer project conventions**: If a project has existing patterns, follow them
- **Prefer wrappers**: Use `./mvnw` over `mvn`, `./gradlew` over `gradle`
- **Check before assuming**: Read lockfiles/config to detect tools, don't guess
- **Respect project scripts**: If `package.json` has a `test` script, use it

## Code Formatting

**Auto-formatting: Enabled**

Code formatting is automated and runs without approval. Formatters are configured per language:

**Rust**: `cargo fmt`
- Runs automatically on Rust projects
- Uses project's `rustfmt.toml` if present, otherwise defaults
- Standard Rust formatting conventions

**Java**: `mvn spotless:apply` + `checkstyle`
- Maven Spotless for code formatting
- Checkstyle for style validation
- Configured via project's `pom.xml` and checkstyle rules
- Runs spotless:apply to auto-fix formatting issues

**Go**: `go fmt` (or `gofmt`)
- Standard Go formatting tool
- Runs automatically on Go projects
- Non-configurable by design (Go convention)

**Formatter behavior**:
- Run formatters automatically before committing code
- If formatter fails, explain the error and how to fix it
- Don't ask permission to run formatters - they're pre-approved
- If a project doesn't have formatter config, use language defaults

## Git Operations

**Preference: Ask Before Committing**

- Never commit automatically
- Only create commits when I explicitly ask
- Before committing:
  - Show me what will be committed (git status, git diff)
  - Explain the changes being committed
  - Draft a commit message for my review
  - Wait for my approval before running git commit
- Follow these commit message guidelines:
  - Keep it concise (1-2 sentences)
  - Focus on the "why" rather than the "what"
  - Match the style of recent commits in the repo
  - Always include: `Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>`

## CI/CD Preferences

**Before creating commits/PRs:**
- Check if CI is passing on the current branch
- If CI is red, ask if I should fix it first

**After pushing:**
- Use `gh pr checks` to monitor CI status
- If CI fails, investigate and explain the failure
- Don't create PRs when tests are failing locally

**Deployment:**
- Never deploy to production without explicit approval
- Explain what will be deployed and potential impact
- Check for deployment scripts in `.github/workflows/`, `Makefile`, or `justfile`

## Dependency Management

**Adding dependencies:**
- Explain why the dependency is needed before adding it
- Check if existing dependencies can solve the problem
- Prefer well-maintained libraries with recent updates
- Mention notable alternatives and why you chose this one

**Updating dependencies:**
- Don't update dependencies unless asked or security-related
- Check changelogs for breaking changes before updating
- Run tests after dependency updates

**Security:**
- Run security audit after adding/updating dependencies:
  - Rust: `cargo audit`
  - Node: `pnpm audit` (or npm/yarn)
  - Python: `pip-audit` or `safety check`
  - Java: `mvn dependency-check:check`
- Flag any HIGH or CRITICAL vulnerabilities immediately

## Performance Considerations

**When to optimize:**
- Only optimize when there's a measured performance problem
- Don't optimize prematurely (follows minimal code philosophy)
- Profile first, then optimize

**If performance is mentioned:**
- Ask for specific goals (latency target, throughput, memory limit)
- Measure baseline before making changes
- Measure after changes to verify improvement
- Use appropriate profiling tools:
  - Rust: `cargo flamegraph`, `perf`
  - Node: `node --prof`, Chrome DevTools
  - Python: `cProfile`, `py-spy`
  - Java: JProfiler, VisualVM

## Error Handling Strategy

**When encountering errors:**
- Always explain what went wrong and why
- Show the full error message (don't truncate)
- Propose 2-3 potential solutions with trade-offs
- If the error is unclear, investigate before guessing

**Retry behavior:**
- Don't auto-retry commands without explaining why they failed first
- If a flaky test fails, run it 2-3 times before investigating
- For network/timeout errors, ask before retrying expensive operations

**When stuck:**
- After 2 failed attempts at the same approach, stop and ask for guidance
- Don't keep trying variations without a clear hypothesis
- Explain what you've tried and what you've learned

## Debugging & Logging

**Adding debug/logging:**
- Only add logging when investigating a bug or for production observability
- Don't add debug prints that will be removed immediately
- Use appropriate log levels:
  - ERROR: Action failed, needs attention
  - WARN: Something unexpected but handled
  - INFO: Key business events
  - DEBUG: Detailed troubleshooting info

**When debugging:**
- Explain your debugging hypothesis before adding instrumentation
- Remove debug code after the issue is resolved (unless it adds value)
- Use debugger breakpoints over print statements when possible

## Self-Review Checklist

**Before marking a task complete:**
- [ ] Code follows existing project patterns
- [ ] No commented-out code or TODOs (unless explicitly discussed)
- [ ] No console.log/println debugging statements left behind
- [ ] Error messages are helpful and actionable
- [ ] Edge cases are handled
- [ ] No security vulnerabilities (SQL injection, XSS, command injection, etc.)
- [ ] Tests cover the new/changed functionality
- [ ] Linting passes
- [ ] Tests pass

**Security checks:**
- Always validate user input at system boundaries
- Never log sensitive data (passwords, tokens, PII)
- Use parameterized queries (never string concatenation for SQL)
- Sanitize output in web contexts to prevent XSS

## Documentation

**When to write documentation:**
- Complex algorithms that aren't self-evident
- Public APIs or library interfaces
- Non-obvious architectural decisions
- Setup/installation steps for the project

**When NOT to write documentation:**
- Simple functions where the code is clear
- Redundant comments that just repeat the code
- Internal implementation details that may change

**Format:**
- README.md: Project overview, setup, common tasks
- Inline comments: Only for "why", not "what"
- API docs: Follow language conventions (rustdoc, JSDoc, etc.)
- Architecture decisions: If project has ADRs, follow that format

## File Organization

**Creating new files:**
- Follow existing project structure patterns
- Place files near related functionality
- Use project naming conventions (check existing files first)

**Common patterns:**
- Tests: Same directory structure as source (with `_test`/`.test`/`tests` suffix)
- Config: Project root or `.config/` directory
- Scripts: `scripts/`, `.github/scripts/`, or project-specific location
- Docs: `docs/` directory or alongside code (rustdoc, etc.)

**Before creating a file:**
- Check if similar functionality exists that could be extended
- Verify you're in the right directory for this type of file

## Context Management

**When to use Task tool with agents:**
- Exploring unfamiliar codebases (use Explore agent)
- Multi-file searches that might take several iterations
- Complex refactoring across many files
- Planning implementation (use Plan agent)

**When NOT to use agents:**
- Simple file reads (use Read tool directly)
- Searching for a specific class/function (use Glob/Grep directly)
- Single-file edits

**Parallel operations:**
- Read multiple files in parallel when gathering context
- Run independent commands in parallel (git status + git diff)
- Don't wait unnecessarily for sequential operations that could be parallel

## Research Strategy

**When investigating issues:**
- Start broad (understand the system), then narrow (find the bug)
- Read related code to understand context
- Check git history (`git log -p`, `git blame`) to understand why code exists
- Search for similar patterns in the codebase

**When to stop searching:**
- After finding a clear answer
- After 3-4 different search strategies with no results
- When you've checked the obvious places and need guidance

**What to investigate:**
- Recent changes that might have caused issues (`git log --since="1 week ago"`)
- Related test failures or error patterns
- Similar code elsewhere in the project

## General Guidelines

### Do:
- Read files before modifying them
- Follow existing project conventions and patterns
- Test changes when appropriate
- Explain your reasoning and approach
- Ask clarifying questions when requirements are unclear
- Use todo lists to track progress on multi-step tasks
- Search and explore the codebase to understand context

### Don't:
- Make assumptions about code you haven't read
- Add features or improvements beyond what was requested
- Commit changes without explicit permission
- Over-engineer solutions
- Add unnecessary abstraction layers
- Create new files unless absolutely necessary (prefer editing existing files)
- Skip explanations - I want to understand what you're doing

## Workflow Preferences

1. **For new features**: Enter plan mode, explain the approach, get approval, then implement
2. **For bug fixes**: Investigate, explain what you found, propose a fix, implement after I understand
3. **For refactoring**: Show me the current state, propose the refactored approach, explain the benefits
4. **For exploration**: Search thoroughly, read relevant files, explain what you discovered

## Tool Usage

- Use task lists (TaskCreate, TaskUpdate) to track multi-step tasks
- Prefer specialized tools (Read, Edit, Write) over bash commands for file operations
- Use parallel operations when possible for efficiency (see Context Management section)
- Enter plan mode proactively for complex work (see Approval & Planning section)
- Use agents for exploration and complex multi-step work (see Context Management section)

---

*This configuration helps Claude work in a way that matches my preferences and workflow.*
