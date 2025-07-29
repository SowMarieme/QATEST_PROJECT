*** Settings ***
Resource    ../resources/ebay_keywords.robot
Library     Collections
Library     BuiltIn

*** Variables ***
${VALID_ORDER_ID}         11-12345-67890
${VALID_FULFILLMENT_ID}   5000000000000 

*** Test Cases ***

Get Fulfillment - Scénario Passant
    [Documentation]    Récupère un shipping fulfillment existant via son ID.
    ${response}=    Get Shipping Fulfillment    ${VALID_ORDER_ID}    ${VALID_FULFILLMENT_ID}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    trackingNumber

Get Fulfillment - Scénario Non Passant (Fulfillment ID inexistant)
    [Documentation]    Tente de récupérer un fulfillment avec un ID inexistant.
    ${response}=    Get Shipping Fulfillment    ${VALID_ORDER_ID}    INVALID_ID
    Should Be Equal As Strings    ${response.status_code}    404
