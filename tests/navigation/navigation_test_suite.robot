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
${NAV_TIMEOUT}    ${TIMEOUT}

*** Test Cases ***
Navigate To Home Page
    [Documentation]    Verify navigation to home page works correctly.
    [Tags]    navigation    home    regression
    Login First
    Navigate To    /    Dashboard

Navigate To Settings Page
    [Documentation]    Verify navigation to settings page works correctly.
    [Tags]    navigation    settings
    Login First
    Navigate To    /settings    Settings

Navigate To Profile Page
    [Documentation]    Verify navigation to profile page works correctly.
    [Tags]    navigation    profile
    Login First
    Navigate To    /profile    Profile

Navigate To Dashboard
    [Documentation]    Verify navigation to dashboard page works correctly.
    [Tags]    navigation    dashboard    regression
    Login First
    Navigate To    /dashboard    Dashboard

Navigate To Reports Page
    [Documentation]    Verify navigation to reports page works correctly.
    [Tags]    navigation    reports
    Login First
    Navigate To    /reports    Reports

*** Keywords ***
Navigate To
    [Documentation]    Navigate to a specific page path and verify title.
    [Arguments]    ${target_path}    ${expected_title_part}
    Go To    ${BASE_URL}${target_path}
    Wait Until Page Contains    ${expected_title_part}    timeout=${NAV_TIMEOUT}
    Wait For Loading To Disappear

Login First
    [Documentation]    Helper: Log in with admin credentials.
    Open Login Page
    Input Username    admin
    Input Password    Admin@123
    Click Login Button
    Wait For Loading To Disappear
    Wait Until Page Contains    Welcome    timeout=${TIMEOUT}

Open Login Page
    [Documentation]    Open the login page.
    Go To    ${BASE_URL}/login

Input Username
    [Documentation]    Enter a username.
    [Arguments]    ${username}
    Wait Until Element Is Visible    id=username    timeout=${TIMEOUT}
    Input Text    id=username    ${username}

Input Password
    [Documentation]    Enter a password.
    [Arguments]    ${password}
    Wait Until Element Is Visible    id=password    timeout=${TIMEOUT}
    Input Text    id=password    ${password}

Click Login Button
    [Documentation]    Click login button.
    Wait Until Element Is Clickable    id=login-btn    timeout=${TIMEOUT}
    Click Button    id=login-btn

Click Logout Button
    [Documentation]    Click logout button.
    Wait Until Element Is Visible    id=logout-btn    timeout=${TIMEOUT}
    Click Element    id=logout-btn

Wait For Loading To Disappear
    [Documentation]    Wait for loading indicator.
    Wait Until Element Is Not Visible    xpath://div[contains(@class, 'loading') or contains(@class, 'spinner')]    xpath    10 seconds

Open Browser Session
    [Documentation]    Suite setup.
    Open Browser    ${BASE_URL}    browser=${BROWSER}
    Maximize Browser Window
    Set Browser Implicit Wait    10 seconds
    Set Selenium Timeout    ${TIMEOUT} seconds

Close Browser Session
    [Documentation]    Suite teardown.
    Close Browser
