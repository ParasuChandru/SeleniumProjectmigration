*** Settings ***
Documentation    Shared settings and common keywords for all test suites.
...              Contains suite-level setup and teardown keywords.
Library          Collections
Library          String
Library          OperatingSystem
Library          DateTime
Library    CustomLibrary.py    WITH NAME    Custom


*** Variables ***
${ENVIRONMENT}    dev
${BASE_URL}    ${ENVIRONMENT}
${BROWSER}    chrome
${HEADLESS}    True
${TIMEOUT}    15
${IMPLICIT_WAIT}    10


*** Keywords ***
Open Browser Session
    [Documentation]    Suite setup: Open browser and navigate to base URL.
    [Arguments]    ${base_url}=${BASE_URL}
    ...    ${browser}=${BROWSER}
    ...    ${headless}=${HEADLESS}
    ...    ${timeout}=${TIMEOUT}
    Custom Library.Open Browser    ${base_url}    browser=${browser}    headless=${headless}
    Custom Library.Set Explicit Wait    ${timeout}
    Custom Library.Set Implicit Wait    ${implicit_wait}
    Custom Library.Maximize Window
    Log    Browser session opened for environment: ${ENVIRONMENT}


Close Browser Session
    [Documentation]    Suite teardown: Close the browser.
    Custom Library.Close Browser
    Log    Browser session closed


Take Screenshot
    [Documentation]    Take a screenshot and save it with the given name.
    [Arguments]    ${name}=default
    ${path}=    Custom Library.Take Screenshot    ${name}
    Log    Screenshot saved at: ${path}


Take Screenshot On Test Failure
    [Documentation]    Take a screenshot on test failure.
    ...              Call this keyword in test teardown.
    Custom Library.Take Screenshot On Failure


Wait For Application To Be Ready
    [Documentation]    Wait for the application to be fully interactive.
    [Arguments]    ${timeout}=15
    Custom Library.Wait Until Element Is Clickable    id=dashboard    css    ${timeout}
    Custom Library.Wait Until Page Does Not Contain    Loading    timeout=${timeout}


Get Current Timestamp
    [Documentation]    Get the current timestamp in standard format.
    [Return]    ${timestamp}
    ${timestamp}=    DateTime.Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    [Return]    ${timestamp}


Get Current Date
    [Documentation]    Get the current date.
    [Return]    ${date}
    ${date}=    DateTime.Get Current Date    result_format=%Y-%m-%d
    [Return]    ${date}


Log Test Summary
    [Documentation]    Log a summary of the current test execution.
    [Arguments]    ${test_name}    ${status}=${UNKNOWN}
    ${timestamp}=    Get Current Timestamp
    Log    ═══════════════════════════════════════
    Log    Test: ${test_name}
    Log    Status: ${status}
    Log    Time: ${timestamp}
    Log    ═══════════════════════════════════════


Wait For Dynamic Content
    [Documentation]    Wait for dynamic content to load (spinner disappears).
    [Arguments]    ${timeout}=15
    Custom Library.Wait Until Element Is Not Visible    xpath://div[contains(@class, 'spinner') or contains(@class, 'loader') or contains(@data-testid, 'spinner')]    xpath    ${timeout}
    Custom Library.Wait Until Element Is Not Visible    xpath://div[contains(@class, 'overlay') or contains(@class, 'backdrop')]    xpath    ${timeout}


Log Info
    [Documentation]    Log an informational message.
    [Arguments]    ${message}
    Custom Library.Log    ${message}    INFO


Log Debug
    [Documentation]    Log a debug message.
    [Arguments]    ${message}
    Custom Library.Log    ${message}    DEBUG


Log Error
    [Documentation]    Log an error message.
    [Arguments]    ${message}
    Custom Library.Log    ${message}    ERROR
