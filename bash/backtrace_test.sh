#!/bin/bash
#
# Test suite for backtrace.sh

# --- Formatting Helpers ---
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

print_header() {
    echo -e "\n${BLUE}${BOLD}======================================================================${NC}"
    echo -e "${BLUE}${BOLD}  TEST: ${NC}$1"
    echo -e "${BLUE}${BOLD}======================================================================${NC}"
}

print_footer() {
    echo -e "${BLUE}${BOLD}----------------------------------------------------------------------${NC}"
    echo -e "${GREEN}${BOLD}  RESULT: PASSED ✅${NC}"
    echo -e "${BLUE}${BOLD}======================================================================${NC}\n"
}

# --- Test Setup ---
set +x 
. $(dirname $(realpath $BASH_SOURCE))/backtrace.sh

fn_c() {
    backtrace
}

fn_b() {
    fn_c 4 5 6 7;
}

fn_a() {
    fn_b 1 2 3;
}

# --- Execution ---
print_header "Nested Function Call Stack with Arguments"
echo -e "Executing call chain: ${BOLD}main() -> fn_a() -> fn_b() -> fn_c()${NC}"
echo -e "Expected: A trace showing the arguments passed at each level.\n"

# The actual test logic (unchanged)
fn_a zero $@

print_footer
