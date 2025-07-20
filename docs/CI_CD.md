# CI/CD Documentation

This document explains the Continuous Integration and Continuous Deployment (CI/CD) setup for the Ansible PostgreSQL role.

## Overview

The CI/CD pipeline is implemented using GitHub Actions and provides comprehensive testing, linting, security scanning, and automated publishing to Ansible Galaxy.

## Workflows

### 1. Main CI Pipeline (`.github/workflows/ci.yml`)

**Triggers:**
- Pull requests to main/master
- Pushes to main/master
- Weekly scheduled runs (Mondays at 6 AM UTC)

**Jobs:**

#### Lint Job
- **Purpose**: Code quality and syntax validation
- **Tools**: 
  - `yamllint`: YAML syntax and formatting
  - `ansible-lint`: Ansible best practices and syntax
- **Configuration**: 
  - `.yamllint`: YAML linting rules
  - `.ansible-lint`: Ansible linting configuration

#### Molecule Job
- **Purpose**: Integration testing across multiple distributions
- **Matrix Strategy**: Tests against multiple OS distributions
  - Ubuntu 22.04, 20.04
  - Debian 12, 11
- **Docker**: Uses containerized testing environments
- **Framework**: Molecule with Docker driver

#### Galaxy Job
- **Purpose**: Automatic publishing to Ansible Galaxy
- **Trigger**: Only on main/master branch pushes
- **Requirement**: `GALAXY_API_KEY` secret must be configured
- **Dependency**: Runs only after lint and molecule jobs pass

### 2. Security Scanning (`.github/workflows/security.yml`)

**Triggers:**
- Pushes to main/master
- Pull requests
- Weekly scheduled runs (Mondays at 2 AM UTC)

**Jobs:**

#### Security Scan
- **Trivy**: Vulnerability scanning for dependencies and configuration
- **SARIF Upload**: Results uploaded to GitHub Security tab

#### Dependency Check
- **Safety**: Python dependency vulnerability scanning
- **Bandit**: Security linting for Python code
- **Artifacts**: Security reports stored as build artifacts

### 3. Release Pipeline (`.github/workflows/release.yml`)

**Triggers:**
- Git tags matching `v*` pattern (e.g., `v1.0.0`)

**Jobs:**

#### Release Creation
- **GitHub Release**: Automatic release creation with changelog
- **Documentation**: Installation instructions included

#### Galaxy Publishing
- **Ansible Galaxy**: Automatic role publishing on tagged releases
- **Dependency**: Runs after successful release creation

## Configuration Files

### Linting Configuration

#### `.ansible-lint`
- **Purpose**: Ansible-specific linting rules
- **Key Settings**:
  - Production profile for strict checking
  - Exclusion of test directories
  - Custom rule configurations
  - Line length limits (120 characters)

#### `.yamllint`
- **Purpose**: YAML formatting and syntax rules
- **Key Settings**:
  - Extended default rules
  - Truthy value handling
  - Indentation standards (2 spaces)
  - Comment formatting rules

### Testing Configuration

#### `requirements.txt`
- **Purpose**: Python dependencies for development and testing
- **Includes**:
  - Ansible and ansible-core
  - Testing frameworks (molecule, pytest)
  - Linting tools
  - Docker support

#### `tox.ini`
- **Purpose**: Local testing environment configuration
- **Features**:
  - Multiple Python versions (3.8-3.11)
  - Multiple Ansible versions (4-7)
  - Isolated testing environments
  - GitHub Actions integration

## Local Development

### Setup
```bash
# Install dependencies
make setup

# Run all tests
make test

# Run linting only
make lint

# Run molecule tests
make molecule

# Run security checks
make security
```

### Common Tasks
```bash
# Check syntax
make check-syntax

# Clean up artifacts
make clean

# Setup development environment
make dev-setup
```

## Secrets Configuration

### Required Secrets

#### `GALAXY_API_KEY`
- **Purpose**: Publishing to Ansible Galaxy
- **Setup**: 
  1. Get API key from [Ansible Galaxy](https://galaxy.ansible.com/)
  2. Add to GitHub repository secrets
  3. Key name: `GALAXY_API_KEY`

### Optional Secrets

#### `GITHUB_TOKEN`
- **Purpose**: Release creation and artifact uploads
- **Setup**: Automatically provided by GitHub Actions

## Badge Status

Add these badges to your README.md:

```markdown
[![CI](https://github.com/username/repo/workflows/CI/badge.svg)](https://github.com/username/repo/actions)
[![Security Scan](https://github.com/username/repo/workflows/Security%20Scan/badge.svg)](https://github.com/username/repo/actions)
[![Ansible Galaxy](https://img.shields.io/ansible/role/d/username.repo)](https://galaxy.ansible.com/username/repo)
```

## Troubleshooting

### Common Issues

#### 1. Lint Failures
- **Symptom**: yamllint or ansible-lint failures
- **Solution**: 
  - Check configuration files
  - Run `make lint` locally
  - Fix reported issues

#### 2. Molecule Test Failures
- **Symptom**: Docker or container issues
- **Solution**:
  - Check Docker availability
  - Verify molecule configuration
  - Run `make molecule` locally

#### 3. Galaxy Publishing Failures
- **Symptom**: Galaxy import errors
- **Solution**:
  - Verify `GALAXY_API_KEY` secret
  - Check role metadata in `meta/main.yml`
  - Ensure role follows Galaxy requirements

#### 4. Security Scan Alerts
- **Symptom**: Trivy or dependency vulnerabilities
- **Solution**:
  - Update dependencies in `requirements.txt`
  - Review security recommendations
  - Address critical vulnerabilities promptly

### Debug Mode

To debug workflows:

1. **Enable Debug Logging**:
   - Set repository secret `ACTIONS_STEP_DEBUG` to `true`
   - Set repository secret `ACTIONS_RUNNER_DEBUG` to `true`

2. **Local Testing**:
   ```bash
   # Run with verbose output
   ANSIBLE_VERBOSITY=2 make test
   
   # Debug molecule
   molecule --debug test
   ```

## Best Practices

### Code Quality
- Always run `make lint` before committing
- Use `make test` for comprehensive local testing
- Follow Ansible best practices enforced by ansible-lint

### Security
- Regular dependency updates
- Monitor security scan results
- Address vulnerabilities promptly
- Use strong secrets management

### Releases
- Follow [Semantic Versioning](https://semver.org/)
- Update CHANGELOG.md before releases
- Tag releases with `v` prefix (e.g., `v1.2.3`)
- Test releases in staging before production

### Documentation
- Keep README.md updated
- Document breaking changes
- Provide clear examples
- Update version compatibility matrices