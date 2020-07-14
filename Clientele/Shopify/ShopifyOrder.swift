//
//  ShopifyOrder.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-08.
//

import Foundation

struct ShopifyOrder: Decodable, Identifiable {
    let id: Int
    let email: String
    let createdAt: Date
    let totalPrice: String
    let name: String
    let customer: ShopifyCustomer
}

struct ShopifyOrders: Decodable {
    let orders: [ShopifyOrder]
}

extension ShopifyClient {
    func orders(limit: Int? = nil) -> URLRequest {
        let queryItems = limit == nil ? [] : [URLQueryItem(name: "limit", value: "\(limit!)")]
        return request(for: "orders.json", queryItems: queryItems)
    }

    func orders(from customer: Int) -> URLRequest {
        return request(for: "customers/\(customer)/orders.json")
    }
}
