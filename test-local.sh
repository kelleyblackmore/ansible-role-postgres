#!/bin/bash
# Local testing script to identify issues before CI

set -e

echo "🔍 Running local tests..."

echo "📋 Installing dependencies..."
pip3 install --upgrade pip
pip3 install -r requirements.txt

echo "🔍 Checking YAML syntax..."
python3 -c "
import yaml
import glob
for file in glob.glob('**/*.yml', recursive=True) + glob.glob('**/*.yaml', recursive=True):
    try:
        with open(file) as f:
            yaml.safe_load(f)
        print(f'✅ {file}')
    except Exception as e:
        print(f'❌ {file}: {e}')
        exit(1)
"

echo "🔍 Running yamllint..."
yamllint .

echo "🔍 Running ansible-lint..."
ansible-lint --force-color

echo "🔍 Checking syntax with ansible-playbook..."
ansible-playbook --syntax-check molecule/default/converge.yml

echo "✅ All local tests passed!"