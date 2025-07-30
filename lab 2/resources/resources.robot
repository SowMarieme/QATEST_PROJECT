*** Settings ***
Library    SeleniumLibrary
Library    Dialogs
Variables   ../po/variable.py
Variables   ../po/locator.py


*** Keywords ***
Open web browser
    Open Browser    ${URL_AUTOMATION}    ${Browser}
    Maximize Browser Window
    Set Selenium Speed    0.3s
    Set Selenium Timeout  10s
Verifier Page Accueil
    Page Should Contain     Customers Are Priority One!
    Sleep    2
Naviguer vers la page de formulaire
    Wait Until Element Is Visible    id=${id_SignIn}    10s
    Click Element    id=${id_SignIn}
Laisser les champs vides
    No Operation
    # Ne rien faire ici volontairement
Saisir le identifiant
    Input Text       ${id_textbox_username}    ${USERNAME_AUTOMATION}
    Input Password   ${id_textbox_password}    ${PASSWORD_AUTOMATION}
Cocher la case Remember me
    Select Checkbox    ${id_checkbox_remember}
Cliquer Sur Connexion
    Click Button     ${name_btn_submit}
    Sleep            2

Se déconnecter
    Click Element    ${link_logout}
    Wait Until Page Contains    Signed Out
Vérifier page de déconnexion
    Location Should Be    https://automationplayground.com/crm/sign-out.html
    Page Should Contain    Signed Out

Revenir a la page de connexion
    Click Element    ${link_login}
    Wait Until Page Contains     Login

Vérifier que l'e-mail est pré-rempli
    Element Attribute Value Should Be    ${id_textbox_username}    value    ${USERNAME_AUTOMATION}

# cas non saisi des identifiants
Vérifier que l'utilisateur n'est pas connecté
    Page Should Contain    Email
    Page Should Contain    Password
    Page Should Not Contain    Our Happy Customers
Acceder a l'accueil
    Page Should Contain     Our Happy Customers
    Sleep    2

Vérifier présence de plusieurs clients
    # On attend que la table soit visible
    Wait Until Element Is Visible     ${xpath_table}   5s
    ${rows}=    Get Element Count     ${xpath_line_customer}
    Log    Nombre de lignes trouvées : ${rows}
    Should Be True    ${rows} > 1

Ouvrir le formulaire d'ajout
    Click Element     id=${new_Customer}
    Sleep     2
Type customer email
    Input Text       ${id_textbox_email}    ${CUSTOMER_EMAIL}
    Sleep    2
Type customer first name
    Input Text       ${id_textbox_first_name}    ${CUSTOMER_FIRST_NAME}
    Sleep    2
Type customer last name
    Input Text    ${id_textbox_last_name}        ${CUSTOMER_LAST_NAME}
    Sleep    2
Type customer city
    Input Text    ${id_City}        ${CUSTOMER_City}
    Sleep    2
Select customer state
    Select From List By Index   id=${id_StateOrRegion}    5
Select gender
    Click Element     xpath=${xpath_Gender}
    Sleep    2
Optionally check promotion checkbox
    Click Element     xpath=//*[@id="loginform"]/div/div/div/div/form/div[7]/input
    Sleep    2
Click "Submit" button
    Click Button     xpath=${xpath_btn_submit}
    Sleep    2
    Page Should Contain     Success! New customer added.
    Sleep    2

Cliquer sur le bouton Annuler
    Wait Until Element Is Visible    ${link_cancel}    5s
    Click Element                    ${link_cancel}
    Sleep                            1s

Vérifier retour sur la page des clients
    Page Should Contain              Customers


Close web browser
    Close Browser



