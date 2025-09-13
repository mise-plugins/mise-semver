#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
info() {
	echo -e "${GREEN}[INFO]${NC} $1"
}

error() {
	echo -e "${RED}[ERROR]${NC} $1"
}

warning() {
	echo -e "${YELLOW}[WARNING]${NC} $1"
}

run_test() {
	local test_name="$1"
	local test_cmd="$2"

	echo -n "Testing $test_name... "
	if eval "$test_cmd" >/dev/null 2>&1; then
		echo -e "${GREEN}✓${NC}"
		TESTS_PASSED=$((TESTS_PASSED + 1))
	else
		echo -e "${RED}✗${NC}"
		TESTS_FAILED=$((TESTS_FAILED + 1))
	fi
}

# Setup test environment
TEST_DIR=$(mktemp -d)
trap 'rm -rf $TEST_DIR' EXIT

info "Starting mise-semver plugin tests"

# Test 1: Check plugin structure
run_test "Plugin structure" "test -f metadata.lua && test -d hooks"

# Test 2: Check required hooks exist
run_test "Available hook exists" "test -f hooks/available.lua"
run_test "Pre-install hook exists" "test -f hooks/pre_install.lua"
run_test "Post-install hook exists" "test -f hooks/post_install.lua"
run_test "Env keys hook exists" "test -f hooks/env_keys.lua"

# Test 3: Validate Lua syntax
if command -v luac >/dev/null 2>&1; then
	run_test "metadata.lua syntax" "luac -p metadata.lua"
	run_test "available.lua syntax" "luac -p hooks/available.lua"
	run_test "pre_install.lua syntax" "luac -p hooks/pre_install.lua"
	run_test "post_install.lua syntax" "luac -p hooks/post_install.lua"
	run_test "env_keys.lua syntax" "luac -p hooks/env_keys.lua"
else
	warning "luac not found, skipping Lua syntax checks"
fi

# Test 4: Test with mise if available
if command -v mise >/dev/null 2>&1; then
	info "Testing with mise"

	# Save current directory
	PLUGIN_DIR=$(pwd)

	# Create test project
	cd "$TEST_DIR"

	# Uninstall plugin if already installed
	mise plugin uninstall semver 2>/dev/null || true

	# Install plugin from local directory
	run_test "Plugin installation" "mise plugin link semver '$PLUGIN_DIR'"

	# List available versions
	run_test "List versions" "mise ls-remote semver | grep -q '3.4.0'"

	# Install a specific version
	run_test "Install semver 3.4.0" "mise install semver@3.4.0"

	# Test execution
	run_test "Execute semver" "mise exec semver@3.4.0 -- semver --version | grep -q '3.4.0'"

	# Clean up
	mise plugin uninstall semver 2>/dev/null || true

	cd "$PLUGIN_DIR"
else
	warning "mise not found, skipping integration tests"
fi

# Print summary
echo
echo "Test Results:"
echo "============="
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"

if [ $TESTS_FAILED -eq 0 ]; then
	info "All tests passed!"
	exit 0
else
	error "Some tests failed"
	exit 1
fi
