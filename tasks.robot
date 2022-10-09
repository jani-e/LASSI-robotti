*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Dialogs


*** Variables ***
${CANVAS_URL}=      https://opinto.laurea.fi/canvas.html
${LAUREA_INTRANET_URL}=    https://laureauas.sharepoint.com/sites/Opiskelijaintranet
${CREDENTIALS}


*** Tasks ***
Ask Student Credentials
    Open dialog and ask credentials

Open Canvas and save task due dates
    Log in to Canvas
    Navigate to calendar
    Take screenshot
    #Log out from Canvas         #  EI TOIMI

 #    [Teardown]    Close Browser

Open Intranet, save News and Lunch menu
    Log in to Intranet

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
    Wait Until Element Is Visible    id=agenda
    Click Button    id=agenda

Take screenshot
    Wait Until Element Is Visible    id=calendar-app
    Wait Until Keyword Succeeds
    ...    5x
    ...    2s
    ...    Capture Element Screenshot
    ...    id=calendar-app
    ...    ${OUTPUT_DIR}${/}canvas.png

Log out from Canvas
    Click Button    id=global_nav_profile_link
    #Wait Until Element Is Visible     class=fOyUs_bGBk fOyUs_fKyb fOyUs_cuDs fOyUs_cBHs fOyUs_eWbJ fOyUs_fmDy fOyUs_eeJl fOyUs_cBtr fOyUs_fuTR fOyUs_cnfU fQfxa_bGBk

    Click Element    xpath=//*[contains(text(), "Log out")]

Log in to Intranet
    Open Available Browser    ${LAUREA_INTRANET_URL}
    #Input Text    id:i0116    text