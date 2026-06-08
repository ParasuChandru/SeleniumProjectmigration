*** Settings ***
Documentation    Navigation Test Suite
...              Tests cover menu interactions, breadcrumbs, tabs, dropdowns.
...
...              Jira Epic: TEST-200
Library          SeleniumLibrary
Library          Collections

Suite Setup      Open Browser Session
Suite Teardown   Close Browser Session

*** Variables ***
${BASE_URL}    https://example.com
${BROWSER}    chrome
${TIMEOUT}    15
${NAV_TIMEOUT}    ${TIMEOUT}

*** Keywords ***
Open Browser Session
    [Documentation]    Suite setup.
    Open Browser    ${BASE_URL}    browser=${BROWSER}
    Maximize Browser Window
    Set Browser Implicit Wait    10 seconds
    Set Selenium Timeout    ${TIMEOUT} seconds

Close Browser Session
    [Documentation]    Suite teardown.
    Close Browser
