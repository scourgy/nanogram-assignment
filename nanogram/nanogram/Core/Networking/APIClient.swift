//
//  APIClient.swift
//  nanogram
//
//  Created by Galin Yonchev on 5.11.26.
//

import Foundation

protocol APIClientProtocol {
    func get<T: Decodable>(from url: URL) async throws -> T
}

struct APIClient: APIClientProtocol {
    
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func get<T: Decodable>(from url: URL) async throws -> T {
        var request = URLRequest(url: url)
        request.timeoutInterval = 10
        request.httpMethod = "GET" // Potentially an enum
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            
            return try decoder.decode(T.self, from: data)
        } catch {
            throw APIError.map(error)
        }
        
    }
    
}
