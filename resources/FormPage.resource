*** Settings ***
Documentation    Form Page Object resource.
...              Contains all keywords for form interactions.
...              Follows Page Object Model (POM) pattern.
Library          CustomLibrary    WITH NAME    Custom


*** Keywords ***
Fill Text Field
    [Documentation]    Fill a text input field with the given value.
    [Arguments]    ${selector}    ${value}    ${locator_type}=xpath
    Custom Library.Type Text    ${selector}    ${value}    ${locator_type}


Fill Text Area
    [Documentation]    Fill a textarea with the given value.
    [Arguments]    ${selector}    ${value}    ${locator_type}=xpath
    Custom Library.Type Text    ${selector}    ${value}    ${locator_type}


Select From Dropdown By Text
    [Documentation]    Select a dropdown option by visible text.
    [Arguments]    ${selector}    ${text}    ${locator_type}=xpath
    Custom Library.Select Dropdown By Text    ${selector}    ${text}    ${locator_type}


Select From Dropdown By Value
    [Documentation]    Select a dropdown option by value attribute.
    [Arguments]    ${selector}    ${value}    ${locator_type}=xpath
    Custom Library.Select Dropdown By Value    ${selector}    ${value}    ${locator_type}


Select From Dropdown By Index
    [Documentation]    Select a dropdown option by index.
    [Arguments]    ${selector}    ${index}    ${locator_type}=xpath
    Custom Library.Select Dropdown By Index    ${selector}    ${index}    ${locator_type}


Get All Dropdown Options
    [Documentation]    Get all options available in a dropdown.
    [Arguments]    ${selector}    ${locator_type}=xpath
    [Return]    ${options}
    ${options}=    Custom Library.Get Dropdown Options    ${selector}    ${locator_type}
    [Return]    ${options}


Get Selected Dropdown Value
    [Documentation]    Get the currently selected value of a dropdown.
    [Arguments]    ${selector}    ${locator_type}=xpath
    [Return]    ${selected}
    ${selected}=    Custom Library.Get Dropdown Selected Option    ${selector}    ${locator_type}
    [Return]    ${selected}


Check Checkbox Field
    [Documentation]    Check a checkbox field.
    [Arguments]    ${selector}    ${locator_type}=xpath
    Custom Library.Check Checkbox    ${selector}    ${locator_type}


Uncheck Checkbox Field
    [Documentation]    Uncheck a checkbox field.
    [Arguments]    ${selector}    ${locator_type}=xpath
    Custom Library.Uncheck Checkbox    ${selector}    ${locator_type}


Is Checkbox Checked
    [Documentation]    Check if a checkbox is checked.
    [Arguments]    ${selector}    ${locator_type}=xpath
    [Return]    ${result}
    ${result}=    Custom Library.Is Checkbox Checked    ${selector}    ${locator_type}
    [Return]    ${result}


Select Radio Button
    [Documentation]    Select a radio button option.
    [Arguments]    ${selector}    ${locator_type}=xpath
    Custom Library.Radio Button Select    ${selector}    ${locator_type}


Is Radio Button Selected
    [Documentation]    Check if a radio button is selected.
    [Arguments]    ${selector}    ${locator_type}=xpath
    [Return]    ${result}
    ${result}=    Custom Library.Is Radio Button Selected    ${selector}    ${locator_type}
    [Return]    ${result}


Click Submit Button
    [Documentation]    Click the form submit button.
    [Arguments]    ${selector}=xpath://button[@type='submit']    ${locator_type}=xpath
    Custom Library.Click Element    ${selector}    ${locator_type}


Click Reset Button
    [Documentation]    Click the form reset button.
    [Arguments]    ${selector}=xpath://button[@type='reset' or contains(text(), 'Reset')]    ${locator_type}=xpath
    Custom Library.Click Element    ${selector}    ${locator_type}


Upload File
    [Documentation]    Upload a file to the form file input.
    [Arguments]    ${selector}    ${file_path}    ${locator_type}=xpath
    Custom Library.Upload File    ${selector}    ${file_path}    ${locator_type}


Get Field Label
    [Documentation]    Get the label text for a form field.
    [Arguments]    ${field_selector}    ${locator_type}=xpath
    [Return]    ${label}
    ${label}=    Custom Library.Get Element Attribute    ${field_selector}    aria-label    ${locator_type}
    [Return]    ${label}    ELSE    ${label}=    Custom Library.Get Element Attribute    ${field_selector}    placeholder    ${locator_type}
    [Return]    ${label}


Get Validation Error Message
    [Documentation]    Get validation error message text.
    [Arguments]    ${selector}=xpath://div[contains(@class, 'error') or contains(@class, 'invalid') or contains(@class, 'warning')]    ${locator_type}=xpath
    [Return]    ${error}
    ${error}=    Custom Library.Get Element Text    ${selector}    ${locator_type}
    [Return]    ${error}


Get Success Message
    [Documentation]    Get the form success message text.
    [Arguments]    ${selector}=xpath://div[contains(@class, 'success') or contains(@class, 'confirm')]    ${locator_type}=xpath
    [Return]    ${message}
    ${message}=    Custom Library.Get Element Text    ${selector}    ${locator_type}
    [Return]    ${message}


Verify Form Success
    [Documentation]    Verify that form submission was successful.
    [Arguments]    ${expected_message}=Form submitted successfully
    Custom Library.Verify Element Contains Text    xpath://div[contains(@class, 'success') or contains(@class, 'confirm')]    ${expected_message}


Verify Form Validation Error
    [Documentation]    Verify that a validation error is displayed.
    [Arguments]    ${expected_error}
    Custom Library.Verify Element Contains Text    xpath://div[contains(@class, 'error') or contains(@class, 'invalid')]    ${expected_error}


Is Validation Error Visible
    [Documentation]    Check if a validation error is visible.
    [Return]    ${result}
    ${result}=    Run Keyword And Return Status
    ...    Custom Library.Verify Element Is Visible    xpath://div[contains(@class, 'error') or contains(@class, 'invalid')]
    [Return]    ${result}


Is Success Message Visible
    [Documentation]    Check if success message is visible.
    [Return]    ${result}
    ${result}=    Run Keyword And Return Status
    ...    Custom Library.Verify Element Is Visible    xpath://div[contains(@class, 'success') or contains(@class, 'confirm')]
    [Return]    ${result}


Wait For Field To Be Visible
    [Documentation]    Wait until a form field becomes visible.
    [Arguments]    ${selector}    ${timeout}=15
    Custom Library.Wait Until Element Is Visible    ${selector}    ${timeout}


Clear All Fields
    [Documentation]    Clear all input fields on a form.
    [Arguments]    ${container_selector}=xpath://form    ${container_type}=xpath
    ${fields}=    Custom Library.Get All Elements Text    ${container_selector}    ${container_type}
    FOR    ${input_el}    IN    ${container_selector}//input
        Run Keyword And Ignore Error    Custom Library.Click Element    ${input_el}
    END
