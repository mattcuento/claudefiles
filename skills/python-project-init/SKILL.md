---
name: python-project-init
description: Use when the user wants to create a new Python project, scaffold a project template, or bootstrap a Python package with testing, linting, and type-checking configured.
---

# Python Project Init

Scaffold a new Python project following standard conventions: `uv` + `mise`, `src/` layout, `ruff`, `mypy`, `pytest`, `pre-commit`.

**Announce at start:** "I'm using the python-project-init skill to scaffold the project."

---

## Step 1: Gather Inputs

Ask the user (or infer from context) for:

| Input | Format | Example |
|-------|--------|---------|
| `project-name` | kebab-case | `my-cool-lib` |
| `description` | short sentence | `"A library for doing cool things"` |
| `python_version` | `X.Y` | `3.14` (default) |
| `package_name` | snake_case | `my_cool_lib` (auto-derived: replace hyphens with underscores) |

Confirm with the user before proceeding.

---

## Step 2: Create Directory Structure

```bash
mkdir -p <project-name>/src/<package_name>
mkdir -p <project-name>/tests
mkdir -p <project-name>/docs
```

---

## Step 3: Create `pyproject.toml`

Write to `<project-name>/pyproject.toml`:

```toml
[project]
name = "<project-name>"
version = "0.1.0"
description = "<description>"
requires-python = ">=<python_version>"
dependencies = []

[project.optional-dependencies]
dev = [
    "pytest>=8.0",
    "pytest-cov>=5.0",
    "mypy>=1.10",
    "pre-commit>=3.7",
]

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.wheel]
packages = ["src/<package_name>"]

[tool.ruff]
line-length = 88
target-version = "py<python_version_no_dot>"

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B", "SIM"]
ignore = []

[tool.mypy]
strict = true
python_version = "<python_version>"
mypy_path = "src"

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "--cov=src --cov-report=term-missing"

[tool.coverage.run]
source = ["src"]
omit = ["tests/*"]
```

> `<python_version_no_dot>`: strip the dot — e.g. `3.12` → `py312`.

---

## Step 4: Create Source and Test Stubs

**`src/<package_name>/__init__.py`** — empty file.

**`tests/__init__.py`** — empty file.

**`tests/test_placeholder.py`**:

```python
def test_import() -> None:
    import <package_name>  # noqa: F401
```

---

## Step 5: Create `README.md`

````markdown
# <project-name>

<description>

## Development

```bash
uv sync               # install dependencies
uv run pytest         # run tests
uv run ruff check .   # lint
uv run mypy src/      # type check
```
````

---

## Step 6: Create `.gitignore`

```
__pycache__/
*.py[cod]
*.egg-info/
.eggs/
dist/
build/
.venv/
.mypy_cache/
.pytest_cache/
.ruff_cache/
.coverage
htmlcov/
*.log
.env
```

---

## Step 7: Create `.pre-commit-config.yaml`

```yaml
repos:
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.15.8
    hooks:
      - id: ruff
        args: [--fix]
      - id: ruff-format
```

---

## Step 8: Bootstrap Environment

Run inside `<project-name>/`:

```bash
mise use python@<python_version>
uv sync
git init
git add .
git commit -m "chore: initial project scaffold"
uv run pre-commit install
```

> `uv sync` reads `pyproject.toml` directly — do not run `uv init` since `pyproject.toml` already exists.

---

## Step 9: Verify

Run each command and confirm zero errors:

```bash
uv run ruff check .
uv run ruff format --check .
uv run mypy src/
uv run pytest
```

Expected output:
- `ruff check`: no output (clean)
- `ruff format --check`: `1 file already formatted`
- `mypy`: `Success: no issues found in N source files`
- `pytest`: `1 passed`

Fix any failures before declaring the scaffold complete.

---

## Done

Report to the user:

```
Project scaffolded at ./<project-name>/

  src/<package_name>/       source code goes here
  tests/                    test suite
  pyproject.toml            single config: ruff, mypy, pytest, coverage
  .pre-commit-config.yaml   ruff linting/formatting on every commit
  README.md                 template

Next: add code to src/<package_name>/ and tests to tests/.
```
