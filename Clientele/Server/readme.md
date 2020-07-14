# OAuth server

This script can handle the OAuth login flow by generating a login request, accepting the access code, verifying the response and exchanging the code for an access token.

This script can be hosted on a [Cloudflare Worker](https://workers.cloudflare.com) quite easily

## Environment variables

`CLIENT_ID`: The API key from the app's settings in the Partner Dashboard
`CLIENT_SECRET`: The API secret key from the app's settings in the Partner Dashboard
