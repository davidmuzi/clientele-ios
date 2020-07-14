//
//  MetafieldCreationView.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-08.
//

import SwiftUI

struct MetafieldCreationView: View {
    
    enum ValueType: String, CaseIterable, Identifiable {
        case string, number, date, colour
        var id: String { self.rawValue }
    }
    
    @State private var key: String = ""
    @State private var value: String = ""
    @State private var description: String = ""
    @State private var valueTypes = ValueType.allCases
    @State private var selectedType = ValueType.string
    @State private var colour = Color.red
    @State private var date = Date()
    @Binding var presented: Bool
    @EnvironmentObject var token: TokenViewModel
    @ObservedObject var metafieldsViewModel: MetafieldViewModel

    let customer: ShopifyCustomer
    
    var body: some View {
        NavigationView {
            Form {
                Picker(selection: $selectedType, label: Text("Value type")) {
                    ForEach(valueTypes, id: \.self) {
                        Text($0.rawValue.capitalized).tag($0)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                TextField("Key", text: $key)
                typeView
                TextField("Description", text: $description)
            }
            .navigationBarTitle("Add custom field", displayMode: .inline)
            .navigationBarItems(leading:
                                    Button("Close") { presented = false },
                                trailing:
                                    Button("Save", action: saveMetafield)
            )
        }
    }
    
    private var typeView: some View {
        Group {
            switch selectedType {
            case .string: TextField("Value", text: $value)
            case .number: TextField("Value", text: $value)
            case .date: DatePicker("Date", selection: $date, displayedComponents: [.date])
            case .colour: ColorPicker("Colour", selection: $colour, supportsOpacity: false)
            }
        }
    }
    
    private func saveMetafield() {
        let type: Metafield.ValueType
        let valueType: String
        
        switch selectedType {
        case .colour, .date:
            let value = MetadataType(date: date, colour: colour.uiColor().toHexString())
            let json = try! JSONEncoder.snakedEncoder().encode(value)
            type = .string(String(data: json, encoding: .utf8)!)
            valueType = "string"
        case .number:
            type = .integer(Int(value) ?? 0)
            valueType = "integer"
        case .string:
            type = .string(value)
            valueType = "string"
        }
        
        let metafield = Metafield(id: 0, key: key, value: type, valueType: valueType, namespace: "clientele_app", description: description)
        
        let client = ShopifyClient(token: token.token)
        let request = client.createMetafield(for: customer.id, metafield: metafield)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error saving metafield: \(error)")
                return
            }
            presented = false
            
            metafieldsViewModel.fetchMetafields(for: customer, with: token.token)
        }.resume()
    }
}
