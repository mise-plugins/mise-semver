#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Lint status
LINT_PASSED=true

# Helper functions
info() {
	echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
	echo -e "${RED}[ERROR]${NC} $1"
	LINT_PASSED=false
}

warning() {
	echo -e "${YELLOW}[WARNING]${NC} $1"
}

info "Starting linting checks"

# Check shell scripts with shellcheck
if command -v shellcheck >/dev/null 2>&1; then
	info "Checking shell scripts with shellcheck..."

	for script in scripts/*.sh; do
		if [ -f "$script" ]; then
			echo -n "  Checking $(basename "$script")... "
			if shellcheck "$script"; then
				echo -e "${GREEN}✓${NC}"
			else
				echo -e "${RED}✗${NC}"
				LINT_PASSED=false
			fi
		fi
	done
else
	warning "shellcheck not found, install with: mise install shellcheck"
fi

# Check shell script formatting with shfmt
if command -v shfmt >/dev/null 2>&1; then
	info "Checking shell script formatting with shfmt..."

	for script in scripts/*.sh; do
		if [ -f "$script" ]; then
			echo -n "  Checking $(basename "$script")... "
			if shfmt -d "$script" >/dev/null 2>&1; then
				echo -e "${GREEN}✓${NC}"
			else
				echo -e "${RED}✗${NC} (run 'mise run lint:fix' to fix)"
				LINT_PASSED=false
			fi
		fi
	done
else
	warning "shfmt not found, install with: mise install shfmt"
fi

# Check Lua syntax
if command -v luac >/dev/null 2>&1; then
	info "Checking Lua syntax..."

	# Check all Lua files
	for lua_file in metadata.lua hooks/*.lua; do
		if [ -f "$lua_file" ]; then
			echo -n "  Checking $(basename "$lua_file")... "
			if luac -p "$lua_file" 2>/dev/null; then
				echo -e "${GREEN}✓${NC}"
			else
				echo -e "${RED}✗${NC}"
				luac -p "$lua_file"
				LINT_PASSED=false
			fi
		fi
	done
else
	warning "luac not found, skipping Lua syntax checks"
fi

# Check for common issues in Lua files
info "Checking for common Lua issues..."

# Check for consistent indentation (4 spaces)
for lua_file in metadata.lua hooks/*.lua; do
	if [ -f "$lua_file" ]; then
		echo -n "  Checking indentation in $(basename "$lua_file")... "
		if ! grep -q $'^\t' "$lua_file"; then
			echo -e "${GREEN}✓${NC}"
		else
			echo -e "${RED}✗${NC} (found tabs, use 4 spaces)"
			LINT_PASSED=false
		fi
	fi
done

# Check for trailing whitespace
for file in metadata.lua hooks/*.lua scripts/*.sh README.md; do
	if [ -f "$file" ]; then
		echo -n "  Checking trailing whitespace in $(basename "$file")... "
		if ! grep -q '[[:space:]]$' "$file"; then
			echo -e "${GREEN}✓${NC}"
		else
			echo -e "${RED}✗${NC}"
			LINT_PASSED=false
		fi
	fi
done

# Summary
echo
if [ "$LINT_PASSED" = true ]; then
	info "All linting checks passed!"
	exit 0
else
	error "Some linting checks failed"
	exit 1
fi
