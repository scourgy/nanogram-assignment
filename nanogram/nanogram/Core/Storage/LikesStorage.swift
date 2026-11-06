//
//  LikesStorage.swift
//  nanogram
//
//  Created by Galin Yonchev on 5.11.26.
//

import Foundation

protocol LikesStorageProtocol {
    func isLiked(gameID: String) -> Bool
    func setLiked(gameID: String, isLiked: Bool)
}

final class LikesStorage: LikesStorageProtocol {
    
    // MARK: - Variables and constants
    private static let key = "likedGameIDs"
    private let userDefaults: UserDefaults
    private var likedGameIDs: Set<String>
    
    // MARK: - Initialization
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        likedGameIDs = Set(userDefaults.stringArray(forKey: Self.key) ?? [])
    }
    
    // MARK: - Storage
    func isLiked(gameID: String) -> Bool {
        likedGameIDs.contains(gameID)
    }
    
    func setLiked(gameID: String, isLiked: Bool) {
        if isLiked {
            likedGameIDs.insert(gameID)
        } else {
            likedGameIDs.remove(gameID)
        }
        userDefaults.set(Array(likedGameIDs), forKey: Self.key)
    }
    
}
