//
//  ShopifyToken.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-07.
//

import Foundation

enum LoginError: Error {
    case NoToken
}

struct ShopifyCode: Codable {
    let domain: String
    let code: String
}

struct ShopifyToken: Codable {
    struct Token: Codable {
        let accessToken: String
        let scope: String
    }
    
    let domain: String
    let token: Token
}
