//
//  OrdersListView.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-08.
//

import SwiftUI

struct OrderListView: View {
    
    let customer: ShopifyCustomer
    @ObservedObject var ordersViewModel = OrdersViewModel()
    @EnvironmentObject var token: TokenViewModel
    
    // TODO: this view is not updating after the orders have been fetched
    
    var body: some View {
        Group {
            if ordersViewModel.orders.isEmpty == true {
                ActivityIndicator()
            } else {
                List(ordersViewModel.orders, rowContent: OrderCell.init)
            }
        }
        .onAppear(perform: fetchOrders)
        .navigationBarTitle("Orders", displayMode: .inline)
    }
    
    private func fetchOrders() {
        ordersViewModel.fetchOrders(from: customer, with: token.token)
    }
}

struct OrderCell: View {
    
    let order: ShopifyOrder
    
    var body: some View {
        VStack {
            Text(order.name)
            Text(order.totalPrice)
        }
    }
}
