*** Settings ***
Library    ../resources/MongoLibrary.py
Library    Collections
Library    BuiltIn

*** Variables ***
${MONGO_URI}    mongodb+srv://marieme:mayna2000@cluster0.cf7lu2d.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
${DB_NAME}      fakeStoreDB
${COLLECTION}   carts

*** Test Cases ***

# --- CREATE ---

Create Valid Cart
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${p1}=    Create Dictionary    productId=000000000000000000000001    quantity=2
    ${p2}=    Create Dictionary    productId=000000000000000000000002    quantity=1
    ${products}=    Create List    ${p1}    ${p2}
    ${cart}=    Create Dictionary    userId=000000000000000000000009    date=2020-03-02T00:00:00.000Z    products=${products}
    ${id}=    Insert Document    ${COLLECTION}    ${cart}
    Should Not Be Empty    ${id}

Create Valid Cart With Check
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${p1}=    Create Dictionary    productId=000000000000000000000001    quantity=2
    ${products}=    Create List    ${p1}
    ${cart}=    Create Dictionary    userId=000000000000000000000009    date=2020-03-02T00:00:00.000Z    products=${products}
    ${id}=    Insert Document    ${COLLECTION}    ${cart}
    Should Not Be Empty    ${id}
    ${query}=    Create Dictionary    _id=${id}
    ${result}=    Find Document    ${COLLECTION}    ${query}
    Should Not Be None    ${result}
    ${userIdStr}=    Get From Dictionary    ${result}    userId
    Should Be Equal As Strings    ${userIdStr}    000000000000000000000009

Create Cart Invalid Date
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${p}=    Create Dictionary    productId=000000000000000000000001    quantity=1
    ${products}=    Create List    ${p}
    ${cart}=    Create Dictionary    userId=000000000000000000000009    date=invalid_date    products=${products}
    ${id}=    Insert Document    ${COLLECTION}    ${cart}
    Should Not Be Empty    ${id}
    ${query}=    Create Dictionary    _id=${id}
    ${result}=    Find Document    ${COLLECTION}    ${query}
    Should Not Be None    ${result}
    ${date}=    Get From Dictionary    ${result}    date
    Should Be Equal As Strings    ${date}    invalid_date

# --- READ ---

Read Valid Cart
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${p}=    Create Dictionary    productId=000000000000000000000001    quantity=1
    ${products}=    Create List    ${p}
    ${cart}=    Create Dictionary    userId=000000000000000000000001    date=2020-01-01T00:00:00.000Z    products=${products}
    ${id}=    Insert Document    ${COLLECTION}    ${cart}
    Should Not Be Empty    ${id}
    ${query}=    Create Dictionary    _id=${id}
    ${result}=    Find Document    ${COLLECTION}    ${query}
    Should Not Be None    ${result}
    ${userIdStr}=    Get From Dictionary    ${result}    userId
    Should Be Equal As Strings    ${userIdStr}    000000000000000000000001

Read Cart Invalid ID
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${query}=    Create Dictionary    _id=badid
    ${result}=    Find Document    ${COLLECTION}    ${query}
    Should Be Equal    ${result}    ${None}

Read Nonexistent Cart
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${query}=    Create Dictionary    _id=000000000000000000000000
    ${result}=    Find Document    ${COLLECTION}    ${query}
    Should Be Equal    ${result}    ${None}

# --- UPDATE ---

Update Valid Cart Date
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${p}=    Create Dictionary    productId=000000000000000000000002    quantity=3
    ${products}=    Create List    ${p}
    ${cart}=    Create Dictionary    userId=000000000000000000000009    date=2020-01-01T00:00:00.000Z    products=${products}
    ${id}=    Insert Document    ${COLLECTION}    ${cart}
    ${query}=    Create Dictionary    _id=${id}
    ${new}=    Create Dictionary    date=2024-07-29T00:00:00.000Z
    ${count}=    Update Document    ${COLLECTION}    ${query}    ${new}
    Should Be Equal As Integers    ${count}    1

Update Cart With Invalid Field
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${cart}=    Create Dictionary    userId=000000000000000000000002    date=2020-01-01T00:00:00.000Z
    ${id}=    Insert Document    ${COLLECTION}    ${cart}
    ${query}=    Create Dictionary    _id=${id}
    ${new}=    Create Dictionary    notafield=value
    ${count}=    Update Document    ${COLLECTION}    ${query}    ${new}
    Should Be Equal As Integers    ${count}    1

Update Nonexistent Cart
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${query}=    Create Dictionary    _id=000000000000000000000000
    ${new}=    Create Dictionary    date=2024-01-01T00:00:00.000Z
    ${count}=    Update Document    ${COLLECTION}    ${query}    ${new}
    Should Be Equal As Integers    ${count}    0

# --- DELETE ---

Delete Valid Cart
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${cart}=    Create Dictionary    userId=000000000000000000000005    date=2022-03-02T00:00:00.000Z
    ${id}=    Insert Document    ${COLLECTION}    ${cart}
    ${query}=    Create Dictionary    _id=${id}
    ${count}=    Delete Document    ${COLLECTION}    ${query}
    Should Be Equal As Integers    ${count}    1

Delete Cart Invalid ID
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${query}=    Create Dictionary    _id=wrongid
    ${count}=    Delete Document    ${COLLECTION}    ${query}
    Should Be Equal As Integers    ${count}    0

Delete Nonexistent Cart
    Connect To Mongo    ${MONGO_URI}    ${DB_NAME}
    ${query}=    Create Dictionary    _id=000000000000000000000000
    ${count}=    Delete Document    ${COLLECTION}    ${query}
    Should Be Equal As Integers    ${count}    0

*** Keywords ***
Should Not Be None
    [Arguments]    ${value}
    Should Not Be Equal    ${value}    ${None}
