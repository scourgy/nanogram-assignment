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
    
    // MARK: - Dependencies
    private let repository: FeedRepositoryProtocol
    private let likesStorage: LikesStorageProtocol
    
    // MARK: - Initialization
    init(repository: FeedRepositoryProtocol, likesStorage: LikesStorageProtocol) {
        self.repository = repository
        self.likesStorage = likesStorage
    }
    
    // MARK: - Public
    func start() {
        // TODO: - Initial load
    }
    
    func toggleLike(at index: Int) {
        // TODO: - Find item at index and toggle its liked flag
    }
    
    func retry() {
        // TODO: - Retry if failed
    }
    
    func enterPlayMode() {
        // TODO: - Enter play mode
    }
    
    func exitPlayMode() {
        // TODO: - Exit play mode
    }
    
    // MARK: - Private
    private func loadNextPage() {
        // TODO: - Load next page, if loading is not in progress
    }
    
    
}
