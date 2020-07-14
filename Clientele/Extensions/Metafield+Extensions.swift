//
//  Metafield+Extensions.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-08.
//

import Foundation

struct MetadataType: Codable {
    let date: Date?
    let colour: String?
}

extension Metafield.ValueType: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .integer(let num):
            return "\(num)"
        case .string(let string):
            
            if let data = string.data(using: .utf8),
               let json = try? JSONDecoder.snakedDecoder().decode(MetadataType.self, from: data) {
                if let date = json.date {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "MMMM d"
                    return formatter.string(from: date)
                }
                else if let colour = json.colour {
                    return colour
                }
            }
            return string
        }
    }
}
