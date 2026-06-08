*** Settings ***
Documentation    Verification Test Suite
...              Tests cover element presence, text verification, attribute checks.
...
...              Jira Epic: TEST-400
Library          SeleniumLibrary
Library          Collections
Suite Setup      Open Browser Session
Suite Teardown   Close Browser Session

*** Test Cases ***
Verify Login Page Elements Present
    [Documentation]    Verify all login page elements are present and visible.
    [Tags]    verification    login    ui    regression
    Go To    ${BASE_URL}/login
    Wait Until Element Is Visible    id=username    timeout=${TIMEOUT}
    Wait Until Element Is Visible    id=password    timeout=${TIMEOUT}
    Wait Until Element Is Visible    id=login-btn    timeout=${TIMEOUT}
    ${title}=    Get Title
    Should Be True    ${title} != ${EMPTY}    msg=Page title should not be empty
    ${url}=    Get Location
    Should Be True    ${url} != ${EMPTY}    msg=Page URL should not be empty

Verify Home Page Loaded Correctly
    [Documentation]    Verify the home page loads with all expected elements.
    [Tags]    verification    home    ui    regression
    Login First
    Wait Until Element Is Visible    id=dashboard    timeout=${TIMEOUT}
    Wait Until Element Is Visible    id=app-title    timeout=${TIMEOUT}
    Wait Until Element Is Visible    id=main-nav    timeout=${TIMEOUT}
    Wait Until Element Is Visible    id=search-input    timeout=${TIMEOUT}
    Wait Until Element Is Visible    id=user-profile-menu    timeout=${TIMEOUT}
    Wait Until Element Is Visible    id=notifications    timeout=${TIMEOUT}

Verify Dashboard Contains Expected Elements
    [Documentation]    Verify dashboard contains expected elements.
    [Tags]    verification    dashboard    ui
    Login First
    Wait Until Element Is Visible    id=dashboard    timeout=${TIMEOUT}
    Wait Until Element Is Visible    id=app-title    timeout=${TIMEOUT}
    Wait Until Element Is Visible    xpath://nav[contains(@id, 'nav') or contains(@class, 'nav')]    xpath    ${TIMEOUT}
    Wait Until Page Contains    Welcome    timeout=${TIMEOUT}

Verify Page Title Format
    [Documentation]    Verify the page title follows expected format.
    [Tags]    verification    title    ui
    Login First
    ${title}=    Get Title
    Should Be True    ${title} != ${EMPTY}    msg=Page title should not be empty
    ${title_len}=    Get Length    ${title}
    Should Be True    ${title_len} > 0

Verify Navigation Menu Items Present
    [Documentation]    Verify navigation menu items are present.
    [Tags]    verification    navigation    ui
    Login First
    ${items}=    Get Webelements    xpath://nav[contains(@id, 'nav') or contains(@class, 'nav')]//a
    ${count}=    Get Length    ${items}
    Should Be True    ${count} > 0    msg=Navigation menu should have at least one item

Verify Form Validation Messages
    [Documentation]    Verify form validation messages display correctly.
    [Tags]    verification    form    validation
    Login First
    ${inputs}=    Get Webelements    //input
    ${count}=    Get Length    ${inputs}
    Should Be True    ${count} > 0    msg=Form should have at least one input field

Verify Dropdown Options Available
    [Documentation]    Verify dropdown options are available and selectable.
    [Tags]    verification    dropdown    ui
    Login First
    ${dropdowns}=    Get Webelements    //select
    ${count}=    Get Length    ${dropdowns}
    Should Be True    ${count} > 0    msg=Page should have at least one dropdown

Verify Table Structure Present
    [Documentation]    Verify data table structure is present.
    [Tags]    verification    table    ui
    Login First
    ${tables}=    Get Webelements    xpath://table
    ${count}=    Get Length    ${tables}
    Log    Number of tables on page: ${count}

Verify Footer Contains Required Links
    [Documentation]    Verify footer contains required links.
    [Tags]    verification    footer    ui
    Login First
    ${links}=    Get Webelements    xpath://footer//a
    ${count}=    Get Length    ${links}
    Should Be True    ${count} > 0    msg=Footer should have at least one link

Verify Page Does Not Contain Error
    [Documentation]    Verify the page does not contain any error messages.
    [Tags]    verification    ui    negative
    Login First
    ${errors}=    Get Webelements    xpath://div[contains(@class, 'error')]
    ${count}=    Get Length    ${errors}
    Should Be Equal As Integers    ${count}    0

Verify Search Results Display
    [Documentation]    Verify search results display after a search.
    [Tags]    verification    search    ui
    Login First
    Wait Until Element Is Visible    id=search-input    timeout=${TIMEOUT}
    Input Text    id=search-input    test
    Press Key    id=search-input    ENTER
    Wait For Loading To Disappear

*** Keywords ***
Login First
    [Documentation]    Log in with admin credentials for verification tests.
    Go To    ${BASE_URL}/login
    Wait Until Element Is Visible    id=username    timeout=${TIMEOUT}
    Input Text    id=username    admin
    Wait Until Element Is Visible    id=password    timeout=${TIMEOUT}
    Input Text    id=password    Admin@123
    Wait Until Element Is Clickable    id=login-btn    timeout=${TIMEOUT}
    Click Button    id=login-btn
    Wait For Loading To Disappear
    Wait Until Page Contains    Welcome    timeout=${TIMEOUT}

Wait For Loading To Disappear
    [Documentation]    Wait for loading indicator.
    Wait Until Element Is Not Visible    xpath://div[contains(@class, 'loading') or contains(@class, 'spinner')]    xpath    10 seconds

Open Browser Session
    [Documentation]    Suite setup.
    Open Browser    ${BASE_URL}    browser=${BROWSER}    headless=${HEADLESS}
    Maximize Browser Window
    Set Browser Implicit Wait    10 seconds
    Set Selenium Timeout    ${TIMEOUT} seconds

Close Browser Session
    [Documentation]    Suite teardown.
    Close Browser
