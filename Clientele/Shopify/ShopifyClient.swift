//
//  ShopifyClient.swift
//  GoogleAuth
//
//  Created by David Muzi on 2020-05-15.
//  Copyright © 2020 Muzi. All rights reserved.
//

import Foundation

struct ShopifyClient {
    let domain: String
    let token: String
    
    init(token: ShopifyToken) {
        self.domain = token.domain
        self.token = token.token.accessToken
    }
    
    private var urlComponents: URLComponents {
        var components = URLComponents()
        components.scheme = "https"
        components.host = domain
        components.path = "/admin/api/2020-07/"
        
        return components
    }
    
    func request(for path: String, queryItems: [URLQueryItem]? = nil) -> URLRequest {
        var components = urlComponents
        components.path += path
        
        if let items = queryItems {
            components.queryItems = items
        }
        
        var request = URLRequest(url: components.url!)
        request.setValue(token, forHTTPHeaderField: "X-Shopify-Access-Token")
        return request
    }
    
    func postRequest<P: Encodable>(for path: String, payload: P) -> URLRequest {
        var components = urlComponents
        components.path += path
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "POST"
        request.httpBody = try? JSONEncoder.snakedEncoder().encode(payload)
        request.setValue(token, forHTTPHeaderField: "X-Shopify-Access-Token")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func deleteRequest(for path: String) -> URLRequest {
        var components = urlComponents
        components.path += path
        
        var request = URLRequest(url: components.url!)
        request.setValue(token, forHTTPHeaderField: "X-Shopify-Access-Token")
        request.httpMethod = "DELETE"
        return request
    }
}

extension JSONDecoder {
    static func snakedDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}

extension JSONEncoder {
    static func snakedEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}
