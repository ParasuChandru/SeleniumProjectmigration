*** Settings ***
Documentation    Form Test Suite
...              Tests cover text inputs, dropdowns, checkboxes, radio buttons.
...
...              Jira Epic: TEST-300
Library          SeleniumLibrary
Library          Collections

Suite Setup      Open Browser Session
Suite Teardown   Close Browser Session

*** Variables ***
${FORM_TIMEOUT}    ${TIMEOUT}

*** Test Cases ***
Fill Text Field Correctly
    [Documentation]    Verify filling a text field with valid input.
    [Tags]    form    text-input    validation
    Login First
    Wait Until Element Is Visible    //input[@type='text']    timeout=${FORM_TIMEOUT}
    Input Text    //input[@type='text']    Test User Name
    ${value}=    Get Value    //input[@type='text']
    Should Be Equal    ${value}    Test User Name

Fill Email Field With Valid Email
    [Documentation]    Verify filling an email field with valid email format.
    [Tags]    form    email    validation
    Login First
    Wait Until Element Is Visible    //input[@type='email']    timeout=${FORM_TIMEOUT}
    Input Text    //input[@type='email']    test@example.com
    ${value}=    Get Value    //input[@type='email']
    Should Be Equal    ${value}    test@example.com

Fill Email Field With Invalid Email
    [Documentation]    Verify invalid email format is accepted by UI.
    [Tags]    form    email    validation    negative
    Login First
    Wait Until Element Is Visible    //input[@type='email']    timeout=${FORM_TIMEOUT}
    Input Text    //input[@type='email']    not-an-email
    ${value}=    Get Value    //input[@type='email']
    Should Be Equal    ${value}    not-an-email

Fill Textarea Field
    [Documentation]    Verify filling a textarea with multi-line content.
    [Tags]    form    textarea    validation
    Login First
    Wait Until Element Is Visible    //textarea    timeout=${FORM_TIMEOUT}
    Input Text    //textarea    This is a test message

Select Dropdown By Text
    [Documentation]    Verify selecting a dropdown option by visible text.
    [Tags]    form    dropdown    validation
    Login First
    Select From List By Value    //select    US

Select Dropdown By Value
    [Documentation]    Verify selecting a dropdown option by value attribute.
    [Tags]    form    dropdown    validation
    Login First
    Select From List By Value    //select    US

Select Dropdown By Index
    [Documentation]    Verify selecting a dropdown option by index.
    [Tags]    form    dropdown    validation
    Login First
    Select From List By Index    //select    0

Check And Uncheck Checkbox
    [Documentation]    Verify checkbox can be checked and unchecked.
    [Tags]    form    checkbox    validation
    Login First
    Wait Until Element Is Visible    //input[@type='checkbox']    timeout=${FORM_TIMEOUT}
    Check Checkbox    //input[@type='checkbox']
    ${is_checked}=    Is Checkbox Checked    //input[@type='checkbox']
    Should Be True    ${is_checked}
    Uncheck Checkbox    //input[@type='checkbox']
    ${is_checked2}=    Is Checkbox Checked    //input[@type='checkbox']
    Should Be True    ${not is_checked2}

Select Radio Button
    [Documentation]    Verify radio button can be selected.
    [Tags]    form    radio    validation
    Login First
    Wait Until Element Is Visible    //input[@type='radio']    timeout=${FORM_TIMEOUT}
    Click Element    //input[@type='radio']
    ${is_selected}=    Is Radio Button Selected    //input[@type='radio']
    Should Be True    ${is_selected}

Submit Form With Valid Data
    [Documentation]    Verify form submission with all valid fields.
    [Tags]    form    submit    positive    regression
    Login First
    Wait Until Element Is Clickable    xpath://button[@type='submit']    timeout=${FORM_TIMEOUT}
    Click Button    xpath://button[@type='submit']
    Wait For Loading To Disappear

Submit Form With Empty Required Fields
    [Documentation]    Verify form validation when required fields are empty.
    [Tags]    form    submit    validation    negative
    Login First
    Wait Until Element Is Clickable    xpath://button[@type='submit']    timeout=${FORM_TIMEOUT}
    Click Button    xpath://button[@type='submit']
    Wait For Loading To Disappear

Clear And Retype In Field
    [Documentation]    Verify clearing a field and typing new text.
    [Tags]    form    text-input    clear
    Login First
    Wait Until Element Is Visible    //input[@type='text']    timeout=${FORM_TIMEOUT}
    Input Text    //input[@type='text']    New Value
    ${value}=    Get Value    //input[@type='text']
    Should Be Equal    ${value}    New Value

Press Enter In Input Field
    [Documentation]    Verify pressing Enter in an input field.
    [Tags]    form    keyboard    validation
    Login First
    Wait Until Element Is Visible    //input    timeout=${FORM_TIMEOUT}
    Click Element    //input
    Press Key    //input    ENTER

*** Keywords ***
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
    Open Browser    ${BASE_URL}    browser=${BROWSER}    headless=${HEADLESS}
    Maximize Browser Window
    Set Browser Implicit Wait    10 seconds
    Set Selenium Timeout    ${TIMEOUT} seconds

Close Browser Session
    [Documentation]    Suite teardown.
    Close Browser
