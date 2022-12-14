*** Settings ***
Documentation       Template robot main suite.

Library             RPA.Browser.Selenium    auto_close=${FALSE}
Library             RPA.Dialogs
Library             RPA.Desktop
Library             RPA.Desktop.Windows
Library             Collections
Library             OperatingSystem
Library             RPA.PDF
Library             TxtToPDFConverter
Library             RPA.FileSystem


*** Variables ***
${CREDENTIALS}
@{STATUS}
${ROBOT_FILES}=             ${OUTPUT_DIR}${/}robot_files
${CANVAS_URL}=              https://canvas.laurea.fi/login/35
${LAUREA_INTRANET_URL}=     https://laureauas.sharepoint.com/sites/Opiskelijaintranet
${LAUREABAR_URL}=           https://fi.jamix.cloud/apps/menu/?anro=97090
${ITEWIKI_URL}=             https://www.itewiki.fi/it-rekry


*** Tasks ***
Ask Student Credentials
    ${process_status}=    Set Variable    Ask Student Credentials: Success
    TRY
        Open dialog and ask credentials
    EXCEPT    AS    ${error_message}
        ${process_status}=    Set Variable    Ask Student Credentials: Failed
    FINALLY
        Append To List    ${STATUS}    ${process_status}
    END

Open Canvas and save task due dates
    #Open dialog and ask credentials    #testausta varten: ota kommentti pois ja run
    ${process_status}=    Set Variable    Save Canvas task due dates: Success
    TRY
        Log in to Canvas
        Navigate to calendar
        Take screenshot
        Log out from Canvas
    EXCEPT    AS    ${error_message}
        ${process_status}=    Set Variable    Save Canvas task due dates: Failed
    FINALLY
        Append To List    ${STATUS}    ${process_status}
    END
    [Teardown]    Close Browser

Open Intranet and save News
    #Open dialog and ask credentials    #testausta varten: ota kommentti pois ja run
    ${process_status}=    Set Variable    Save Intranet News: Success
    TRY
        Log in to Intranet
        Save Intranet News
        Log out from intranet
    EXCEPT    AS    ${error_message}
        ${process_status}=    Set Variable    Save Intranet News: Failed
    FINALLY
        Append To List    ${STATUS}    ${process_status}
    END
    [Teardown]    Close Browser

Navigate to BarLaurea and save lunch menu
    ${process_status}=    Set Variable    Save Lunch menu: Success
    TRY
        Navigate to lunch menu
        Save lunch menu
        Convert Lunch Text File to PDF
    EXCEPT    AS    ${error_message}
        ${process_status}=    Set Variable    Save Lunch menu: Failed
    FINALLY
        Append To List    ${STATUS}    ${process_status}
    END
    [Teardown]    Close Browser

Navigate to Itewiki and Find Jobs
    ${process_status}=    Set Variable    Save Itewiki Jobs: Success
    TRY
        Navigate to Itewiki
        Choose RPA Jobs
        Save Job Results to a File
        Convert Job Text File to PDF
    EXCEPT    AS    ${error_message}
        ${process_status}=    Set Variable    Save Itewiki Jobs: Failed
    FINALLY
        Append To List    ${STATUS}    ${process_status}
    END
    [Teardown]    Close Browser

Compile collected data to PDF
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
    Wait Until Element Is Visible    id=idDiv_SAOTCAS_Title
    Add heading    Laurea Authenticator Required
    Add text    Press close once authenticator is successful.
    Run dialog
    Wait Until Element Is Visible    id=idBtn_Back
    Click Element    id=idBtn_Back

Save Intranet News
    Wait Until Element Is Visible    class=ms-NewsItem
    ${LIST}=    Get WebElements    class=ms-NewsItem
    ${index}=    Set Variable    1
    FOR    ${element}    IN    @{LIST}
        Scroll Element Into View    ${element}
        Capture Element Screenshot    ${element}
        ...    ${ROBOT_FILES}${/}uutinen${index}.png
        ${index}=    Evaluate    ${index} + 1
    END

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

    OperatingSystem.Create File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt
    OperatingSystem.Append To File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    Lounas Menu - BarLaurea\n\n

    FOR    ${INDEX}    IN RANGE    0    4
        ${TITLE}=    Get From List    ${TITLES}    ${INDEX}
        ${FOOD}=    Get From List    ${FOODS}    ${INDEX}
        ${TITLE_TEXT}=    RPA.Browser.Selenium.Get Text    ${TITLE}
        ${FOOD_TEXT}=    RPA.Browser.Selenium.Get Text    ${FOOD}
        OperatingSystem.Append To File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    ${TITLE_TEXT}
        OperatingSystem.Append To File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    \n
        OperatingSystem.Append To File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    ${FOOD_TEXT}
        OperatingSystem.Append To File    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    \n
    END

Convert Lunch Text File to PDF
    Convert Txt To Pdf    ${ROBOT_FILES}${/}ruokalistat${/}menu.txt    ${ROBOT_FILES}${/}menu.pdf

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
    OperatingSystem.Create File    ${ROBOT_FILES}${/}jobs.txt
    OperatingSystem.Append To File    ${ROBOT_FILES}${/}jobs.txt    Ty??paikat\n\n
    FOR    ${element}    IN    @{elements}
        ${text}=    RPA.Browser.Selenium.Get Text    ${element}
        OperatingSystem.Append To File    ${ROBOT_FILES}${/}jobs.txt    ${text}
    END

Convert Job Text File to PDF
    Convert Txt To Pdf    ${ROBOT_FILES}${/}jobs.txt    ${ROBOT_FILES}${/}jobs.pdf

Compile Final PDF
    ${process_status}=    Set Variable    Compile Final PDF: Success
    TRY
        ${files}=    RPA.FileSystem.List Files In Directory    ${ROBOT_FILES}
        FOR    ${file}    IN    @{files}
            ${absolute_path}=    Absolute Path    ${file}
        END
        Add Files To Pdf    ${files}    ${OUTPUT_DIR}${/}info.pdf
    EXCEPT    AS    ${error_message}
        ${process_status}=    Set Variable    Compile Final PDF: Failed
    FINALLY
        Append To List    ${STATUS}    ${process_status}
    END

Open PDF to User
    ${process_status}=    Set Variable    Open PDF to User: Success
    TRY
        RPA.Desktop.Windows.Open File    ${OUTPUT_DIR}${/}info.pdf
    EXCEPT    AS    ${error_message}
        ${process_status}=    Set Variable    Open PDF to User: Failed
    FINALLY
        Append To List    ${STATUS}    ${process_status}
    END

Show Robot Success Dialog
    Add heading    Robot tasks finished!
    FOR    ${text}    IN    @{STATUS}
        Add text    ${text}
    END
    Run dialog
