//
//  EnvironmentWrapper.swift
//  TokenExchange
//
//  Created by David Muzi on 2020-07-07.
//

import Foundation

@propertyWrapper
struct EnvironmentVariable {
    var name: String
    
    var wrappedValue: String? {
        ProcessInfo.processInfo.environment[name]
    }
}
