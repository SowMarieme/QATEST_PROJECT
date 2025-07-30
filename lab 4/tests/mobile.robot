*** Settings ***
Library           AppiumLibrary
Resource          ../resources/common.robot

Suite Setup    Run Keyword    Open Application MyApp
*** Test Cases ***

Open Application and Login
    [Tags]     "init"
    Enter username
    Enter password
    Log In
    Fermer L'application


Création De Produit
    Enter username
    Enter password
    Log In
    Create Product
    Fermer L'application

Afficher Produit
    Enter username
    Enter password
    Log In
    Create Product
    Display Product    ${PRODUCT}
    Fermer L'application
