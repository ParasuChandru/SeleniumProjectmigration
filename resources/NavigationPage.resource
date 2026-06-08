*** Settings ***
Documentation    Navigation Page Object resource.
...              Contains all keywords for navigating through the application.
...              Follows Page Object Model (POM) pattern.
Library          CustomLibrary    WITH NAME    Custom


*** Keywords ***
Click Breadcrumb Item
    [Documentation]    Click a breadcrumb navigation item.
    [Arguments]    ${index}=0
    Custom Library.Click Element    xpath://nav[contains(@class, 'breadcrumb')]//a[${int(index) + 1}]


Get Breadcrumb Text
    [Documentation]    Get the full breadcrumb trail as text.
    [Return]    ${text}
    ${text}=    Custom Library.Get Element Text    xpath://nav[contains(@class, 'breadcrumb')]
    [Return]    ${text}


Click Sidebar Item
    [Documentation]    Click a sidebar navigation item.
    [Arguments]    ${item_text}
    Custom Library.Click Element    xpath://aside[contains(@class, 'sidebar')]//a[contains(text(), '${item_text}')]


Get Sidebar Items
    [Documentation]    Get all sidebar navigation items.
    [Return]    ${items}
    ${items}=    Custom Library.Get All Elements Text    xpath://aside[contains(@class, 'sidebar')]//a
    [Return]    ${items}


Click Menu Item
    [Documentation]    Click a main menu item.
    [Arguments]    ${item_text}
    Custom Library.Click Element    xpath://li[contains(@class, 'menu-item') or contains(@class, 'nav-item')]//a[contains(text(), '${item_text}')]


Open Dropdown Menu
    [Documentation]    Open a dropdown menu by clicking its trigger.
    [Arguments]    ${trigger_selector}    ${locator_type}=xpath
    Custom Library.Click Element    ${trigger_selector}    ${locator_type}


Select Dropdown Item
    [Documentation]    Select an item from an opened dropdown menu.
    [Arguments]    ${item_text}
    Custom Library.Click Element    xpath://li[contains(@class, 'dropdown-item')]//a[contains(text(), '${item_text}')]


Verify Dropdown Is Open
    [Documentation]    Verify that a dropdown menu is visible (open).
    [Arguments]    ${selector}    ${locator_type}=xpath
    Custom Library.Verify Element Is Visible    ${selector}    ${locator_type}


Close Modal
    [Documentation]    Close a modal dialog.
    Custom Library.Click Element    xpath://button[contains(@aria-label, 'close') or contains(text(), 'Close') or contains(@data-testid, 'close')]


Is Modal Open
    [Documentation]    Check if a modal dialog is currently open.
    [Return]    ${result}
    ${result}=    Run Keyword And Return Status
    ...    Custom Library.Verify Element Is Visible    xpath://div[contains(@class, 'modal') or contains(@data-testid, 'modal')]
    [Return]    ${result}


Click Tab
    [Documentation]    Click a tab to switch to that tab.
    [Arguments]    ${tab_text}
    Custom Library.Click Element    xpath://div[contains(@class, 'tabs')]//a[contains(@class, 'tab') and contains(text(), '${tab_text}')]


Verify Tab Is Active
    [Documentation]    Verify that a specific tab is the active tab.
    [Arguments]    ${tab_text}
    Custom Library.Verify Element Is Visible    xpath://div[contains(@class, 'tabs')]//a[contains(@class, 'tab') and contains(text(), '${tab_text}') and contains(@class, 'active')]


Is Tab Active
    [Documentation]    Check if a specific tab is active.
    [Arguments]    ${tab_text}
    [Return]    ${result}
    ${result}=    Run Keyword And Return Status
    ...    Custom Library.Verify Element Is Visible    xpath://div[contains(@class, 'tabs')]//a[contains(@class, 'tab') and contains(text(), '${tab_text}') and contains(@class, 'active')]
    [Return]    ${result}


Click Table Row
    [Documentation]    Click a specific row in a data table.
    [Arguments]    ${row_index}=1
    Custom Library.Click Element    xpath://table//tbody//tr[${int(row_index)}]


Click Table Cell
    [Documentation]    Click a specific cell in a data table.
    [Arguments]    ${row_index}=1    ${col_index}=1
    Custom Library.Click Element    xpath://table//tbody//tr[${int(row_index)}]/td[${int(col_index)}]


Get Table Header Texts
    [Documentation]    Get all table header texts.
    [Return]    ${headers}
    ${headers}=    Custom Library.Get All Elements Text    xpath://table//thead//th
    [Return]    ${headers}


Get Table Row Count
    [Documentation]    Get the number of rows in the data table.
    [Return]    ${count}
    ${count}=    Custom Library.Get Number Of Elements    xpath://table//tbody//tr
    [Return]    ${count}


Click Pagination Button
    [Documentation]    Click a pagination button by its text.
    [Arguments]    ${page_text}
    Custom Library.Click Element    xpath://div[contains(@class, 'pagination')]//a[contains(text(), '${page_text}')]


Click Sort Column
    [Documentation]    Click a sortable column header to sort.
    [Arguments]    ${column_text}
    Custom Library.Click Element    xpath://th[contains(@class, 'sortable') and contains(text(), '${column_text}')]


Click Filter Button
    [Documentation]    Click the filter button in a data grid.
    Custom Library.Click Element    xpath://button[contains(@class, 'filter') or contains(text(), 'Filter')]


Click Export Button
    [Documentation]    Click the export button in a data grid.
    Custom Library.Click Element    xpath://button[contains(@class, 'export') or contains(text(), 'Export')]


Wait For Page To Load
    [Documentation]    Wait for page navigation to complete.
    [Arguments]    ${timeout}=15
    Custom Library.Wait Until Element Is Visible    id=dashboard    css    ${timeout}


Navigate To URL
    [Documentation]    Navigate directly to a URL.
    [Arguments]    ${url}
    Custom Library.Go To    ${url}
