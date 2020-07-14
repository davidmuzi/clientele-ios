//
//  ContentView.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-07.
//

import SwiftUI

struct LoginView: View {
    @State private var loginPresented = false
    @State private var domain: String = ""
    @EnvironmentVariable(name: "defaultDomain") private var defaultDomain: String?
    
    var body: some View {
        Group {
            Spacer()
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Spacer()
            TextField("Shopify domain", text: $domain)
                .keyboardType(.URL)
                .autocapitalization(.none)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Login") { loginPresented.toggle() }
                .foregroundColor(.white)
                .padding()
                .background(Color.accentColor)
                .cornerRadius(8)
            Spacer(minLength: 300)
            
            if loginPresented {
                LoginViewHost(presented: $loginPresented, domain: domain)
                    .frame(width: 0, height: 0)
            }
        }
        .foregroundColor(Color.accentColor)
        .onAppear() { domain = defaultDomain ?? "" }
    }
}
