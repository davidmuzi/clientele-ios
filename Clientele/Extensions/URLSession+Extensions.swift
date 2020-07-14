//
//  URLSession+Extensions.swift
//  Clientele
//
//  Created by David Muzi on 2020-07-09.
//

import Foundation
import Combine

extension URLSession {
    func run<T: Decodable>(request: URLRequest, type: T.Type) -> AnyPublisher<T, Error> {
        dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder.snakedDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
