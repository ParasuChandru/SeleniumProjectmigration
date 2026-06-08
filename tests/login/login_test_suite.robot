*** Settings ***
Documentation    Login Test Suite
...              Tests cover positive and negative login scenarios.
...
...              Jira Epic: TEST-100
Library          SeleniumLibrary
Library          Collections

Suite Setup      Open Browser Session
Suite Teardown   Close Browser Session

*** Variables ***
${LOGIN URL}    ${BASE_URL}/login
${LOGIN USERNAME}    id=username
${LOGIN PASSWORD}    id=password
${LOGIN BUTTON}    id=login-btn
${LOGOUT BUTTON}    id=logout-btn

*** Test Cases ***
Login With Valid Admin Credentials
    [Documentation]    Verify admin user can log in with valid credentials.
    [Tags]    login    smoke    admin    regression
    Open Login Page
    Input Username    admin
    Input Password    Admin@123
    Click Login Button
    Wait For Loading To Disappear
    Page Should Contain    Welcome
    Click Logout Button
    Wait Until Page Contains    Login    timeout=10
    Wait Until Page Contains    Log in    timeout=10

Login With Valid Regular User Credentials
    [Documentation]    Verify regular user can log in with valid credentials.
    [Tags]    login    smoke    user    regression
    Open Login Page
    Input Username    user1
    Input Password    User@123
    Click Login Button
    Wait For Loading To Disappear
    Page Should Contain    Welcome
    Click Logout Button
    Wait Until Page Contains    Login    timeout=10

Login With Valid Premium User Credentials
    [Documentation]    Verify premium user can log in with valid credentials.
    [Tags]    login    premium    user    regression
    Open Login Page
    Input Username    user2
    Input Password    User2@123
    Click Login Button
    Wait For Loading To Disappear
    Page Should Contain    Welcome
    Click Logout Button
    Wait Until Page Contains    Login    timeout=10

Login With Valid Limited User Credentials
    [Documentation]    Verify limited user can log in with valid credentials.
    [Tags]    login    limited    user    regression
    Open Login Page
    Input Username    user3
    Input Password    User3@123
    Click Login Button
    Wait For Loading To Disappear
    Page Should Contain    Welcome
    Click Logout Button
    Wait Until Page Contains    Login    timeout=10

Login With Wrong Password
    [Documentation]    Verify login fails with correct username but wrong password.
    [Tags]    login    negative    validation
    Open Login Page
    Input Username    admin
    Input Password    WrongPassword@123
    Click Login Button
    Wait Until Page Contains    Invalid    timeout=10
    ${error}=    Get Text    xpath://div[contains(@class, 'error') or contains(@class, 'alert')]
    Should Contain    ${error}    Invalid username    case_insensitive=True

Login With Nonexistent User
    [Documentation]    Verify login fails with nonexistent username.
    [Tags]    login    negative    validation
    Open Login Page
    Input Username    nonexistent_user
    Input Password    SomePass@123
    Click Login Button
    Wait Until Page Contains    Invalid    timeout=10

Login With Empty Username
    [Documentation]    Verify login fails when username is empty.
    [Tags]    login    negative    validation    empty-field
    Open Login Page
    Input Password    Admin@123
    Click Login Button
    Wait Until Page Contains    Username    timeout=10

Login With Empty Password
    [Documentation]    Verify login fails when password is empty.
    [Tags]    login    negative    validation    empty-field
    Open Login Page
    Input Username    admin
    Click Login Button
    Wait Until Page Contains    Password    timeout=10

Login With Locked Account
    [Documentation]    Verify login fails for a locked account.
    [Tags]    login    negative    locked-account
    Open Login Page
    Input Username    locked_user
    Input Password    Locked@123
    Click Login Button
    Wait Until Page Contains    locked    timeout=10

Login With Expired Account
    [Documentation]    Verify login fails for an expired account.
    [Tags]    login    negative    expired-account
    Open Login Page
    Input Username    expired_user
    Input Password    Expired@123
    Click Login Button
    Wait Until Page Contains    expired    timeout=10

Login With SQL Injection Username
    [Documentation]    Verify login handles SQL injection attempts safely.
    [Tags]    login    security    sql-injection    negative
    Open Login Page
    Input Username    ' OR 1=1 --
    Input Password    AnyPass@123
    Click Login Button
    Wait Until Page Contains    Invalid    timeout=10

Login With XSS Payload Username
    [Documentation]    Verify login handles XSS attempts safely.
    [Tags]    login    security    xss    negative
    Open Login Page
    Input Username    <script>alert('xss')</script>
    Input Password    AnyPass@123
    Click Login Button
    Wait Until Page Contains    Invalid    timeout=10

Login With Very Long Username
    [Documentation]    Verify login handles extremely long usernames.
    [Tags]    login    negative    edge-case
    Open Login Page
    Input Username    abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz
    Input Password    SomePass@123
    Click Login Button
    Wait For Loading To Disappear

*** Keywords ***
Open Browser Session
    [Documentation]    Suite setup: Open browser and navigate to base URL.
    Open Browser    ${BASE_URL}    browser=${BROWSER}    headless=${HEADLESS}
    Maximize Browser Window
    Set Browser Implicit Wait    10 seconds
    Set Selenium Timeout    ${TIMEOUT} seconds
    Log    Browser session opened for environment: ${ENVIRONMENT}

Close Browser Session
    [Documentation]    Suite teardown: Close the browser.
    Close Browser
    Log    Browser session closed

Open Login Page
    [Documentation]    Open the login page.
    Go To    ${LOGIN URL}

Input Username
    [Documentation]    Enter a username in the login form.
    [Arguments]    ${username}
    Wait Until Element Is Visible    ${LOGIN USERNAME}    timeout=${TIMEOUT}
    Input Text    ${LOGIN USERNAME}    ${username}

Input Password
    [Documentation]    Enter a password in the login form.
    [Arguments]    ${password}
    Wait Until Element Is Visible    ${LOGIN PASSWORD}    timeout=${TIMEOUT}
    Input Text    ${LOGIN PASSWORD}    ${password}

Click Login Button
    [Documentation]    Click the login button to submit the form.
    Wait Until Element Is Clickable    ${LOGIN BUTTON}    timeout=${TIMEOUT}
    Click Button    ${LOGIN BUTTON}

Click Logout Button
    [Documentation]    Click the logout button.
    Wait Until Element Is Visible    ${LOGOUT BUTTON}    timeout=${TIMEOUT}
    Click Element    ${LOGOUT BUTTON}

Wait For Loading To Disappear
    [Documentation]    Wait for loading indicator to disappear.
    Wait Until Element Is Not Visible    xpath://div[contains(@class, 'loading') or contains(@class, 'spinner')]    xpath    10 seconds
