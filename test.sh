#!/bin/bash

# Test suite for wc utility
# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

TESTS_PASSED=0
TESTS_FAILED=0
EXEC="./wc"

# Check if executable exists
if [ ! -f "$EXEC" ]; then
    echo -e "${RED}Error: $EXEC not found. Please run 'make' first.${NC}"
    exit 1
fi

# Function to run a test
run_test() {
    local test_name=$1
    local input=$2
    local expected_lines=$3
    local expected_words=$4
    local expected_numbers=$5
    local expected_chars=$6

    echo -n "Testing: $test_name ... "

    # Run the program
    output=$(echo -n "$input" | $EXEC)

    # Extract values from output (last line, columns)
    actual_lines=$(echo "$output" | tail -1 | awk '{print $1}')
    actual_words=$(echo "$output" | tail -1 | awk '{print $2}')
    actual_numbers=$(echo "$output" | tail -1 | awk '{print $3}')
    actual_chars=$(echo "$output" | tail -1 | awk '{print $4}')

    # Compare results
    if [ "$actual_lines" = "$expected_lines" ] && \
       [ "$actual_words" = "$expected_words" ] && \
       [ "$actual_numbers" = "$expected_numbers" ] && \
       [ "$actual_chars" = "$expected_chars" ]; then
        echo -e "${GREEN}PASSED${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}FAILED${NC}"
        echo "  Expected: lines=$expected_lines words=$expected_words numbers=$expected_numbers chars=$expected_chars"
        echo "  Got:      lines=$actual_lines words=$actual_words numbers=$actual_numbers chars=$actual_chars"
        ((TESTS_FAILED++))
    fi
}

# Function to run a file-based test
run_file_test() {
    local test_name=$1
    local input_file=$2
    local expected_lines=$3
    local expected_words=$4
    local expected_numbers=$5
    local expected_chars=$6

    echo -n "Testing: $test_name ... "

    # Run the program with file input
    output=$($EXEC < "$input_file")

    # Extract values from output
    actual_lines=$(echo "$output" | tail -1 | awk '{print $1}')
    actual_words=$(echo "$output" | tail -1 | awk '{print $2}')
    actual_numbers=$(echo "$output" | tail -1 | awk '{print $3}')
    actual_chars=$(echo "$output" | tail -1 | awk '{print $4}')

    # Compare results
    if [ "$actual_lines" = "$expected_lines" ] && \
       [ "$actual_words" = "$expected_words" ] && \
       [ "$actual_numbers" = "$expected_numbers" ] && \
       [ "$actual_chars" = "$expected_chars" ]; then
        echo -e "${GREEN}PASSED${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}FAILED${NC}"
        echo "  Expected: lines=$expected_lines words=$expected_words numbers=$expected_numbers chars=$expected_chars"
        echo "  Got:      lines=$actual_lines words=$actual_words numbers=$actual_numbers chars=$actual_chars"
        ((TESTS_FAILED++))
    fi
}

echo -e "${YELLOW}Running wc test suite${NC}"
echo "================================"

# Test 1: Empty input
run_test "Empty input" "" 0 0 0 0

# Test 2: Single word
run_test "Single word" "hello" 0 1 0 5

# Test 3: Multiple words
run_test "Multiple words" "hello world" 0 2 0 11

# Test 4: Single line with newline
run_test "Single line with newline" "hello world
" 1 2 0 12

# Test 5: Multiple lines
run_test "Multiple lines" "hello
world
" 2 2 0 12

# Test 6: Numbers only
run_test "Integer numbers" "42 123 456" 0 0 3 10

# Test 7: Floating point numbers
run_test "Floating point numbers" "3.14 2.718" 0 0 2 10

# Test 8: Negative numbers
run_test "Negative numbers" "-42 -3.14" 0 0 2 9

# Test 9: Mixed content
run_test "Mixed words and numbers" "hello 42 world 3.14" 0 2 2 19

# Test 10: Special characters
run_test "Special characters" "!@#$%^&*()" 0 0 0 10

# Test 11: Mixed with special chars
run_test "Mixed with punctuation" "hello, world! 123." 0 2 1 18

# Test 12: Numbers with signs
run_test "Numbers with plus sign" "+42 +3.14" 0 0 2 9

# Test 13: Multiple lines with content
run_test "Multi-line mixed content" "Line one has words
Line two has 123 and 456
" 2 8 2 44

# Test 14: Tabs and spaces
run_test "Tabs and spaces" "	hello	world	" 0 2 0 13

# Test 15: Number edge cases
run_test "Decimal numbers" "0.5 .5 5." 0 0 3 9

# File-based tests (if test files exist)
if [ -f "test_inputs/sample1.txt" ]; then
    run_file_test "Sample file 1" "test_inputs/sample1.txt" 3 15 2 83
fi

if [ -f "test_inputs/sample2.txt" ]; then
    run_file_test "Sample file 2" "test_inputs/sample2.txt" 5 22 3 142
fi

echo "================================"
echo -e "Tests passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Tests failed: ${RED}$TESTS_FAILED${NC}"
echo "Total tests: $((TESTS_PASSED + TESTS_FAILED))"

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
