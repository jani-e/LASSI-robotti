*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Dialogs


*** Variables ***
${CANVAS_URL}=      https://opinto.laurea.fi/canvas.html
${CREDENTIALS}


*** Tasks ***
Minimal task
    Ask Student Credentials
    Open Canvas
 #    [Teardown]    Close Browser


*** Keywords ***
Ask Student Credentials
    Add heading    Otsikko
    Add text    Username?
    Add text input    username
    Add text    Password?
    Add password input    password
    ${INPUTS}=    Run dialog
    Set Global Variable    ${CREDENTIALS}    ${INPUTS}

Open Canvas
    Open Available Browser    ${CANVAS_URL}
    Click Element    xpath://html/body/div[1]/div[3]/a/div
    Input Text    name:UserName    ${CREDENTIALS.username}
    Input Password    name:Password    ${CREDENTIALS.password}
    Click Element    id:submitButton
