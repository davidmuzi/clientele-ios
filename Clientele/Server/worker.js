addEventListener('fetch', event => {
    event.respondWith(routeRequest(event.request))
})

async function routeRequest(request) {
    const requestURL = new URL(request.url)

    if (requestURL.pathname == '/verify') {
        return verifyCode(request)
    }
    return redirectToLogin(request)
}

async function redirectToLogin(request) {
    const url = new URL(request.url)
    const redirect = `https://${url.host}/verify`

    const state = Math.random().toString(36).substring(2, 15)
    const scope = 'write_customers,read_customers,read_orders'
    const redirectURL = `https://${url.searchParams.get('shop')}/admin/oauth/authorize?client_id=${CLIENT_ID}&scope=${scope}&redirect_uri=${redirect}&state=${state}&grant_options[]=per-user`

    const response = new Response('', {status: 301})
    response.headers.set('Set-Cookie', `nonce=${state}; Secure; HttpOnly`)
    response.headers.set('Location', redirectURL)
    return response
}

async function verifyCode(request) {
    const params = new URL(request.url).searchParams
    const state = params.get('state')
    const hmac = params.get('hmac')
    const timestamp = params.get('timestamp')
    const shop = params.get('shop')
    const code  = params.get('code')

    // request was from last 30 seconds
    if (Date.now()/1000 > (timestamp + 30)) {
        return new Response(`error timestamp: ${Date.now()/1000} t ${timestamp}`, {status: 400})
    }

    // verify domain
    var regEx = new RegExp(/[a-zA-Z0-9][a-zA-Z0-9\-]*\.myshopify\.com[\/]?/);
    if (regEx.exec(shop) == null) {
        return new Response(`error shop: ${shop}`, {status: 400})
    }

    // state matched one from request
    if (state != getCookie(request, 'nonce')) {
        return new Response(`error state: ${state} cookie ${request.headers.get('Cookie')}`, {status: 400})
    }

    // verify signature
    const hmacValid = await verifySignature(hmac, state, shop, code, timestamp)
    if(hmacValid != true) {
        const data = `code=${code}&shop=${shop}&state=${state}&timestamp=${timestamp}`
        return new Response(`error hmac: ${hmac} f ${data}`, {status: 400})
    }
    
    const res = await fetch(`https://${shop}/admin/oauth/access_token`, {
        method: 'POST',
        headers: {'Content-Type': 'application/json'},
        body: JSON.stringify({code: code, client_id: CLIENT_ID, client_secret: CLIENT_SECRET})
    })

    try {
        const json = await res.json()
        return Response.redirect(`oauth-swift://login?access_token=${json.access_token}&scope=${json.scope}`, 301)
    } catch (err) {
        return new Response(`error: ${err}`, {status: 400})
    }
}

async function verifySignature(hmac, state, shop, code, timestamp) {
    const encoder = new TextEncoder()
    const secretKeyData = encoder.encode(CLIENT_SECRET)
    const key = await crypto.subtle.importKey("raw", secretKeyData, { name: "HMAC", hash: "SHA-256"}, false, [ "verify", "sign" ])
    const data = `code=${code}&shop=${shop}&state=${state}&timestamp=${timestamp}`
    const signature = await crypto.subtle.sign('HMAC', key, encoder.encode(data))
    const b = new Uint8Array(signature);
    const str = Array.prototype.map.call(b, x => ('00'+x.toString(16)).slice(-2)).join("")
    return str == hmac
}

function getCookie(request, name) {
  let result = ''
  const cookieString = request.headers.get('Cookie')
  if (cookieString) {
    const cookies = cookieString.split(';')
    cookies.forEach(cookie => {
      const cookieName = cookie.split('=')[0].trim()
      if (cookieName === name) {
        const cookieVal = cookie.split('=')[1]
        result = cookieVal
      }
    })
  }
  return result
}
