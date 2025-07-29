import base64
import requests
import sys

client_id = 'sowmarie-appeba-SBX-13649ae1c-57a05fa0'
client_secret = 'SBX-0ba4f28abb2d-d980-488b-8f2e-aa01'

# Base64 encode client_id:client_secret
credentials = f"{client_id}:{client_secret}"
encoded_credentials = base64.b64encode(credentials.encode('utf-8')).decode('utf-8')

headers = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': f'Basic {encoded_credentials}',
}

data = {
    'grant_type': 'client_credentials',
    'scope': 'https://api.ebay.com/oauth/api_scope'
}

response = requests.post(
    'https://api.sandbox.ebay.com/identity/v1/oauth2/token',
    headers=headers,
    data=data
)

if response.status_code == 200:
    token_data = response.json()
    access_token = token_data.get('access_token')
    if access_token:
        print(access_token)  # Important: seul le token doit être affiché pour Robot Framework
        sys.exit(0)
    else:
        print("Erreur : access_token non trouvé dans la réponse")
        sys.exit(1)
else:
    print(f"Erreur HTTP {response.status_code} : {response.text}")
    sys.exit(1)
