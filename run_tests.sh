#!/bin/bash
# run_tests.sh - Robot Framework Test Runner Script
# Usage: ./run_tests.sh [options]

set -e

# Default configuration
ENVIRONMENT="${ENVIRONMENT:-dev}"
BASE_URL="${BASE_URL:-https://dev.example.com}"
BROWSER="${BROWSER:-chrome}"
HEADLESS="${HEADLESS:-true}"
TAGS="${TAGS:-}"
TEST_DIR="${TEST_DIR:-tests}"
OUTPUT_DIR="${OUTPUT_DIR:-output}"

# Parse arguments
EXTRA_ARGS=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        login)
            TEST_DIR="tests/login/login_test_suite.robot"
            shift
            ;;
        navigation)
            TEST_DIR="tests/navigation/navigation_test_suite.robot"
            shift
            ;;
        forms)
            TEST_DIR="tests/forms/form_test_suite.robot"
            shift
            ;;
        verification)
            TEST_DIR="tests/verification/verification_test_suite.robot"
            shift
            ;;
        sit)
            ENVIRONMENT="sit"
            BASE_URL="https://sit.example.com"
            shift
            ;;
        sit2)
            ENVIRONMENT="sit2"
            BASE_URL="https://sit2.example.com"
            shift
            ;;
        uat)
            ENVIRONMENT="uat"
            BASE_URL="https://uat.example.com"
            shift
            ;;
        --tag)
            TAGS="$2"
            EXTRA_ARGS="$EXTRA_ARGS --tag $2"
            shift 2
            ;;
        --tag=*)
            TAGS="${1#--tag=}"
            EXTRA_ARGS="$EXTRA_ARGS $1"
            shift
            ;;
        --variable)
            EXTRA_ARGS="$EXTRA_ARGS $1 $2"
            shift 2
            ;;
        --verbose)
            EXTRA_ARGS="$EXTRA_ARGS --verbose"
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  login           Run login tests only"
            echo "  navigation      Run navigation tests only"
            echo "  forms           Run form tests only"
            echo "  verification    Run verification tests only"
            echo "  sit             Run against SIT environment"
            echo "  sit2            Run against SIT2 environment"
            echo "  uat             Run against UAT environment"
            echo "  --tag TAG       Run only tests with specified tag"
            echo "  --verbose       Enable verbose output"
            echo "  --help          Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

case "$ENVIRONMENT" in
    dev)  BASE_URL="https://dev.example.com" ;;
    sit)  BASE_URL="https://sit.example.com" ;;
    sit2) BASE_URL="https://sit2.example.com" ;;
    uat)  BASE_URL="https://uat.example.com" ;;
esac

echo "============================================"
echo "  Robot Framework Test Runner"
echo "============================================"
echo "Environment:    $ENVIRONMENT"
echo "Base URL:       $BASE_URL"
echo "Browser:        $BROWSER"
echo "Headless:       $HEADLESS"
echo "Test Directory: $TEST_DIR"
if [[ -n "$TAGS" ]]; then
    echo "Tags:           $TAGS"
fi
echo "============================================"

mkdir -p "$OUTPUT_DIR/screenshots"

robot \
    --pythonpath . \
    --variable "ENVIRONMENT:$ENVIRONMENT" \
    --variable "BASE_URL:$BASE_URL" \
    --variable "BROWSER:$BROWSER" \
    --variable "HEADLESS:$HEADLESS" \
    --outputdir "$OUTPUT_DIR" \
    $EXTRA_ARGS \
    "$TEST_DIR"

echo "============================================"
echo "  Test execution complete!"
echo "  Results: $OUTPUT_DIR/log.html"
echo "============================================"
