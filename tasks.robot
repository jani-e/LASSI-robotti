*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Dialogs


*** Variables ***
${CANVAS_URL}=      https://opinto.laurea.fi/canvas.html
${CREDENTIALS}


*** Tasks ***
Ask Student Credentials
    Open dialog and ask credentials

Open Canvas and save task due dates
    Log in to Canvas
    Navigate to calendar
    Take screenshot
 #    [Teardown]    Close Browser


*** Keywords ***
Open dialog and ask credentials
    Add heading    Otsikko
    Add text    Username?
    Add text input    username
    Add text    Password?
    Add password input    password
    ${INPUTS}=    Run dialog
    Set Global Variable    ${CREDENTIALS}    ${INPUTS}

Log in to Canvas
    Open Available Browser    ${CANVAS_URL}
    Click Element    xpath://html/body/div[1]/div[3]/a/div
    Input Text    name:UserName    ${CREDENTIALS.username}
    Input Password    name:Password    ${CREDENTIALS.password}
    Click Element    id:submitButton

Navigate to calendar
    Click Element    id=global_nav_calendar_link
    Click Button    id=agenda

Take screenshot
    Wait Until Element Is Visible    id=calendar-app
    Capture Element Screenshot    id=calendar-app    ${OUTPUT_DIR}${/}canvas.png
