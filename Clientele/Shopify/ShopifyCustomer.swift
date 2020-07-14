//
//  ShopifyCustomer.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-07.
//

import Foundation

struct ShopifyCustomer: Decodable, Identifiable {
    let id: Int
    let firstName: String?
    let lastName: String?
    let acceptsMarketing: Bool
    let email: String?
    let phone: String?
    let totalSpent: String
    let ordersCount: Int
}

struct ShopifyCustomers: Decodable {
    let customers: [ShopifyCustomer]
}

extension ShopifyClient {
    
    func customers(limit: Int? = nil) -> URLRequest {
        let queryItems = limit == nil ? [] : [URLQueryItem(name: "limit", value: "\(limit!)")]
        return request(for: "customers.json", queryItems: queryItems)
    }
}
