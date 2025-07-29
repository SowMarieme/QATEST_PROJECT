*** Settings ***
Library    ../resources/MongoLibrary.py
Library    Collections
Library    BuiltIn

*** Variables ***
${URI_MONGO}    mongodb+srv://marieme:mayna2000@cluster0.cf7lu2d.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
${NOM_BDD}      fakeStoreDB
${COLLECTION}   users

*** Test Cases ***

# --- CRÉATION ---

Créer Utilisateur Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${utilisateur}=    Create Dictionary    email=marieme@gmail.com    username=marieme    password=passer    phone=781738916
    ${nom}=    Create Dictionary    firstname=John    lastname=Doe
    ${geo}=    Create Dictionary    lat=-37.3159    long=81.1496
    ${adresse}=    Create Dictionary    city=kilcoole    street=7835 new road    zipcode=12926-3874    geolocation=${geo}
    Set To Dictionary    ${utilisateur}    name=${nom}    address=${adresse}
    ${id}=    Insert Document    ${COLLECTION}    ${utilisateur}
    Should Not Be Empty    ${id}

Créer Utilisateur Sans Nom d'Utilisateur
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${utilisateur}=    Create Dictionary    email=missinguser@gmail.com    password=abc
    ${id}=    Insert Document    ${COLLECTION}    ${utilisateur}
    ${requete}=    Create Dictionary    _id=${id}
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Dictionary Should Not Contain Key    ${resultat}    username

Créer Utilisateur Avec Géolocalisation Incorrecte
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${utilisateur}=    Create Dictionary    email=geoerror@gmail.com    username=geo_user    password=abc
    ${geo}=    Create Dictionary    lat=invalid    long=data
    ${adresse}=    Create Dictionary    city=somewhere    street=123    zipcode=12345    geolocation=${geo}
    Set To Dictionary    ${utilisateur}    address=${adresse}
    ${id}=    Insert Document    ${COLLECTION}    ${utilisateur}
    ${requete}=    Create Dictionary    _id=${id}
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Should Be Equal As Strings    ${resultat['address']['geolocation']['lat']}    invalid

# --- LECTURE ---

Lire Utilisateur Valide Par ID
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${utilisateur}=    Create Dictionary    email=read@gmail.com    username=readuser    password=read123
    ${id}=    Insert Document    ${COLLECTION}    ${utilisateur}
    ${requete}=    Create Dictionary    _id=${id}
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Should Be Equal As Strings    ${resultat['username']}    readuser

Lire Utilisateur Avec Format ID Incorrect
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=notavalidid
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Should Be Equal    ${resultat}    ${None}

Lire Utilisateur Inexistant Par ID
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=000000000000000000000000
    ${resultat}=    Find Document    ${COLLECTION}    ${requete}
    Should Be Equal    ${resultat}    ${None}

# --- MISE À JOUR ---

Mettre à Jour Mot de Passe Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${utilisateur}=    Create Dictionary    email=update@gmail.com    username=updateuser    password=oldpwd
    ${id}=    Insert Document    ${COLLECTION}    ${utilisateur}
    ${requete}=    Create Dictionary    _id=${id}
    ${nouveau}=    Create Dictionary    password=newpwd
    ${compte}=    Update Document    ${COLLECTION}    ${requete}    ${nouveau}
    Should Be Equal As Integers    ${compte}    1

Mettre à Jour Utilisateur Inexistant
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=000000000000000000000000
    ${nouveau}=    Create Dictionary    password=shouldnotwork
    ${compte}=    Update Document    ${COLLECTION}    ${requete}    ${nouveau}
    Should Be Equal As Integers    ${compte}    0

Mettre à Jour Mot de Passe Vide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${utilisateur}=    Create Dictionary    email=emptypwd@gmail.com    username=emptypass    password=oldpass
    ${id}=    Insert Document    ${COLLECTION}    ${utilisateur}
    ${requete}=    Create Dictionary    _id=${id}
    ${nouveau}=    Create Dictionary    password=
    Run Keyword And Expect Error    Le champ 'password' ne peut pas être vide    Update Document    ${COLLECTION}    ${requete}    ${nouveau}

# --- SUPPRESSION ---

Supprimer Utilisateur Valide
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${utilisateur}=    Create Dictionary    email=delete@gmail.com    username=deleteuser    password=deletepwd
    ${id}=    Insert Document    ${COLLECTION}    ${utilisateur}
    ${requete}=    Create Dictionary    _id=${id}
    ${compte}=    Delete Document    ${COLLECTION}    ${requete}
    Should Be Equal As Integers    ${compte}    1

Supprimer Utilisateur Inexistant
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=000000000000000000000000
    ${compte}=    Delete Document    ${COLLECTION}    ${requete}
    Should Be Equal As Integers    ${compte}    0

Supprimer Utilisateur Avec ID Incorrect
    Connect To Mongo    ${URI_MONGO}    ${NOM_BDD}
    ${requete}=    Create Dictionary    _id=invalid_id
    ${compte}=    Delete Document    ${COLLECTION}    ${requete}
    Should Be Equal As Integers    ${compte}    0
