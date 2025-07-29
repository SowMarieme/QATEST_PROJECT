*** Settings ***
Resource    ../resources/ebay_keywords.robot
Library     Collections
Library     BuiltIn

*** Variables ***
${VALID_ORDER_ID}    11-12345-67890

*** Test Cases ***

Get All Fulfillments - Scénario Passant
    [Documentation]    Récupère tous les fulfillments d'une commande valide.
    ${response}=    Get All Shipping Fulfillments    ${VALID_ORDER_ID}
    Should Be Equal As Strings    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    fulfillments

Get All Fulfillments - Scénario Non Passant (Order ID invalide)
    [Documentation]    Tente de récupérer les fulfillments d’un order ID invalide.
    ${response}=    Get All Shipping Fulfillments    INVALID_ORDER_ID
    Should Be Equal As Strings    ${response.status_code}    404
