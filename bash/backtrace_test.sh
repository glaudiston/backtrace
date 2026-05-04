#!/bin/bash
#
# Automated Test suite for backtrace.sh

# --- Formatting Helpers ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

print_header() {
    echo -e "\n${BLUE}${BOLD}======================================================================${NC}"
    echo -e "${BLUE}${BOLD}  TEST: ${NC}$1"
    echo -e "${BLUE}${BOLD}==============================================================================${NC}"
}

# Normalizes whitespace and removes the test-runner wrapper (run_test) 
# but PRESERVES line numbers, filenames, and function names.
normalize_trace() {
    local input="$1"
    echo "$input" | \
                    grep -vE "test_|run_test" | \
                    tr -s ' '
}

# --- Assertion Logic ---
assert_output() {
    local test_name="$1"
    local actual="$2"
    local expected="$3"

    local norm_actual=$(normalize_trace "$actual")
    local norm_expected=$(normalize_trace "$expected")

    if [[ "$norm_actual" == "$norm_expected" ]]; then
        echo -e "${GREEN}${BOLD}  PASS ✅${NC} $test_name"
        return 0
    else
        echo -e "${RED}${BOLD}  FAIL ❌${NC} $test_name"
        echo -e "${RED}  Expected (normalized):${NC}\n    $norm_expected"
        echo -e "${RED}  Actual (normalized):${NC}\n    $norm_actual"
        return 1
    fi
}

# --- Test Setup ---
set +x 
. "$(dirname "$(realpath "$0")")/backtrace.sh"

# --- Test Targets ---

# Test Case 1: Nested calls
fn_c() { backtrace; }
fn_b() { fn_c "4" "5" "6" "7"; }
fn_a() { fn_b "1" "2" "3"; }

test_nested_args() {
    print_header "Nested Function Call Stack with Arguments"
    local actual
    actual=$(fn_a "zero" "arg1" "arg2")

    # Line numbers: 58 (fn_c), 59 (fn_b), 60 (fn_a), 133 (main/run_test)
    local expected="backtrace:
backtrace_test.sh:54  fn_c 4 5 6 7
backtrace_test.sh:55  fn_b 1 2 3
backtrace_test.sh:56  fn_a zero arg1 arg2
backtrace_test.sh:121  main "

    assert_output "Nested Depth Check" "[$actual]" "[$expected]"
}

# Test Case 2: No arguments
fn_no_args_c() { backtrace; }
fn_no_args_b() { fn_no_args_c; }

test_no_args() {
    print_header "Functions with No Arguments"
    local actual
    actual=$(fn_no_args_b)

    # Line numbers: 84 (fn_no_args_c), 85 (fn_no_args_b), 134 (main/run_test)
    local expected="backtrace:
backtrace_test.sh:74  fn_no_args_c 
backtrace_test.sh:75  fn_no_args_b 
backtrace_test.sh:122  main "
    
    assert_output "No Args Check" "[$actual]" "[$expected]"
}

# Test Case 3: Arguments with spaces
fn_spaces_c() { backtrace; }
fn_spaces_b() { fn_spaces_c "hello world" "'quoted string'"; }

test_spaces() {
    print_header "Arguments with Spaces"
    local actual
    actual=$(fn_spaces_b)
 
    # Line numbers: 103 (fn_spaces_c), 104 (fn_spaces_b), 135 (main/run_test)
    local expected="backtrace:
backtrace_test.sh:92  fn_spaces_c hello world 'quoted string'
backtrace_test.sh:93  fn_spaces_b 
backtrace_test.sh:123  main "
    
    assert_output "Spaces Handling Check" "[$actual]" "[$expected]"
}

# --- Main Execution ---

TOTAL_PASSED=0
TOTAL_TESTS=0

run_test() {
    ((TOTAL_TESTS++))
    if "$1"; then
        ((TOTAL_PASSED++))
    fi
}

run_test test_nested_args
run_test test_no_args
run_test test_spaces

echo -e "\n${BLUE}${BOLD}======================================================================${NC}"
echo -e "  FINAL RESULT: ${GREEN}${BOLD}$TOTAL_PASSED / $TOTAL_TESTS PASSED${NC}"
echo -e "${BLUE}${BOLD}=======================================================================${NC}\n"

if [ $TOTAL_PASSED -ne $TOTAL_TESTS ]; then
    exit 1
fi
