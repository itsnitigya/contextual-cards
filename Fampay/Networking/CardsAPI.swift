//
//  CardsAPI.swift
//  Fampay
//
//  Created by Nitigya Kapoor on 19/06/21.
//  Copyright © 2021 Nitigya Kapoor. All rights reserved.
//


import Foundation
import Combine

// Tranforms a url request to a publisher which can be subscribed.
// Using functional programming to convert the data.
// Publisher to AnyPublisher so subscribers don't have to know about the implementaton from upstream.
// Recieve the data on main queue so that UI changes are done on the main queue. 
struct Agent {
    func run<T: Decodable>(_ request: URLRequest) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: request)
            .map { $0.data }
            .handleEvents(receiveOutput: { print(NSString(data: $0, encoding: String.Encoding.utf8.rawValue)!) })
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum CardsAPI {
    private static let base = URL(string: "https://run.mocky.io/v3/21f63660-eef6-4a7a-9367-e1e8467f522f")!
    private static let agent = Agent()
    
    static func get() -> AnyPublisher<ResultDTO<CardDTO>, Error> {
        let request = URLComponents(url: base, resolvingAgainstBaseURL: true)?
            .request
        return agent.run(request!)
    }
}

private extension URLComponents {
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}

