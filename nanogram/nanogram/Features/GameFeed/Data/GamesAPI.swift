//
//  GamesAPI.swift
//  nanogram
//
//  Created by Galin Yonchev on 5.11.26.
//

import Foundation

protocol GamesAPIProtocol {
    func fetchGamesFeed(page: Int) async throws -> GamePageResponse
}

final class GamesAPI: GamesAPIProtocol {
    
    private let client: APIClientProtocol
    private let gamesFeedBaseURL: URL
    
    init(client: APIClientProtocol, gamesFeedBaseURL: URL) {
        self.client = client
        self.gamesFeedBaseURL = gamesFeedBaseURL
    }
    
    func fetchGamesFeed(page: Int) async throws -> GamePageResponse {
        guard page > 0 else {
            throw APIError.invalidPage(page: page)
        }
        
        let url = gamesFeedBaseURL.appending(path: "page-\(page).json")
        
        return try await client.get(from: url)
    }
}
