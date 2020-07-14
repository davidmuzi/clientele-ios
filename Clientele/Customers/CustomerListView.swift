//
//  CustomerListView.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-07.
//

import SwiftUI

struct CustomerListView: View {
    
    @ObservedObject var customersViewModel = CustomersViewModel()
    @EnvironmentObject var token: TokenViewModel
    
    var body: some View {
        NavigationView {
            Group {
                if customersViewModel.customers.isEmpty == true {
                    ActivityIndicator()
                }
                List(customersViewModel.customers, rowContent: CustomerCell.init)
            }
            .navigationBarTitle("Clients", displayMode: .large)
        }
        .onAppear { customersViewModel.fetchCustomers(with: token.token) }
    }
}

struct CustomerCell: View {
    
    let customer: ShopifyCustomer
    
    var body: some View {
        NavigationLink(destination: CustomerDetailView(customer: customer)) {
            VStack(alignment: .leading) {
                Text("\(customer.firstName ?? "?") \(customer.lastName ?? "?")")
                Text("Orders: \(customer.ordersCount)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

