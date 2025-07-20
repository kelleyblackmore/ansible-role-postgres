# Makefile for Ansible PostgreSQL Role

.PHONY: help install lint test molecule clean setup

# Default target
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Install development dependencies
	@echo "Setting up development environment..."
	pip install -r requirements.txt
	ansible-galaxy collection install community.general
	ansible-galaxy collection install ansible.posix

install: setup ## Alias for setup

lint: ## Run linting checks
	@echo "Running YAML lint..."
	yamllint .
	@echo "Running Ansible lint..."
	ansible-lint

test: lint ## Run all tests including linting and molecule
	@echo "Running molecule tests..."
	molecule test

molecule: ## Run molecule tests only
	@echo "Running molecule tests..."
	molecule test

molecule-converge: ## Run molecule converge (create and provision)
	molecule converge

molecule-verify: ## Run molecule verify
	molecule verify

molecule-destroy: ## Destroy molecule instances
	molecule destroy

security: ## Run security checks
	@echo "Running safety check..."
	safety check -r requirements.txt || true
	@echo "Running bandit security check..."
	bandit -r . || true

tox: ## Run tox tests
	tox

clean: ## Clean up temporary files and test artifacts
	@echo "Cleaning up..."
	rm -rf .tox/
	rm -rf .pytest_cache/
	rm -rf .cache/
	rm -rf htmlcov/
	rm -f .coverage
	rm -f bandit-report.json
	rm -f trivy-results.sarif
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	molecule destroy || true

docs: ## Generate documentation (if applicable)
	@echo "Documentation is in README.md and CHANGELOG.md"

galaxy-install: ## Install role from Ansible Galaxy
	ansible-galaxy install geerlingguy.postgresql

galaxy-info: ## Show role information
	ansible-galaxy info geerlingguy.postgresql

check-syntax: ## Check Ansible syntax
	ansible-playbook --syntax-check molecule/default/converge.yml

# Development shortcuts
dev-setup: setup ## Setup development environment with additional tools
	pip install pre-commit
	pre-commit install

format: ## Format code (placeholder for future formatters)
	@echo "No specific formatters configured yet"

watch: ## Watch files and run tests on changes (requires entr)
	find . -name "*.yml" -o -name "*.yaml" | entr -c make test