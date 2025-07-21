# Ansible Role: PostgreSQL

[![CI](https://github.com/username/ansible-role-postgresql/workflows/CI/badge.svg)](https://github.com/username/ansible-role-postgresql/actions)
[![Security Scan](https://github.com/username/ansible-role-postgresql/workflows/Security%20Scan/badge.svg)](https://github.com/username/ansible-role-postgresql/actions)
[![Ansible Galaxy](https://img.shields.io/ansible/role/d/username.postgresql)](https://galaxy.ansible.com/username/postgresql)

Installs and configures PostgreSQL server on RHEL/CentOS or Debian/Ubuntu servers.

## Requirements

No special requirements; note that this role requires root access, so either run it in a playbook with a global `become: yes`, or invoke the role in your playbook like:

    - hosts: database
      roles:
        - role: ansible-role-postgres
          become: yes

## Supported Platforms

### Operating Systems
- **Ubuntu**: 14.04, 16.04, 18.04, 20.04 LTS, 22.04 LTS, 24.04 LTS
- **Debian**: 7, 8, 9, 10, 11, 12
- **RHEL/CentOS**: 6, 7, 8, 9

### PostgreSQL Versions
- **Ubuntu 24.04**: PostgreSQL 16
- **Ubuntu 22.04**: PostgreSQL 14
- **Ubuntu 20.04**: PostgreSQL 12
- **Ubuntu 18.04**: PostgreSQL 10
- **Debian 12**: PostgreSQL 15
- **Debian 11**: PostgreSQL 13
- **RHEL/CentOS 9**: PostgreSQL 13
- **RHEL/CentOS 8**: PostgreSQL 10

**Note**: Older PostgreSQL versions (9.x) are End-of-Life and no longer supported by the PostgreSQL community. Consider upgrading to supported versions.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    postgresql_enablerepo: ""

(RHEL/CentOS only) You can set a repo to use for the PostgreSQL installation by passing it in here.

    postgresql_restarted_state: "restarted"

Set the state of the service when configuration changes are made. Recommended values are `restarted` or `reloaded`.

    postgresql_python_library: python3-psycopg2

Library used by Ansible to communicate with PostgreSQL. Defaults to Python 3 compatible library. For older systems still using Python 2, set this to `python-psycopg2`.

    postgresql_user: postgres
    postgresql_group: postgres

The user and group under which PostgreSQL will run.

    postgresql_unix_socket_directories:
      - /var/run/postgresql

The directories (usually one, but can be multiple) where PostgreSQL's socket will be created.

    postgresql_service_state: started
    postgresql_service_enabled: true

Control the state of the postgresql service and whether it should start at boot time.

    postgresql_global_config_options:
      - option: unix_socket_directories
        value: '{{ postgresql_unix_socket_directories | join(",") }}'
      - option: shared_preload_libraries
        value: 'pg_stat_statements'

Global configuration options that will be set in `postgresql.conf`. The default configuration includes `pg_stat_statements` for query performance monitoring. Note that for RHEL/CentOS 6 (or very old versions of PostgreSQL), you need to at least override this variable and set the `option` to `unix_socket_directory`.

    postgresql_hba_entries:
      - { type: local, database: all, user: postgres, auth_method: peer }
      - { type: local, database: all, user: all, auth_method: peer }
      - { type: host, database: all, user: all, address: '127.0.0.1/32', auth_method: md5 }
      - { type: host, database: all, user: all, address: '::1/128', auth_method: md5 }

Configure [host based authentication](https://www.postgresql.org/docs/current/static/auth-pg-hba-conf.html) entries to be set in the `pg_hba.conf`. Options for entries include:

  - `type` (required)
  - `database` (required)
  - `user` (required)
  - `address` (one of this or the following two are required)
  - `ip_address`
  - `ip_mask`
  - `auth_method` (required)
  - `auth_options` (optional)

If overriding, make sure you copy all of the existing entries from `defaults/main.yml` if you need to preserve existing entries.

    postgresql_locales:
      - 'en_US.UTF-8'

(Debian/Ubuntu only) Used to generate the locales used by PostgreSQL databases.

    postgresql_databases:
      - name: exampledb # required; the rest are optional
        lc_collate: # defaults to 'en_US.UTF-8'
        lc_ctype: # defaults to 'en_US.UTF-8'
        encoding: # defaults to 'UTF-8'
        template: # defaults to 'template0'
        login_host: # defaults to 'localhost'
        login_password: # defaults to not set
        login_user: # defaults to 'postgresql_user'
        login_unix_socket: # defaults to 1st of postgresql_unix_socket_directories
        port: # defaults to not set
        owner: # defaults to postgresql_user
        state: # defaults to 'present'

A list of databases to ensure exist on the server. Only the `name` is required; all other properties are optional.

    postgresql_users:
      - name: jdoe #required; the rest are optional
        password: # defaults to not set
        encrypted: # defaults to not set
        priv: # defaults to not set
        role_attr_flags: # defaults to not set
        db: # defaults to not set
        login_host: # defaults to 'localhost'
        login_password: # defaults to not set
        login_user: # defaults to '{{ postgresql_user }}'
        login_unix_socket: # defaults to 1st of postgresql_unix_socket_directories
        port: # defaults to not set
        state: # defaults to 'present'

A list of users to ensure exist on the server. Only the `name` is required; all other properties are optional.

    postgresql_version: [OS-specific]
    postgresql_data_dir: [OS-specific]
    postgresql_bin_path: [OS-specific]
    postgresql_config_path: [OS-specific]
    postgresql_daemon: [OS-specific]
    postgresql_packages: [OS-specific]

OS-specific variables that are set by include files in this role's `vars` directory. These shouldn't be overridden unless you're using a version of PostgreSQL that wasn't installed using system packages.

## Dependencies

None.

## Development

### Local Testing

This role includes comprehensive testing with Molecule, Ansible Lint, and security scanning.

```bash
# Install development dependencies
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

### CI/CD Pipeline

The role includes a complete CI/CD pipeline with:

- **Ansible Lint**: Code quality and best practices validation
- **YAML Lint**: YAML syntax and formatting checks  
- **Molecule Testing**: Multi-distribution integration testing
- **Security Scanning**: Vulnerability and dependency scanning
- **Automated Publishing**: Automatic Ansible Galaxy publishing on releases

See [docs/CI_CD.md](docs/CI_CD.md) for detailed CI/CD documentation.

## Example Playbook

    - hosts: database
      become: yes
      vars_files:
        - vars/main.yml
      roles:
        - ansible-role-postgresql

*Inside `vars/main.yml`*:

    postgresql_databases:
      - name: example_db
    postgresql_users:
      - name: example_user
        password: supersecure

## Recent Updates

### v2024.1
- **Fixed**: Renamed misspelled `intialize.yml` to `initialize.yml`
- **Updated**: Replaced deprecated `with_items` with `loop` syntax throughout
- **Added**: Support for newer OS versions:
  - Ubuntu 20.04, 22.04, 24.04 LTS
  - Debian 10, 11, 12
  - RHEL/CentOS 8, 9
- **Updated**: Default Python library to `python3-psycopg2` for modern Python 3 environments
- **Added**: `pg_stat_statements` to default shared preload libraries for better monitoring
- **Improved**: Documentation with supported PostgreSQL versions per OS

### Breaking Changes
- Default `postgresql_python_library` changed from `python-psycopg2` to `python3-psycopg2`
- If you're still using Python 2, explicitly set: `postgresql_python_library: python-psycopg2`

## Security Considerations

- Keep PostgreSQL updated to supported versions (13+)
- Use strong passwords for database users
- Restrict network access via `postgresql_hba_entries`
- Consider enabling SSL/TLS for remote connections
- Regularly review and audit database permissions

## License

MIT / BSD

## Author Information
Kris Kelley