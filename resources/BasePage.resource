*** Settings ***
Documentation    Base page object resource file containing common reusable keywords.
...              This file provides foundational page interaction keywords used across all test suites.
...              Follows the Page Object Model (POM) pattern as per LT Automation Guidelines.
Library          Collections
Library          String
Library          OperatingSystem
Library          Process


*** Keywords ***
Log To Console
    [Documentation]    Log a message to the console output.
    [Arguments]    ${message}
    Log To Console    ${message}


Wait For Element Visible
    [Documentation]    Generic wait until element is visible.
    [Arguments]    ${selector}    ${locator_type}=xpath    ${timeout}=15
    Custom Library.Wait Until Element Is Visible    ${selector}    ${locator_type}    ${timeout}


Wait For Element Clickable
    [Documentation]    Generic wait until element is clickable.
    [Arguments]    ${selector}    ${locator_type}=xpath    ${timeout}=15
    Custom Library.Wait Until Element Is Clickable    ${selector}    ${locator_type}    ${timeout}


Wait For Page Contains
    [Documentation]    Generic wait until page contains text.
    [Arguments]    ${text}    ${timeout}=15
    Custom Library.Wait Until Page Contains    ${text}    ${timeout}


Click With Retry
    [Documentation]    Click an element with retry logic. Useful for flaky elements.
    [Arguments]    ${selector}    ${locator_type}=xpath    ${retries}=3
    ${success}=    Run Keyword And Return Status
    ...    Custom Library.Click Element    ${selector}    ${locator_type}
    ...    click_count=1
    Run Keyword If    ${not success}
    ...    Click Element With Retry    ${selector}    ${locator_type}    ${retries}


Click Element With Retry
    [Documentation]    Internal helper: retry clicking an element.
    [Arguments]    ${selector}    ${locator_type}=xpath    ${retries}=3
    FOR    ${attempt}    IN RANGE    ${retries}
        ${success}=    Run Keyword And Return Status
        ...    Custom Library.Click Element    ${selector}    ${locator_type}
        ...    click_count=1
        Exit For Loop If    ${success}
        Wait For Element Clickable    ${selector}    ${locator_type}
        Sleep    1
    END


Get And Verify Element Text
    [Documentation]    Get element text and verify it matches expected text.
    [Arguments]    ${selector}    ${expected_text}    ${locator_type}=xpath    ${case_insensitive}=True
    ${actual}=    Custom Library.Get Element Text    ${selector}    ${locator_type}
    Run Keyword If    ${case_insensitive}
    ...    Should Be Equal As Strings Ignoring Case    ${actual}    ${expected_text}
    ...    msg=Expected '${expected_text}' but got '${actual}'
    ...    else=Should Be Equal    ${actual}    ${expected_text}
    ...    msg=Expected '${expected_text}' but got '${actual}'
    [Return]    ${actual}


Type And Verify
    [Documentation]    Type text into field and verify it was entered correctly.
    [Arguments]    ${selector}    ${text}    ${locator_type}=xpath
    Custom Library.Type Text    ${selector}    ${text}    ${locator_type}
    ${value}=    Custom Library.Get Element Value    ${selector}    ${locator_type}
    Should Be Equal    ${value}    ${text}    msg=Typed value '${text}' did not match field value '${value}'


Clear And Type
    [Documentation]    Clear field then type new text.
    [Arguments]    ${selector}    ${text}    ${locator_type}=xpath
    Custom Library.Clear Field    ${selector}    ${locator_type}
    Custom Library.Type Text    ${selector}    ${text}    ${locator_type}


Is Element Present
    [Documentation]    Check if an element is present on the page.
    [Arguments]    ${selector}    ${locator_type}=xpath    ${timeout}=3
    ${present}=    Run Keyword And Return Status
    ...    Custom Library.Wait Until Element Is Visible    ${selector}    ${locator_type}    ${timeout}
    [Return]    ${present}


Get Dynamic Wait Time
    [Documentation]    Calculate dynamic wait time based on environment.
    [Arguments]    ${base_wait}=5    ${env}=dev
    ${wait}=    Set Variable    ${base_wait}
    IF    "${env}" == "uat"
        ${wait}=    Evaluate    ${base_wait} * 1.5
    END
    [Return]    ${wait}
