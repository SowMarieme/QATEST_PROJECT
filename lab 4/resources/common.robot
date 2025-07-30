*** Settings ***
Library           AppiumLibrary
Variables         ../po/variables.py
Variables         ../po/locators.py


*** Keywords ***

Open Application MyApp
    Open Application       ${REMOTE_URL}   platformName=${PLATFORM_NAME}    deviceName=${DEVICE_NAME}    automationName=${AUTOMATION_NAME}    appPackage=${APP_PACKAGE}    appActivity=${APP_ACTIVITY}    noReset=true


Enter username
    Sleep    3s
    Wait Until Element Is Visible    ${USERNAME}    5
    Click Element    ${USERNAME}
    Input Text    ${USERNAME}    johnd

Enter password
    Wait Until Element Is Visible    ${PASSWORD}    5
    Click Element    ${PASSWORD}
    Input Password    ${PASSWORD}    m38rmF$

Log In
    Wait Until Element Is Visible    ${LOGIN}    5
    Click Element    ${LOGIN}
    Wait Until Page Contains Element    ${PAGE_FORM}

Create Product
    Sleep     2s
    Wait Until Element Is Visible    ${FORM_TITLE}    timeout=5s
    Click Element    ${FORM_TITLE}
    Input Text    ${FORM_TITLE}        Rain Jacket Women Windbreaker
    Click Element    ${FORM_PRICE}
    Input Text    ${FORM_PRICE}        39.99
    Click Element    ${FORM_DESCRIPTION}
    Input Text    ${FORM_DESCRIPTION}  Lightweight windbreaker jacket for women. Water-resistant and breathable.
    Click Element    ${FORM_CATEGORIE}
    Input Text    ${FORM_CATEGORIE}    Clothing
    Click Element    ${FORM_URL}
    Input Text    ${FORM_URL}          https://example.com/images/rain-jacket.jpg
    Click Element    ${FORM_BUTTON_ADD}
    Log    ✅ Produit ajouté avec succès

Display Product
    [Arguments]    ${PRODUCT}
    Wait Until Element Is Visible    ${PAGE_LISTE}    timeout=5s
    Element Should Be Visible     ${PAGE_LISTE}
    Wait Until Element Is Visible    ${PRODUCT}    timeout=10s
    Click Element    ${PRODUCT}
    Log    📦 Produit "Mens Cotton Jackets" affiché correctement


Fermer L'application
    Close Application
