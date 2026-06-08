*** Variables ***
${BASE_URL}    https://example.com
${BROWSER}    chrome
${HEADLESS}    True
${TIMEOUT}    15
${ENVIRONMENT}    dev

*** Settings ***
Documentation    Main Test Suite Runner
...              Run this file to execute the full test suite.
...
...              To run all tests:
...                  robot tests/
...
...              Or using the run script:
...                  run_tests.bat
...
...              Jira Epic: TEST-100
Library          SeleniumLibrary


*** Test Cases ***
Run All Test Suites
    [Documentation]    Top-level test.
    [Tags]    smoke    regression    full-suite
    Go To    ${BASE_URL}
    Log    Starting test suite execution
    Log    Environment: ${ENVIRONMENT}
    Log    Base URL: ${BASE_URL}
