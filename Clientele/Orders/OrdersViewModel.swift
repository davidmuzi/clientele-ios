//
//  OrdersViewModel.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-08.
//

import Foundation
import Combine

class OrdersViewModel: ObservableObject {
    
    @Published var orders: [ShopifyOrder] = []
    var cancellable: AnyCancellable?
    
    func fetchOrders(from customer: ShopifyCustomer, with token: ShopifyToken) {
        
        let client = ShopifyClient(token: token)
        let request = client.orders(from: customer.id)

        cancellable = URLSession.shared
            .run(request: request, type: ShopifyOrders.self)
            .map(\.orders)
            .replaceError(with: [])
            .assign(to: \.orders, on: self)
    }
}
