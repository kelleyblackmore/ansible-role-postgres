# Changelog

All notable changes to this Ansible role will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- GitHub Actions CI/CD pipeline with comprehensive testing
- Ansible Lint configuration and integration
- YAML Lint configuration and checks
- Security scanning with Trivy and dependency checks
- Molecule testing framework with multi-distro support
- Tox configuration for local testing environments
- Support for newer OS versions:
  - Ubuntu 20.04, 22.04, 24.04 LTS
  - Debian 10, 11, 12
  - RHEL/CentOS 8, 9
- Ansible Galaxy metadata and publishing workflow
- Comprehensive documentation updates

### Changed
- **BREAKING**: Default `postgresql_python_library` changed from `python-psycopg2` to `python3-psycopg2`
- Updated all task files to use `loop` instead of deprecated `with_items`
- Improved default configuration with `pg_stat_statements` enabled
- Enhanced README with supported platforms matrix and security considerations

### Fixed
- Renamed misspelled `tasks/intialize.yml` to `tasks/initialize.yml`
- Removed deprecated Ansible syntax throughout the codebase
- Cleaned up `.DS_Store` files and improved `.gitignore`

### Security
- Added security scanning and dependency checking in CI
- Enhanced default PostgreSQL configuration for better security
- Added security best practices documentation

## [v1.0.0] - Historical

### Added
- Initial PostgreSQL role implementation
- Support for Ubuntu 14-18, Debian 7-9, RHEL/CentOS 6-7
- Basic PostgreSQL installation and configuration
- Database and user management
- Host-based authentication configuration

### Features
- Cross-platform PostgreSQL installation
- Configurable PostgreSQL settings
- Database and user management
- Template-based configuration files