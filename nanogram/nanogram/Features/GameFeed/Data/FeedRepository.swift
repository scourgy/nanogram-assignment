//
//  FeedRepository.swift
//  nanogram
//
//  Created by Galin Yonchev on 6.11.26.
//

protocol FeedRepositoryProtocol {
    
    var games: [Game] { get }
    var hasMorePages: Bool { get }
    func loadNextPage() async throws
    
}

final class FeedRepository: FeedRepositoryProtocol {
    
    // MARK: - Variables and constants
    private let gamesAPI: GamesAPIProtocol
    private(set) var games: [Game] = []
    private var nextPage: Int? = 1
    private var isLoadingPage = false
    private var loadedGamesIDs = Set<String>()
    var hasMorePages: Bool { nextPage != nil }
    
    // MARK: - Lifecycle
    init(gamesAPI: GamesAPIProtocol) {
        self.gamesAPI = gamesAPI
    }
    
    // MARK: - Page loading
    func loadNextPage() async throws {
        guard let page = nextPage, !isLoadingPage else {
            return
        }
        
        isLoadingPage = true
        
        defer {
            isLoadingPage = false
        }
        do {
            let response = try await gamesAPI.fetchGamesFeed(page: page)
            
            let newGames = response.games.filter { loadedGamesIDs.insert($0.id).inserted }
            games.append(contentsOf: newGames)
            nextPage = response.nextPage
        } catch {
            throw APIError.map(error)
        }

    }
    
}
