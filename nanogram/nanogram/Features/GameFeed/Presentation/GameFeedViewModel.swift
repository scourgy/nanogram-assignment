//
//  GameFeedViewModel.swift
//  nanogram
//
//  Created by Galin Yonchev on 6.11.26.
//

import Foundation

final class GameFeedViewModel {
    
    // MARK: - Callbacks
    var onGameFeedStateChange: ((_ state: GameFeedState) -> Void)?
    var onItemsChange: (() -> Void)?
    var onPlayModeChange: ((_ playModeOn: Bool) -> Void)?
    
    // MARK: - Variables and constants
    private let prefetchThreshold: Int = 5
    private var catalogLaps = 1
    private var isLoadingPage = false
    private(set) var isPlayMode = false
    private(set) var activeIndex: Int?
    var numberOfItems: Int {
        repository.games.count * catalogLaps
    }
    
    // MARK: - Dependencies
    private let repository: FeedRepositoryProtocol
    private let likesStorage: LikesStorageProtocol
    
    // MARK: - Initialization
    init(repository: FeedRepositoryProtocol, likesStorage: LikesStorageProtocol) {
        self.repository = repository
        self.likesStorage = likesStorage
    }
    
    // MARK: - Public
    func game(at index: Int) -> Game {
        let games = repository.games
        return games[index % games.count]
    }
    
    func isLiked(at index: Int) -> Bool {
        likesStorage.isLiked(gameID: game(at: index).id)
    }
    
    func didActivate(index: Int) {
        activeIndex = index
        guard index >= numberOfItems - prefetchThreshold else {
            return
        }
        loadNextPage()
    }
    
    func start() {
        loadNextPage()
    }
    
    func toggleLike(at index: Int) {
        let game = game(at: index)
        let isLiked = likesStorage.isLiked(gameID: game.id)
        likesStorage.setLiked(gameID: game.id, isLiked: !isLiked)
    }
    
    func retry() {
        loadNextPage()
    }
    
    func enterPlayMode() {
        guard !isPlayMode, activeIndex != nil else {
            return
        }
        isPlayMode = true
        onPlayModeChange?(true)
    }
    
    func exitPlayMode() {
        guard isPlayMode else {
            return
        }
        isPlayMode = false
        onPlayModeChange?(false)
    }
    
    // MARK: - Private
    private func loadNextPage() {
        guard !isLoadingPage, repository.hasMorePages || numberOfItems > 0 else {
            return
        }
        
        let isFirstPage = numberOfItems == 0
        if isFirstPage {
            onGameFeedStateChange?(.loading)
        }
                
        isLoadingPage = true
        
        Task { [weak self] in
            guard let self else {
                return
            }
            
            defer {
                isLoadingPage = false
            }
            
            let countBeforeLoad = numberOfItems
            if repository.hasMorePages {
                do {
                    try await repository.loadNextPage()
                } catch {
                    print("[ERROR] Failed to load the next feed page: \(error)")
                }
            } else {
                // Nothing left to fetch, start over
                catalogLaps += 1
            }
            
            if numberOfItems != countBeforeLoad {
                onItemsChange?()
            }
            if isFirstPage {
                let state: GameFeedState = numberOfItems == 0 ? .empty : .loaded
                onGameFeedStateChange?(state)
            }
        }
    }
    
    
}
