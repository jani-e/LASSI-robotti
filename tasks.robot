*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Dialogs
Library             RPA.Desktop
Library             Collections
Library             OperatingSystem
Library             RPA.PDF
Library             TxtToPDFConverter


*** Variables ***
${CREDENTIALS}
${ROBOT_FILES}=             ${OUTPUT_DIR}${/}robot_files
${CANVAS_URL}=              https://opinto.laurea.fi/canvas.html
${LAUREA_INTRANET_URL}=     https://laureauas.sharepoint.com/sites/Opiskelijaintranet
${LAUREABAR_URL}=           https://fi.jamix.cloud/apps/menu/?anro=97090
${ITEWIKI_URL}=             https://www.itewiki.fi/it-rekry


*** Tasks ***
Ask Student Credentials
    Open dialog and ask credentials

Open Canvas and save task due dates
    #Open dialog and ask credentials    #testausta varten: ota kommentti pois ja run
    Log in to Canvas
    Navigate to calendar
    Take screenshot
    Log out from Canvas
    [Teardown]    Close Browser

Open Intranet and save News
 #    Open dialog and ask credentials    #testausta varten: ota kommentti pois ja run
    Log in to Intranet
 #    Navigate to news
    Save Intranet News
 #    Compile news to a single file
    Log out from intranet
    [Teardown]    Close Browser

Navigate to BarLaurea and save lunch menu
    Navigate to lunch menu
    Save lunch menu
#    Navigate to next lunch menu
#    Save next lunch menu
    [Teardown]    Close Browser

Navigate to Itewiki and Find Jobs
    Navigate to Itewiki
    Choose RPA Jobs
    Save Job Results to a File
    [Teardown]    Close Browser

Convert collected data to PDF
    Convert Txt To Pdf    ${ROBOT_FILES}${/}jobs.txt    ${ROBOT_FILES}${/}jobs.pdf
    Convert Txt To Pdf    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    ${ROBOT_FILES}${/}menu.pdf
    Compile final PDF

Show finished tasks to user
    Open PDF to User
    Show Robot Success Dialog


*** Keywords ***
Open dialog and ask credentials
    Add heading    LASSI requests your Credentials
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
    ...    ${ROBOT_FILES}${/}canvas.png

Log out from Canvas
    Click Button    id=global_nav_profile_link
    Submit Form    dom=document.forms[0]

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

#Navigate to news
    #    Click Link    link=Lue lisää uutisia ja tapahtumia uutiskeskuksesta

Save Intranet News
    Wait Until Keyword Succeeds
    ...    5x
    ...    2s
    ...    Capture Element Screenshot
    ...    id=61b21872-b872-4a01-8c48-f65b61b67401
    ...    ${ROBOT_FILES}${/}intranet.png

Log out from intranet
    Wait Until Page Contains Element    id=O365_HeaderRightRegion
    Click Element    id=O365_HeaderRightRegion
    Wait Until Page Contains Element    id=mectrl_body_signOut
    Click Link    id=mectrl_body_signOut
    Wait Until Page Contains Element    id=login_workload_logo_text

Navigate to lunch menu
    Open Available Browser    ${LAUREABAR_URL}
    Wait Until Page Contains Element    class=v-button-caption

Save lunch menu
    Wait Until Page Contains Element
    ...    xpath=//*[@id="main-view"]/div/div/div[3]/div/div[2]/div/div[7]/div/span/span[2]/span[2]
    ${TITLES}=    Get WebElements    class=multiline-button-caption-text
    ${FOODS}=    Get WebElements    class=item-name

    Create File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt

    FOR    ${INDEX}    IN RANGE    0    4
        ${TITLE}=    Get From List    ${TITLES}    ${INDEX}
        ${FOOD}=    Get From List    ${FOODS}    ${INDEX}
        ${TITLE_TEXT}=    Get Text    ${TITLE}
        ${FOOD_TEXT}=    Get Text    ${FOOD}
        Append To File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    ${TITLE_TEXT}
        Append To File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    \n
        Append To File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    ${FOOD_TEXT}
        Append To File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    \n
    END

#Navigate to next lunch menu
#    Wait Until Element Is Visible    class=date--next
#    Click Element    class=date--next
#    Wait Until Page Contains Element    id=appsmenu-1186092753-overlays

#Save next lunch menu
#    Wait Until Page Contains Element
#    ...    xpath=//*[@id="main-view"]/div/div/div[3]/div/div[2]/div/div[7]/div/span/span[2]/span[2]
#    ${TITLES}=    Get WebElements    class=multiline-button-caption-text
#    ${FOODS}=    Get WebElements    class=item-name

#    Create File    ${OUTPUT_DIR}${/}ruokalistat${/}tomorrow_menu.txt

#    FOR    ${INDEX}    IN RANGE    0    4
#    ${TITLE}=    Get From List    ${TITLES}    ${INDEX}
#    ${FOOD}=    Get From List    ${FOODS}    ${INDEX}
#    ${TITLE_TEXT}=    Get Text    ${TITLE}
#    ${FOOD_TEXT}=    Get Text    ${FOOD}
#    Append To File    ${OUTPUT_DIR}${/}ruokalistat${/}tomorrow_menu.txt    ${TITLE_TEXT}
#    Append To File    ${OUTPUT_DIR}${/}ruokalistat${/}tomorrow_menu.txt    \n
#    Append To File    ${OUTPUT_DIR}${/}ruokalistat${/}tomorrow_menu.txt    ${FOOD_TEXT}
#    Append To File    ${OUTPUT_DIR}${/}ruokalistat${/}tomorrow_menu.txt    \n
#    END

Navigate to Itewiki
    Open Available Browser
    Go to    ${ITEWIKI_URL}

Choose RPA Jobs
    Click Button    xpath=//*[@id="search1_form"]/div[2]/div[2]/div/span/div/button
    Click Element    xpath=//*[@id="search1_form"]/div[2]/div[2]/div/span/div/ul/li[23]/a/label
    Click Element    xpath=//*[@id="job-date-switch-holder"]/div/label[1]
    Click Element    xpath=//*[@id="search1"]/div[2]/div/a[2]

Save Job Results to a File
    Wait Until Element Is Visible    xpath=/html/body/div[2]/div/div/div[2]/div[4]/div/div[2]
    ${elements}=    Get WebElements    class=wp_details
    Create File    ${ROBOT_FILES}${/}jobs.txt
    FOR    ${element}    IN    @{elements}
        ${text}=    Get Text    ${element}
        Append To File    ${ROBOT_FILES}${/}jobs.txt    ${text}
    END

Compile Final PDF
    ${files}=    Create List
    ...    ${ROBOT_FILES}${/}canvas.png
    ...    ${ROBOT_FILES}${/}intranet.png
    ...    ${ROBOT_FILES}${/}menu.pdf
    ...    ${ROBOT_FILES}${/}jobs.pdf
    Add Files To Pdf    ${files}    ${ROBOT_FILES}${/}infodump.pdf

Open PDF to User
    Open File    ${ROBOT_FILES}${/}infodump.pdf

Show Robot Success Dialog
    Add heading    Robot tasks finished!
    Run dialog
