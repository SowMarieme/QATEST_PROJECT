*** Settings ***
Resource    ../resources/ebay_keywords.robot
Library     Collections
Library     BuiltIn

*** Variables ***
${CARRIER}               USPS
${TRACKING_NUMBER}       9400110200881800000000

*** Test Cases ***

Create Fulfillment - Scénario Passant
    ${order_id}    ${line_item_id}=    List Orders
    ${response}=    Create Fulfillment    ${order_id}    ${line_item_id}    ${CARRIER}    ${TRACKING_NUMBER}
    Should Be Equal As Strings    ${response.status_code}    201

Create Fulfillment - Scénario Non Passant (LineItem invalide)
    ${order_id}    ${line_item_id}=    List Orders
    ${response}=    Create Fulfillment    ${order_id}    FAKE_LINE_ITEM    ${CARRIER}    ${TRACKING_NUMBER}
    Should Be Equal As Strings    ${response.status_code}    400
