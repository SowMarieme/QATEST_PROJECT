*** Settings ***
Library    ../resources/MongoLibrary.py
Library    Collections
Library    BuiltIn

*** Variables ***
${URI_MONGO}    mongodb+srv://marieme:mayna2000@cluster0.cf7lu2d.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
${NOM_BDD}      fakeStoreDB
${COLLECTION}   categories

*** Test Cases ***

# --- CRÉATION ---

Créer Catégorie Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${cat}=    Create Dictionary    name=men's clothing    description=Articles pour homme    image=https://image.com/homme.jpg
    ${id}=    Insert Document    ${COLLECTION}    ${cat}
    Should Not Be Empty    ${id}

Créer Catégorie Sans Nom
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${cat}=    Create Dictionary    description=Pas de nom    image=https://image.com/none.jpg
    Run Keyword And Expect Error    *Le champ 'name' est obligatoire*    Insert Document    ${COLLECTION}    ${cat}

Créer Catégorie Image Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${cat}=    Create Dictionary    name=ErreurCategorie    description=Test    image=not_a_url
    ${id}=    Insert Document    ${COLLECTION}    ${cat}
    ${requete}=    Create Dictionary    _id=${id}
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Should Not Be Empty    ${resultat}
    Should Be Equal As Strings    ${resultat['image']}    not_a_url

# --- LECTURE ---

Lire Catégorie Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${cat}=    Create Dictionary    name=Accessoires    description=Tous les accessoires    image=https://image.com/acc.jpg
    ${id}=    Insert Document    ${COLLECTION}    ${cat}
    ${requete}=    Create Dictionary    _id=${id}
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Should Not Be Empty    ${resultat}
    Should Be Equal As Strings    ${resultat['name']}    Accessoires

Lire Catégorie ID Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=badid
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Should Be Equal    ${resultat}    ${None}

Lire Catégorie Inexistante
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=000000000000000000000000
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Should Be Equal    ${resultat}    ${None}

# --- MISE À JOUR ---

Mettre à Jour Catégorie Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${cat}=    Create Dictionary    name=Électronique    description=Appareils    image=https://image.com/elec.jpg
    ${id}=    Insert Document    ${COLLECTION}    ${cat}
    ${requete}=    Create Dictionary    _id=${id}
    ${mise_a_jour}=    Create Dictionary    description=Appareils électroniques
    ${compte}=    Update Document    ${COLLECTION}    ${requete}    ${mise_a_jour}
    Should Be Equal As Integers    ${compte}    1

Mettre à Jour Catégorie ID Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=invalidid
    ${mise_a_jour}=    Create Dictionary    description=ÉchecMiseÀJour
    ${compte}=    Update Document    ${COLLECTION}    ${requete}    ${mise_a_jour}
    Should Be Equal As Integers    ${compte}    0

Mettre à Jour Catégorie Inexistante
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=000000000000000000000000
    ${mise_a_jour}=    Create Dictionary    name=Inconnu
    ${compte}=    Update Document    ${COLLECTION}    ${requete}    ${mise_a_jour}
    Should Be Equal As Integers    ${compte}    0

# --- SUPPRESSION ---

Supprimer Catégorie Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${cat}=    Create Dictionary    name=Jouets    description=Articles pour enfants    image=https://img.com/toy.jpg
    ${id}=    Insert Document    ${COLLECTION}    ${cat}
    ${requete}=    Create Dictionary    _id=${id}
    ${compte}=    Delete Document    ${COLLECTION}    ${requete}
    Should Be Equal As Integers    ${compte}    1

Supprimer Catégorie ID Invalide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=wrongid
    ${compte}=    Delete Document    ${COLLECTION}    ${requete}
    Should Be Equal As Integers    ${compte}    0

Supprimer Catégorie Inexistante
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=000000000000000000000000
    ${compte}=    Delete Document    ${COLLECTION}    ${requete}
    Should Be Equal As Integers    ${compte}    0
