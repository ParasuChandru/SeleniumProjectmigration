*** Variables ***
${BASE_URL}    https://example.com
${BROWSER}    chrome
${HEADLESS}    True
${TIMEOUT}    15

*** Settings ***
Library          SeleniumLibrary
Suite Setup      Open Browser Session
Suite Teardown   Close Browser Session

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
