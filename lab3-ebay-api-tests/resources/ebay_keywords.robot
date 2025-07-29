*** Settings ***
Library    RequestsLibrary
Library    Process
Library    Collections
Library    BuiltIn
Library    DateTime

*** Variables ***
${BASE_URL}         https://api.sandbox.ebay.com/sell/fulfillment/v1
${TOKEN_COMMAND}    python variables/get_ebay_token.py

*** Keywords ***

Get eBay Auth Token
    [Documentation]    Récupère un token d'accès OAuth valide depuis le script Python.
    ${result}=    Run Process    ${TOKEN_COMMAND}    shell=True    stdout=PIPE
    ${token}=     Set Variable    ${result.stdout.strip()}
    RETURN    ${token}

List Orders
    ${token}=    Get eBay Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    ...    Content-Type=application/json
    Create Session    ebay    ${BASE_URL}    headers=${headers}    verify=False

    ${params}=    Create Dictionary
    ...    limit=5
    ...    filter=status:{APPROVED}

    ${response}=    GET On Session    ebay    /order    params=${params}

    Log To Console    Response status: ${response.status_code}
    Log To Console    Response headers: ${response.headers}
    Log To Console    Response body: ${response.text}

    Run Keyword If    '${response.status_code}' != '200'    Fail    API Error: ${response.text}

    ${orders}=    Evaluate    ${response.json()['orders']}
    Run Keyword If    '${orders}' == '[]'    Fail    Aucune commande trouvée dans le sandbox.

    ${order}=    Set Variable    ${orders}[0]
    ${order_id}=    Set Variable    ${order['orderId']}
    ${line_items}=    Set Variable    ${order['lineItems']}
    Run Keyword If    '${line_items}' == '[]'    Fail    Aucun line item trouvé pour la commande ${order_id}

    ${line_item_id}=    Set Variable    ${line_items}[0]['lineItemId']

    Log To Console    ✅ order_id=${order_id} | line_item_id=${line_item_id}
    RETURN    ${order_id}    ${line_item_id}



Create Fulfillment
    [Arguments]    ${order_id}    ${line_item_id}    ${carrier}    ${tracking}
    ${token}=    Get eBay Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    ...    Content-Type=application/json
    Create Session    ebay    ${BASE_URL}    headers=${headers}    verify=False

    ${qty}=    Convert To Integer    1
    ${item}=    Create Dictionary    lineItemId=${line_item_id}    quantity=${qty}
    @{line_items}=    Create List    ${item}

    ${body}=    Create Dictionary
    ...    lineItems=${line_items}
    ...    shippedDate=2025-07-29T10:00:00.000Z
    ...    shippingCarrierCode=${carrier}
    ...    trackingNumber=${tracking}

    ${json_body}=    Evaluate    json.dumps(${body})    json
    Log To Console    === PAYLOAD ===
    Log To Console    ${json_body}

    ${endpoint}=    Set Variable    /order/${order_id}/shipping_fulfillment
    Log To Console    >>> POST ${endpoint}

    ${response}=    POST On Session    ebay    ${endpoint}    json=${body}

    Log To Console    <<< Status: ${response.status_code}
    Log To Console    <<< Response: ${response.text}
    Log    ${response.text}    console=True

    Run Keyword If    '${response.status_code}' != '201'    Fail    Requête échouée avec code ${response.status_code}

    RETURN    ${response}



Get Shipping Fulfillment
    [Arguments]    ${order_id}    ${fulfillment_id}
    ${token}=    Get eBay Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    ...    Content-Type=application/json
    Create Session    ebay    ${BASE_URL}    headers=${headers}    verify=False

    ${endpoint}=    Set Variable    /order/${order_id}/shipping_fulfillment/${fulfillment_id}
    Log To Console    GET ${endpoint}

    ${response}=    GET On Session    ebay    ${endpoint}
    RETURN    ${response}

Get All Shipping Fulfillments
    [Arguments]    ${order_id}
    ${token}=    Get eBay Auth Token
    ${headers}=    Create Dictionary
    ...    Authorization=Bearer ${token}
    ...    Content-Type=application/json
    Create Session    ebay    ${BASE_URL}    headers=${headers}    verify=False

    ${endpoint}=    Set Variable    /order/${order_id}/shipping_fulfillment
    Log To Console    GET ${endpoint}

    ${response}=    GET On Session    ebay    ${endpoint}
    RETURN    ${response}
