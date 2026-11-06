//
//  FeedState.swift
//  nanogram
//
//  Created by Galin Yonchev on 6.11.26.
//

import Foundation

enum GameFeedState {
    
    case empty
    case loading
    case loaded(games: [Game])
    case failed(error: APIError)
    
}
