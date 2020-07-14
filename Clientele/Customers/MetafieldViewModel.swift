//
//  MetafieldViewModel.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-08.
//

import Combine
import Foundation

class MetafieldViewModel: ObservableObject {
    
    @Published
    var metafields: [Metafield] = []
    var cancellable: AnyCancellable?
    
    func fetchMetafields(for customer: ShopifyCustomer, with token: ShopifyToken) {
        
        let client = ShopifyClient(token: token)
        let request = client.metafields(from: customer.id)
        
        cancellable = URLSession.shared
            .run(request: request, type: Metafields.self)
            .map(\.metafields)
            .replaceError(with: [])
            .assign(to: \.metafields, on: self)
    }
}
