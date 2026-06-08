*** Settings ***
Documentation    Login Page Object resource.
...              Contains all keywords related to login page interactions.
...              Follows Page Object Model (POM) pattern.
Library          String


*** Variables ***
${BROWSER}    chrome
${HEADLESS}    True
${TIMEOUT}    15


*** Keywords ***
Open Login Page
    [Documentation]    Open the login page in the browser.
    [Arguments]    ${base_url}=${BASE_URL}
    Custom Library.Open Browser    ${base_url}/login    browser=${BROWSER}    headless=${HEADLESS}


Go To Login Page
    [Documentation]    Navigate to the login page.
    [Arguments]    ${base_url}=${BASE_URL}
    Custom Library.Go To    ${base_url}/login


Enter Username
    [Documentation]    Enter a username in the login form.
    [Arguments]    ${username}
    Custom Library.Type Text    id=username    ${username}
    Custom Library.Wait Until Element Is Clickable    id=username


Enter Password
    [Documentation]    Enter a password in the login form.
    [Arguments]    ${password}
    Custom Library.Type Text    id=password    ${password}
    Custom Library.Wait Until Element Is Clickable    id=password


Click Login Button
    [Documentation]    Click the login button to submit the form.
    Custom Library.Click Element    id=login-btn


Click Login Button Alt
    [Documentation]    Click the login button using alternate locator.
    Custom Library.Click Element    xpath://button[contains(@type, 'submit') or contains(text(), 'Login')]


Click Forgot Password Link
    [Documentation]    Click the forgot password link.
    Custom Library.Click Element    xpath://a[contains(text(), 'Forgot') or contains(text(), 'Password')]


Click Signup Link
    [Documentation]    Click the signup/register link.
    Custom Library.Click Element    xpath://a[contains(text(), 'Sign') or contains(text(), 'Register') or contains(text(), 'Create')]


Check Remember Me
    [Documentation]    Check the remember me checkbox.
    Custom Library.Check Checkbox    id=remember-me


Is Remember Me Checked
    [Documentation]    Check if remember me checkbox is checked.
    [Return]    ${result}
    ${result}=    Custom Library.Is Checkbox Checked    id=remember-me
    [Return]    ${result}


Get Login Error Message
    [Documentation]    Get the error message displayed on the login page.
    [Return]    ${error_text}
    ${error_text}=    Custom Library.Get Element Text    xpath://div[contains(@class, 'error') or contains(@class, 'alert')]
    [Return]    ${error_text}


Is Login Error Visible
    [Documentation]    Check if login error message is visible.
    [Return]    ${result}
    ${result}=    Run Keyword And Return Status
    ...    Custom Library.Verify Element Is Visible    xpath://div[contains(@class, 'error') or contains(@class, 'alert')]
    [Return]    ${result}


Get Welcome Message
    [Documentation]    Get the welcome message after successful login.
    [Return]    ${message}
    ${message}=    Custom Library.Get Element Text    id=welcome-message
    [Return]    ${message}


Is Logout Button Visible
    [Documentation]    Check if the logout button is visible (indicates logged in state).
    [Return]    ${result}
    ${result}=    Run Keyword And Return Status
    ...    Custom Library.Verify Element Is Visible    id=logout-btn
    [Return]    ${result}


Is Logout Button Visible Alt
    [Documentation]    Check if the logout button is visible using alternate locator.
    [Return]    ${result}
    ${result}=    Run Keyword And Return Status
    ...    Custom Library.Verify Element Is Visible    xpath://a[contains(text(), 'Logout') or contains(text(), 'Sign out')]
    [Return]    ${result}


Click Logout Button
    [Documentation]    Click the logout button.
    Custom Library.Click Element    id=logout-btn


Click Logout Button Alt
    [Documentation]    Click the logout button using alternate locator.
    Custom Library.Click Element    xpath://a[contains(text(), 'Logout') or contains(text(), 'Sign out')]


Wait For Loading Indicator To Disappear
    [Documentation]    Wait for loading indicator to disappear after login.
    [Arguments]    ${timeout}=15
    Custom Library.Wait Until Element Is Not Visible    xpath://div[contains(@class, 'loading') or contains(@class, 'spinner')]    xpath    ${timeout}


Wait For Banner Notification
    [Documentation]    Wait for banner/notification to appear.
    [Arguments]    ${timeout}=10
    Custom Library.Wait Until Element Is Visible    xpath://div[contains(@class, 'banner') or contains(@class, 'notification') or contains(@class, 'toast')]    xpath    ${timeout}


Get Page URL
    [Documentation]    Get the current page URL.
    [Return]    ${url}
    ${url}=    Custom Library.Get Current URL
    [Return]    ${url}


Get Page Title
    [Documentation]    Get the current page title.
    [Return]    ${title}
    ${title}=    Custom Library.Get Page Title
    [Return]    ${title}


Close Browser
    [Documentation]    Close the browser.
    Custom Library.Close Browser
