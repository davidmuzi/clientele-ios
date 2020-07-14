//
//  CustomersViewModel.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-07.
//

import Combine
import Foundation

class CustomersViewModel: ObservableObject {
    
    @Published var customers: [ShopifyCustomer] = []
    var cancellable: AnyCancellable?
    
    func fetchCustomers(with token: ShopifyToken) {
        
        let client = ShopifyClient(token: token)
        let request = client.customers(limit: 100)
        
        cancellable = URLSession.shared
            .run(request: request, type: ShopifyCustomers.self)
            .map(\.customers)
            .replaceError(with: [])
            .assign(to: \.customers, on: self)
    }
}
