//
//  LoginViewHost.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-07.
//

import SwiftUI
import AuthenticationServices

struct LoginViewHost: UIViewControllerRepresentable {
    @Binding var presented: Bool
    let domain: String
    
    func updateUIViewController(_ uiViewController: LoginViewController, context: Context) {
    }
    
    func makeUIViewController(context: Context) -> LoginViewController {
        LoginViewController(domain: domain)
    }
}

class LoginViewController: UIViewController, ASWebAuthenticationPresentationContextProviding {

    @AppStorage("token") var accessToken: Data?
    @EnvironmentVariable(name: "apiKey") var apiKey: String!
    @EnvironmentVariable(name: "loginURL") var loginURL: String!

    let domain: String
    
    init(domain: String) {
        self.domain = domain
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        self.view.window ?? ASPresentationAnchor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        login()
    }
    
    private func login() {
        let shopify = ShopifyAuth(domain: domain.lowercased(),
                                  apiKey: apiKey,
                                  scopes: ["write_customers", "read_customers", "read_orders"],
                                  loginURL: loginURL)
        
        let authSession = shopify.authSession(callback: { (result) in
            guard let token = try? result.get() else {
                print("Error logging in")
                return
            }
            
            self.accessToken = try? JSONEncoder().encode(token)
        })
        
        authSession.presentationContextProvider = self
        authSession.start()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
