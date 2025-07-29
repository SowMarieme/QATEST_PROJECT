*** Settings ***
Library    ../resources/MongoLibrary.py
Library    Collections
Library    BuiltIn

*** Variables ***
${URI_MONGO}   mongodb+srv://marieme:mayna2000@cluster0.cf7lu2d.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
${NOM_BDD}      fakeStoreDB
${COLLECTION}   products

*** Test Cases ***

# --- CRÉATION ---

Créer Produit Valide
    [Tags]    Créer    Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${doc}=    Create Dictionary    title=Produit Test    price=19.99    category=men's clothing
    ${id}=    Insert Document    ${COLLECTION}    ${doc}
    ${id_str}=    Convert To String    ${id}
    Should Not Be Empty    ${id_str}

Créer Produit Sans Titre
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${doc}=    Create Dictionary    price=19.99    category=men's clothing
    ${id}=    Insert Document    ${COLLECTION}    ${doc}
    ${id_str}=    Convert To String    ${id}
    Should Not Be Empty    ${id_str}
    ${requete}=    Create Dictionary    _id=${id}
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Run Keyword If    '${resultat.get("title")}' == None    Fail    Le champ 'title' est manquant dans le document inséré.

Créer Produit Prix Négatif
    [Tags]    Créer    Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${doc}=    Create Dictionary    title=ProduitMauvais    price=-10    category=men's clothing
    Run Keyword And Expect Error    *prix ne peut pas être négatif*    Insert Document    ${COLLECTION}    ${doc}

# --- LECTURE ---

Lire Produit Par ID
    [Tags]    Lire    Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${doc}=    Create Dictionary    title=LectureTest    price=29.99    category=men's clothing
    ${id}=    Insert Document    ${COLLECTION}    ${doc}
    ${requete}=    Create Dictionary    _id=${id}
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Should Be Equal As Strings    ${resultat['title']}    LectureTest

Lire Produit ID Invalide
    [Tags]    Lire    Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${id_invalide}=    Set Variable    invalid_id_string
    ${requete}=    Create Dictionary    _id=${id_invalide}
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Run Keyword If    '${resultat}' != '${None}'    Fail    Document inattendu trouvé pour ID invalide.

Lire Produit ID Inexistant
    [Tags]    Lire    Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=000000000000000000000000
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Run Keyword If    '${resultat}' != '${None}'    Fail    Document inattendu trouvé pour ID inexistant.

# --- MISE À JOUR ---

Mettre à Jour Produit Valide
    [Tags]    Mise à jour    Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${doc}=    Create Dictionary    title=MiseAJourTest    price=10.00    category=electronics
    ${id}=    Insert Document    ${COLLECTION}    ${doc}
    ${requete}=    Create Dictionary    _id=${id}
    ${nouvelles_valeurs}=    Create Dictionary    price=15.00
    ${compte}=    Update Document    ${COLLECTION}    ${requete}    ${nouvelles_valeurs}
    Should Be Equal As Integers    ${compte}    1
    ${doc_mis_a_jour}=    Find Document    ${COLLECTION}    ${requete}
    Should Be Equal As Numbers    ${doc_mis_a_jour['price']}    15.00

Mettre à Jour Produit Inexistant
    [Tags]    Mise à jour    Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=000000000000000000000000
    ${nouvelles_valeurs}=    Create Dictionary    price=20.00
    ${compte}=    Update Document    ${COLLECTION}    ${requete}    ${nouvelles_valeurs}
    Should Be Equal As Integers    ${compte}    0

Mettre à Jour Données Invalides
    [Tags]    Mise à jour    Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${doc}=    Create Dictionary    title=MiseAJourInvalide    price=10.00    category=electronics
    ${id}=    Insert Document    ${COLLECTION}    ${doc}
    ${requete}=    Create Dictionary    _id=${id}
    ${nouvelles_valeurs}=    Create Dictionary    price=-50.00
    Run Keyword And Expect Error    *prix ne peut pas être négatif*    Update Document    ${COLLECTION}    ${requete}    ${nouvelles_valeurs}

# --- SUPPRESSION ---

Supprimer Produit Valide
    [Tags]    Supprimer    Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${doc}=    Create Dictionary    title=SuppressionTest    price=5.00    category=toys
    ${id}=    Insert Document    ${COLLECTION}    ${doc}
    ${requete}=    Create Dictionary    _id=${id}
    ${compte}=    Delete Document    ${COLLECTION}    ${requete}
    Should Be Equal As Integers    ${compte}    1

Supprimer Produit Inexistant
    [Tags]    Supprimer    Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=000000000000000000000000
    ${compte}=    Delete Document    ${COLLECTION}    ${requete}
    Should Be Equal As Integers    ${compte}    0

Supprimer ID Invalide
    [Tags]    Supprimer    Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${id_invalide}=    Set Variable    invalid_id_string
    ${requete}=    Create Dictionary    _id=${id_invalide}
    ${compte}=    Delete Document    ${COLLECTION}    ${requete}
    Should Be Equal As Integers    ${compte}    0
