*** Settings ***
Documentation       Template robot main suite.
Library    RPA.Browser.Selenium    auto_close${FALSE}

*** Variables ***
${CANVAS_URL}=      https://opinto.laurea.fi/canvas.html

*** Tasks ***
Minimal task
    Open Canvas
    [Teardown]    Close Browser

*** Keywords ***
Open Canvas
    Open Available Browser    ${CANVAS_URL}