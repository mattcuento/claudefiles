# Claude Configuration

## Development Tooling

### Python Environment
- Use `mise` for managing Python versions (`mise use python@3.x`)
- Initialize projects with `uv`: `uv init`, `uv add`, `uv run`
- Use `pyproject.toml` as the single configuration file (no setup.py, no requirements.txt)
- Prefer `src/` layout for installable packages; flat layout only for simple scripts

### Testing
- Use `pytest` for all tests
- Place tests in `tests/` mirroring the `src/` structure
- Use `pytest-cov` for coverage; aim for meaningful coverage, not 100%

### Linting & Formatting
- Use `ruff` for linting and formatting (replaces flake8, black, isort)
- Use `mypy` or `pyright` for static type checking
- Run `ruff check . && ruff format .` before committing

### Project Structure
```
project/
├── src/
│   └── mypackage/
├── tests/
├── pyproject.toml
└── README.md
```

---

## Methodology

- **SOLID principles**: Apply consistently. Single responsibility, open/closed, Liskov substitution, interface segregation, dependency inversion.
- **TDD by default**: Write a failing test first, then implement. Skip only for throwaway prototypes or trivial fixes — explain why when skipping.
- **Spec-driven development**: Before implementing, define requirements, constraints, goals, non-goals, and open concerns. Don't build what isn't specified.
- **Iterative and scoped**: Tasks should be isolated, well-defined, and independently deliverable. Avoid big-bang changes.
- **YAGNI**: Don't build for hypothetical future needs. Implement what's required now.
- **Fail fast**: Surface errors early and loudly. Don't hide failures.
- **Prefer explicit over implicit**: Make behavior obvious from the code, not from hidden conventions.
- **Make invalid states unrepresentable**: Use types and structure to eliminate illegal states rather than guarding against them at runtime.
- **Design for the reader**: Code is read far more than it is written. Optimize for comprehension.

---

## Style

- **Correctness > Simplicity > Performance**: In that order, always.
- **Readability first**: Clear abstractions and well-named contracts matter more than cleverness.
- **Avoid pointless comments**: If the code is clear, don't explain it. Comments should explain *why*, not *what*.
- **Descriptive names over comments**: A well-named function needs no docstring to explain its purpose.
- **Low cyclomatic complexity**: Keep functions and methods simple. If branching is deep, decompose.
- **Functions do one thing**: Small, focused units are easier to test, read, and reuse.
- **Abstractions where they earn their place**: Introduce abstraction when there are 2–3 concrete cases, not speculatively.
- **Duplication over wrong abstraction**: Prefer a little duplication to a premature or forced abstraction.
- **Composition > Inheritance**: Favor composing small behaviors over deep class hierarchies.
- **Prefer immutability**: Avoid mutating state unless necessary.

---

## CLAUDE.md Authoring

- **Don't duplicate README content**: If a README already documents something (commands, architecture, setup), reference it rather than copying it into CLAUDE.md. Keep CLAUDE.md focused on what isn't captured elsewhere.

---

## Priorities

1. **Correctness and functionality first**: A fast wrong answer is worse than a slow right one.
2. **Clarity**: Ask qualifying questions if the problem is ambiguous. Don't assume.
3. **Testability**: Well-structured, meaningful tests. Not coverage for its own sake.
4. **Maintainability**: Simple, readable, easy to change.
5. **Performance**: Only after the above are satisfied — and only with measurement.
