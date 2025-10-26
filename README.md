# Makefile Modules for Symfony Projects

This repository contains modular, reusable Makefile components designed for Symfony 7 PHP applications. These modules provide standardized development workflows that can be easily included in any project's main Makefile.

## Purpose

The goal of this repository is to:

- **Standardize workflows** - Provide consistent commands across different Symfony projects
- **Reduce boilerplate** - Share common development tasks without duplicating code
- **Improve productivity** - Offer shorthand aliases for frequently used commands
- **Maintain quality** - Include built-in quality assurance and testing workflows

## Repository Structure

```
.
├── git/
│   └── MAKE_GIT_v1          # Git workflow commands (60+ commands with aliases)
├── sf-7/
│   ├── MAKE_APP             # Application-specific console commands
│   ├── MAKE_QA              # Quality assurance (PHPStan, PHPCS)
│   ├── MAKE_SF              # Core Symfony operations (cache, migrations, database)
│   └── MAKE_TESTS           # Test execution (unit, integration, acceptance)
├── phpunit/                 # PHPUnit configuration
└── tools/
    └── tests/
        └── check-makefile-aliases.sh  # Alias validation script
```

## Usage

Include these modules in your project's main Makefile:

```makefile
# Define docker-compose variable (required by all modules)
docker-compose = docker-compose

# Include modules as needed
include path/to/git/MAKE_GIT_v1
include path/to/sf-7/MAKE_SF
include path/to/sf-7/MAKE_TESTS
include path/to/sf-7/MAKE_QA
include path/to/sf-7/MAKE_APP
```

## Common Commands

### Testing
```bash
make tests              # Run all tests (unit + integration)
make tests_unit         # Run unit tests
make tests_integration  # Run integration tests
make tests_fast         # Run tests without database seeding
```

### Quality Assurance
```bash
make qa                 # Run all QA checks (phpcs + phpstan)
make phpstan            # Run PHPStan static analysis
make phpcs              # Check code styling
make phpcs_fix          # Auto-fix code styling issues
```

### Symfony Operations
```bash
make sf_cc              # Clear Symfony cache
make sf_mig             # Run database migrations
make sf_db_reload       # Complete database reload (drop, create, migrate)
make sf_seed            # Load Doctrine fixtures
```

### Git Workflows
```bash
make git_status         # Show working tree status (alias: gs)
make git_log            # Show recent commit history (alias: gl)
make git_push           # Push current branch (alias: gp)
make git_rebase_develop # Rebase with origin/develop (alias: grd)
```

**Pro tip:** Most git commands have short aliases! Use `gs` instead of `git_status`, `gp` instead of `git_push`, etc.

## Development

### Mandatory Checks

Before committing changes to this repository, ensure all validation checks pass:

#### 1. Alias Validation

Run the alias checker to verify no duplicate aliases exist:

```bash
./tools/tests/check-makefile-aliases.sh
```

This script checks:
- ✓ No duplicate aliases across all Makefile modules
- ✓ All aliases documented in comments match their definitions
- ✓ Consistency between `(alias: xyz)` notation and actual alias implementations

**Exit codes:**
- `0` - All checks passed
- `1` - Errors found (duplicates or inconsistencies)

#### 2. Pre-commit Integration

Add to your `.git/hooks/pre-commit`:

```bash
#!/bin/bash
echo "Running Makefile alias validation..."
./tools/tests/check-makefile-aliases.sh
if [ $? -ne 0 ]; then
    echo "❌ Alias validation failed. Please fix errors before committing."
    exit 1
fi
```

#### 3. CI/CD Integration

Include in your CI pipeline:

```yaml
# Example for GitHub Actions
- name: Validate Makefile Aliases
  run: |
    chmod +x ./tools/tests/check-makefile-aliases.sh
    ./tools/tests/check-makefile-aliases.sh
```

### Adding New Commands

When adding new commands with aliases:

1. **Add the command** with alias notation:
   ```makefile
   git_new_command: ### Description of command (alias: gnc)
       git some-command
   ```

2. **Add the alias definition** in the `# Aliases` section:
   ```makefile
   # Aliases
   gnc: git_new_command
   ```

3. **Run validation** to ensure no conflicts:
   ```bash
   ./tools/tests/check-makefile-aliases.sh
   ```

### Naming Conventions

- **Commands**: Use descriptive names with underscores (e.g., `git_branch_delete`, `sf_db_reload`)
- **Aliases**: Use short, memorable abbreviations (e.g., `gbd`, `sfr`)
- **Prefixes**:
  - `git_` for git operations
  - `sf_` for Symfony commands
  - `tests_` for testing commands
  - No prefix for QA commands

## Architecture Notes

### Dual Environment Pattern

Many Symfony commands execute against both `dev` and `test` environments to keep databases in sync:

```makefile
sf_mig:
    $(docker-compose) exec app php bin/console doctrine:migrations:migrate --no-interaction
    $(docker-compose) exec app php bin/console doctrine:migrations:migrate --env=test --no-interaction
```

### Messenger Architecture

The application uses Symfony Messenger with multiple transports:
- `emails` - Email sending queue
- `async` - General asynchronous tasks
- `computations` - Computational tasks
- `ai` - AI-related processing
- `external` - External service integrations
- `failed` - Failed message handling
- `scheduler_default` - Scheduled tasks and cron jobs

### Git Safety

Git commands use `--force-with-lease` instead of `--force` to prevent overwriting others' work unintentionally.

## Documentation

- [CLAUDE.md](CLAUDE.md) - Detailed guidance for AI assistants working with this codebase
- Individual Makefile modules contain inline documentation with `###` comments

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add your changes following naming conventions
4. Run `./tools/tests/check-makefile-aliases.sh` to validate
5. Submit a pull request

## License

This project is intended for internal use and standardization across Symfony projects.
