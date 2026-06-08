*** Settings ***
Documentation    Home Page Object resource.
...              Contains all keywords related to the home/dashboard page.
...              Follows Page Object Model (POM) pattern.
Library          CustomLibrary    WITH NAME    Custom


*** Keywords ***
Verify Home Page Loaded
    [Documentation]    Verify that the home page has loaded correctly.
    Custom Library.Wait Until Page Contains    Welcome
    Custom Library.Verify Page Does Not Contain    Error


Get Dashboard Panel Text
    [Documentation]    Get the text content of the dashboard panel.
    [Return]    ${text}
    ${text}=    Custom Library.Get Element Text    id=dashboard
    [Return]    ${text}


Get Dashboard Panel Text Alt
    [Documentation]    Get the dashboard panel text using alternate locator.
    [Return]    ${text}
    ${text}=    Custom Library.Get Element Text    xpath://div[contains(@class, 'dashboard') or contains(@data-testid, 'dashboard')]
    [Return]    ${text}


Enter Search Query
    [Documentation]    Enter text into the search bar.
    [Arguments]    ${query}
    Custom Library.Type Text    id=search-input    ${query}


Enter Search Query Alt
    [Documentation]    Enter text into the search bar using alternate locator.
    [Arguments]    ${query}
    Custom Library.Type Text    xpath://input[@placeholder='Search']    ${query}


Click Search
    [Documentation]    Press Enter to execute the search.
    Custom Library.Press Key    id=search-input    ENTER


Wait For Search Results
    [Documentation]    Wait for search results to appear.
    [Arguments]    ${timeout}=10
    Custom Library.Wait Until Element Is Visible    id=search-results    css    ${timeout}


Get Search Results Count
    [Documentation]    Get the number of search results found.
    [Return]    ${count}
    ${count}=    Custom Library.Get Number Of Elements    xpath://div[contains(@id, 'search-result') or contains(@class, 'search-result')]
    [Return]    ${count}


Get Navigation Menu Items
    [Documentation]    Get all navigation menu items as a list of text.
    [Return]    ${texts}
    ${texts}=    Custom Library.Get All Elements Text    xpath://nav[contains(@id, 'nav') or contains(@class, 'nav')]//a
    [Return]    ${texts}


Click Navigation Menu Item
    [Documentation]    Click a navigation menu item by its text.
    [Arguments]    ${item_text}
    Custom Library.Click Element    xpath://nav//a[contains(text(), '${item_text}')]


Verify Header Title
    [Documentation]    Verify the application header title.
    [Arguments]    ${expected}
    Custom Library.Verify Element Contains Text    id=app-title    ${expected}


Click User Profile Dropdown
    [Documentation]    Click the user profile dropdown menu.
    Custom Library.Click Element    id=user-profile-menu


Click Notifications Bell
    [Documentation]    Click the notifications bell icon.
    Custom Library.Click Element    id=notifications


Get Footer Links
    [Documentation]    Get all footer links as text.
    [Return]    ${links}
    ${links}=    Custom Library.Get All Elements Text    xpath://footer//a
    [Return]    ${links}


Verify Footer Contains
    [Documentation]    Verify that the footer contains expected text.
    [Arguments]    ${text}
    Custom Library.Verify Element Contains Text    xpath://footer    ${text}


Open Quick Action
    [Documentation]    Open a quick action / shortcut.
    [Arguments]    ${action_name}
    Custom Library.Click Element    xpath://div[contains(@class, 'quick-actions') or contains(@class, 'shortcuts')]//a[contains(text(), '${action_name}')]


Wait For Page To Load
    [Documentation]    Wait for the main page to be fully loaded.
    [Arguments]    ${timeout}=15
    Custom Library.Wait Until Element Is Visible    id=dashboard    css    ${timeout}


Is Page Interactive
    [Documentation]    Check if the dashboard is interactive (no loading overlay).
    [Return]    ${result}
    ${result}=    Run Keyword And Return Status
    ...    Custom Library.Wait Until Element Is Not Visible    xpath://div[contains(@class, 'overlay') or contains(@class, 'backdrop')]    xpath    3
    [Return]    ${result}

