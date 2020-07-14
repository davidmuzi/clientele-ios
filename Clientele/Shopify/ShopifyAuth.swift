//
//  ShopifyAuth.swift
//
//  Created by David Muzi on 2020-05-15.
//

import AuthenticationServices

struct ShopifyAuth {
    let domain: String
    let apiKey: String
    let scopes: [String]
    let loginURL: String
    
    /// Auth session for merchant login
    /// - Parameter callback: upon success, a code which needs to be exchanged for an access token
    /// via a server request since it requires the client secret, which should not be bundled on the client
    /// https://shopify.dev/tutorials/authenticate-with-oauth#step-3-confirm-installation
    /// - Returns: a session object. Call `start` on it to initiate the auth flow
    func authSession(callback: @escaping (Result<ShopifyToken, Error>) -> Void) -> ASWebAuthenticationSession {

        let url = URL(string: "\(loginURL)/?shop=\(domain)")!
        return ASWebAuthenticationSession(url: url, callbackURLScheme: nil) { (url, error) in
            
            if let error = error {
                return callback(.failure(error))
            }
            
            guard let url = url, let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems else {
                return callback(.failure(AuthError.badUrl))
            }
            
            if let token = queryItems["access_token"], let scope = queryItems["scope"] {
                let shopifyToken = ShopifyToken(domain: domain, token: ShopifyToken.Token(accessToken: token, scope: scope))
                callback(.success(shopifyToken))
            }
        }
    }
}

enum AuthError: Error {
    case badUrl, badDomain, badState, missingParams
}

extension Sequence where Element == URLQueryItem {
    subscript(param: String) -> String? {
        first(where: { $0.name == param })?.value
    }
}
