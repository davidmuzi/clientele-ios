//
//  CustomerDetailView.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-07.
//

import SwiftUI

struct CustomerDetailView: View {

    @EnvironmentObject var token: TokenViewModel
    @State private var addMetafield = false
    @ObservedObject var metafieldsViewModel = MetafieldViewModel()
    
    let customer: ShopifyCustomer

    var body: some View {
        VStack {
            Text(customer.firstName ?? customer.lastName ?? "")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            Text(customer.email ?? "")
            Text(customer.phone ?? "")
            List {
                NavigationLink(destination: OrderListView(customer: customer)) {
                    HStack {
                        Text("Orders")
                        Spacer()
                        Text("\(customer.ordersCount)")
                    }
                }
                Section(header: Text("Custom fields")) {
                    ForEach(metafieldsViewModel.metafields, content: MetafieldRow.init)
                        .onDelete(perform: deleteMetafield)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarItems(trailing:
                Button(action: {
                    self.addMetafield = true
                }) {
                    Image(systemName: "plus.circle")
                        .imageScale(.large)
                }
            )
        }
        .onAppear { metafieldsViewModel.fetchMetafields(for: customer, with: token.token) }
        .sheet(isPresented: $addMetafield) {
            MetafieldCreationView(presented: $addMetafield, metafieldsViewModel: metafieldsViewModel, customer: customer)
                .environmentObject(self.token)
                .accentColor(.purple)
        }
    }
    
    private func deleteMetafield(at offsets: IndexSet) {
        let metafield = metafieldsViewModel.metafields[offsets.first!]
        metafieldsViewModel.metafields.remove(at: offsets.first!)
        
        let client = ShopifyClient(token: token.token)
        let request = client.deleteMetafield(metafield: metafield)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error removing metafield: \(error)")
                return
            }
        }.resume()
    }
}

struct MetafieldRow: View {
    let metafield: Metafield
    
    var body: some View {
        HStack {
            Text(metafield.key)
            Spacer()
            Text(metafield.value.debugDescription)
        }
    }
}

struct CustomerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomerDetailView(customer: .fakeCustomer)
        }
    }
}

extension ShopifyCustomer {
    static var fakeCustomer: ShopifyCustomer {
        ShopifyCustomer(id: 3, firstName: "David", lastName: "Muzi", acceptsMarketing: false, email: "david@example.com", phone: nil, totalSpent: "123.45", ordersCount: 3)
    }
}
