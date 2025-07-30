** Settings ***
Library           SeleniumLibrary
Library           Dialogs
Variables         ../po/variable.py
Variables         ../po/locator.py
Resource          ../resources/resources.robot

Suite Setup        Open web browser
Suite Teardown    Close web browser
*** Test Cases ***
# Ouvrir la page d'accueil
Cas-de-Test-Id-001
    [Documentation]     Ouvrir la page d'accueil
    Verifier Page Accueil

# Se connecter
Cas-de-Test-Id-002
    [Documentation]     Naviguer vers la page de formulaire
    Naviguer vers la page de formulaire
    Saisir le identifiant
    Cliquer Sur Connexion
    Acceder a l'accueil

# ne pas se connecter quand les identifiants sont vides
Cas-de-Test-Id-003
    [Documentation]     Tester l'échec de connexion avec des identifiants vides
    Naviguer vers la page de formulaire
    Laisser les champs vides
    Cliquer Sur Connexion
    Vérifier que l'utilisateur n'est pas connecté

# Remember me ->l'adresse mail reste quand on se deconnecte
#Cas-de-Test-Id-008
#    [Documentation]     Vérifier que l'option "Remember me" conserve l'e-mail après déconnexion
#    Naviguer vers la page de formulaire
#    Saisir le identifiant
#    Cocher la case Remember me
#    Cliquer Sur Connexion
#    Acceder a l'accueil
#    Se déconnecter
#    Revenir a la page de connexion
#    Vérifier que l'e-mail est pré-rempli
#    Close web browser
#    Comment    Ce test est désactivé car l'option Remember me n'est pas fonctionnelle

# Deconnexion
Cas-de-Test-Id-004
    [Documentation]     Vérifier que la déconnexion fonctionne correctement
    Naviguer vers la page de formulaire
    Saisir le identifiant
    Cliquer Sur Connexion
    Acceder a l'accueil
    Se déconnecter
    Vérifier page de déconnexion

# verifier et compter les clients
Cas-de-Test-Id-005
    [Documentation]     Vérifier que la page clients contient plusieurs enregistrements
    Naviguer vers la page de formulaire
    Saisir le identifiant
    Cliquer Sur Connexion
    Vérifier présence de plusieurs clients

# Se connecter et Ajouter un nouveau client
Cas-de-Test-Id-006
    [Documentation]     Ouvrir le formulaire d'ajout et ajouter un client
    Naviguer vers la page de formulaire
    Saisir le identifiant
    Cliquer Sur Connexion
    Acceder a l'accueil
    Ouvrir le formulaire d'ajout
    Type customer email
    Type customer first name
    Type customer last name
    Type customer city
    Select customer state
    Select gender
    Optionally check promotion checkbox
    Click "Submit" button

Cas-de-Test-Id-007
    [Documentation]     Vérifier que l'utilisateur peut annuler l'ajout d'un client
    Naviguer vers la page de formulaire
    Saisir le identifiant
    Cliquer Sur Connexion
    Ouvrir le formulaire d'ajout
    Cliquer sur le bouton Annuler
    Vérifier retour sur la page des clients


