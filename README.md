# oauth2-server-example

```bash
npm install -g coffee-script
npm install

coffee seed.coffee #creates the test user and app
npm start #runs the server
```

## Example using the `password` grant type

First you must insert client id/secret and user into storage. This is out of the scope of this example.

To obtain a token you should POST to `/oauth/token`. You should include your client credentials in
the Authorization header ("Basic " + client_id:client_secret base64'd), and then grant_type ("password"),
username and password in the request body, for example:

```
POST /oauth/token HTTP/1.1
Host: server.example.com
Authorization: Basic czZCaGRSa3F0MzpnWDFmQmF0M2JW
Content-Type: application/x-www-form-urlencoded

grant_type=password&username=johndoe&password=A3ddj3w
```
This will then call the following on your model (in this order):
 - getClient (clientId, clientSecret, callback)
 - grantTypeAllowed (clientId, grantType, callback)
 - getUser (username, password, callback)
 - saveAccessToken (accessToken, clientId, expires, user, callback)
 - saveRefreshToken (refreshToken, clientId, expires, user, callback) **(if using)**

Provided there weren't any errors, this will return the following (excluding the `refresh_token` if you've not enabled the refresh_token grant type):

```
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
Cache-Control: no-store
Pragma: no-cache

{
  "access_token":"2YotnFZFEjr1zCsicMWpAA",
  "token_type":"bearer",
  "expires_in":3600,
  "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA"
}
```
