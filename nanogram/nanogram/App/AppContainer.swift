//
//  AppContainer.swift
//  nanogram
//
//  Created by Galin Yonchev on 6.11.26.
//

import Foundation
import UIKit

final class AppContainer {
    
    let gamesAPI: GamesAPIProtocol
    let likesStorage: LikesStorageProtocol
    
    init() {
        gamesAPI = GamesAPI(client: APIClient(), gamesFeedBaseURL: NetworkConfiguration.gamesFeedBaseURL)
        likesStorage = LikesStorage()
    }
    
    func createGameFeedViewController() -> GameFeedViewController {
        let viewModel = GameFeedViewModel(repository: FeedRepository(gamesAPI: gamesAPI), likesStorage: likesStorage)
        let dataSource = GameFeedDataSource()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: "GameFeedViewController") { coder in
            GameFeedViewController(coder: coder, viewModel: viewModel, gamePlayerController: GamePlayerController(), dataSource: dataSource)
        }
    }
    
}
