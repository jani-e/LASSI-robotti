*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Dialogs


*** Variables ***
${CANVAS_URL}=              https://opinto.laurea.fi/canvas.html
${LAUREA_INTRANET_URL}=     https://laureauas.sharepoint.com/sites/Opiskelijaintranet
${LAUREABAR_URL}=           https://fi.jamix.cloud/apps/menu/?anro=97090
${CREDENTIALS}


*** Tasks ***
Ask Student Credentials
    Open dialog and ask credentials

 Open Canvas and save task due dates
    Log in to Canvas
    Navigate to calendar
    Take screenshot
    #Log out from Canvas    #    EI TOIMI

 #    [Teardown]    Close Browser

Open Intranet, save News and Lunch menu
    Log in to Intranet
    Navigate to news
    Save Intranet News
    Log out from intranet
    Navigate to lunch menu


*** Keywords ***
Open dialog and ask credentials
    Add heading    Otsikko
    Add text    Username?
    Add text input    username
    Add text    Password?
    Add password input    password
    ${INPUTS}=    Run dialog
    Set Log Level    NONE
    Set Global Variable    ${CREDENTIALS}    ${INPUTS}
    Set Log Level    INFO

Log in to Canvas
    Open Available Browser    ${CANVAS_URL}
    Click Element    xpath://html/body/div[1]/div[3]/a/div
    Input Text    name:UserName    ${CREDENTIALS.username}
    Set Log Level    NONE
    Input Password    name:Password    ${CREDENTIALS.password}
    Set Log Level    INFO
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
    #Wait Until Element Is Visible    class=fOyUs_bGBk fOyUs_fKyb fOyUs_cuDs fOyUs_cBHs fOyUs_eWbJ fOyUs_fmDy fOyUs_eeJl fOyUs_cBtr fOyUs_fuTR fOyUs_cnfU fQfxa_bGBk

    Click Element    xpath=//*[contains(text(), "Log out")]

Log in to Intranet
    Open Available Browser    ${LAUREA_INTRANET_URL}
    Wait Until Element Is Visible    name=loginfmt
    Input Text    name=loginfmt    ${CREDENTIALS.username}
    Click Element    id=idSIButton9
    Wait Until Element Is Visible    name=Password
    Set Log Level    NONE
    Input Password    name=Password    ${CREDENTIALS.password}
    Set Log Level    INFO
    Click Element    id=submitButton
    Wait Until Element Is Visible    id=idBtn_Back
    Click Element    id=idBtn_Back

Navigate to news
    Click Link    link=Lue lisää uutisia ja tapahtumia uutiskeskuksesta

Save Intranet News
    Wait Until Keyword Succeeds
    ...    5x
    ...    2s
    ...    Capture Element Screenshot
    ...    id=61b21872-b872-4a01-8c48-f65b61b67401
    ...    ${OUTPUT_DIR}${/}intranet.png

Log out from intranet
 #    ${TIMEOUT}=    Set Selenium Timeout    5 seconds
    Wait Until Page Contains Element    id=O365_HeaderRightRegion
    Click Element    id=O365_HeaderRightRegion
    Wait Until Page Contains Element    link=Kirjaudu ulos    20 seconds
    Click Link    link=Kirjaudu ulos
    Wait Until Page Contains Element    id=login_workload_logo_text    20 seconds

Navigate to lunch menu
    Go To    ${LAUREABAR_URL}
