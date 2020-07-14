//
//  Metafield.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-08.
//

import Foundation

struct Metafield: Codable, Identifiable {

    enum ValueType: Codable {
        
        case string(String)
        case integer(Int)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let string = try? container.decode(String?.self) {
                self = .string(string)
            }
            else if let number = try? container.decode(Int?.self) {
                self = .integer(number)
            }
            else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "no value found")
            }
            
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            switch self {
            case .string(let string):
                try container.encode(string)
            case .integer(let number):
                try container.encode(number)
            }
        }
    }

    let id: Int
    let key: String
    let value: ValueType
    let valueType: String
    let namespace: String
    let description: String?
}

struct Metafields: Codable {
    let metafields: [Metafield]
}

extension ShopifyClient {
    
    func createMetafield(for customer: Int, metafield: Metafield) -> URLRequest {
        let payload = ["metafield": metafield]
        return postRequest(for: "customers/\(customer)/metafields.json", payload: payload)
    }
    
    func deleteMetafield(metafield: Metafield) -> URLRequest {
        return deleteRequest(for: "metafields/\(metafield.id).json")
    }
    
    func metafields(from customer: Int) -> URLRequest {
        return request(for: "customers/\(customer)/metafields.json")
    }
}
