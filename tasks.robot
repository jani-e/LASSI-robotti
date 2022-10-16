*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Dialogs
Library             RPA.Desktop
Library             Collections
Library             OperatingSystem


*** Variables ***
${CREDENTIALS}
${CANVAS_URL}=              https://opinto.laurea.fi/canvas.html
${LAUREA_INTRANET_URL}=     https://laureauas.sharepoint.com/sites/Opiskelijaintranet
${LAUREABAR_URL}=           https://fi.jamix.cloud/apps/menu/?anro=97090
${ITEWIKI_URL}=             https://www.itewiki.fi/it-rekry
${TIMEOUT}=                 Set Selenium Timeout    20 seconds


*** Tasks ***
Ask Student Credentials
    Open dialog and ask credentials

Open Canvas and save task due dates
    Log in to Canvas
    Navigate to calendar
    Take screenshot
    #Log out from Canvas    #    EI TOIMI

 #    [Teardown]    Close Browser

Open Intranet and save News
    Log in to Intranet
    Navigate to news
    Save Intranet News
    Log out from intranet

Navigate to BarLaurea and save lunch menu
    Navigate to lunch menu
    Save lunch menu
    [Teardown]    Close Browser

Navigate to Itewiki and Find a Job
    Navigate to Itewiki
    Choose RPA Jobs
    #Take Screenshots of the Results
    Save Job Results to a File
    [Teardown]    Close Browser


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
    Wait Until Page Contains Element    id=O365_HeaderRightRegion
    Click Element    id=O365_HeaderRightRegion
    Wait Until Page Contains Element    link=Kirjaudu ulos    ${TIMEOUT}
    Click Link    link=Kirjaudu ulos
    Wait Until Page Contains Element    id=login_workload_logo_text    ${TIMEOUT}

Navigate to lunch menu
    Open Available Browser    ${LAUREABAR_URL}
    Wait Until Page Contains Element    class=v-button-caption

Save lunch menu
    ${elements}=    Get WebElements    class=v-button-caption
    ${list}=    Create List

    Create File    ${OUTPUT_DIR}${/}menu.txt

    FOR    ${element}    IN    @{elements}[4:9]
        ${text}=    Get Text    ${element}
        Append To List    ${list}    ${text}
        Append To File    ${OUTPUT_DIR}${/}menu.txt    ${text}
    END

Navigate to Itewiki
    Open Available Browser
    Maximize Browser Window
    Go to    ${ITEWIKI_URL}

Choose RPA Jobs
    Click Button    xpath=//*[@id="search1_form"]/div[2]/div[2]/div/span/div/button
    Click Element    xpath=//*[@id="search1_form"]/div[2]/div[2]/div/span/div/ul/li[23]/a/label
    Click Element    xpath=//*[@id="job-date-switch-holder"]/div/label[1]
    Click Element    xpath=//*[@id="search1"]/div[2]/div/a[2]

# Take Screenshots of the Results
#     Wait Until Element Is Visible    xpath=/html/body/div[2]/div/div/div[2]/div[4]/div/div[2]
#     # Capture Element Screenshot    xpath=/html/body/div[2]/div/div/div[2]/div[4]/div/div[2]
#     # ...    ${OUTPUT_DIR}${/}itewiki.png
#     ${LIST}=    Get WebElements    class=wp_details
#     ${index}=    Set Variable    1
#     FOR    ${element}    IN    @{LIST}
#         Scroll Element Into View    ${element}
#         Capture Element Screenshot    ${element}
#         ...    ${OUTPUT_DIR}${/}ilmoitukset${/}ilmoitus${index}.png
#         ${index}=    Evaluate    ${index} + 1
#     END

Save Job Results to a File
    Wait Until Element Is Visible    xpath=/html/body/div[2]/div/div/div[2]/div[4]/div/div[2]
    ${elements}=    Get WebElements    class=wp_details
    Create File    ${OUTPUT_DIR}${/}jobs.txt
    FOR   ${element}   IN   @{elements}
        ${text}=    Get Text    ${element}
        Append To File    ${OUTPUT_DIR}${/}jobs.txt    ${text}
    END