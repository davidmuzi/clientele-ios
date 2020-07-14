//
//  ClienteleApp.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-07.
//

import SwiftUI

@main
struct ClienteleApp: App {
    
    @AppStorage("token")
    var accessToken: Data?
    
    var body: some Scene {
        WindowGroup {
            if let data = accessToken, let accessToken = try? JSONDecoder().decode(ShopifyToken.self, from: data) {
                CustomerListView()
                    .accentColor(.purple)
                    .environmentObject(TokenViewModel(token: accessToken))
            } else {
                LoginView()
                    .accentColor(.purple)
            }
        }
    }
}

class TokenViewModel: ObservableObject {
    let token: ShopifyToken
    
    init(token: ShopifyToken) {
        self.token = token
    }
}
