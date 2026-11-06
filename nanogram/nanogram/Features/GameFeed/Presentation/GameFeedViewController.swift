//
//  GameFeedViewController.swift
//  nanogram
//
//  Created by Galin Yonchev on 5.11.26.
//

import UIKit

class GameFeedViewController: UIViewController {
    
    // MARK: - Dependencies
    private let viewModel: GameFeedViewModel
    private let gamePlayer: GamePlayerControllerProtocol
    
    // MARK: - Initialization
    init(viewModel: GameFeedViewModel, gamePlayer: GamePlayerControllerProtocol) {
            self.viewModel = viewModel
            self.gamePlayer = gamePlayer
            super.init(nibName: nil, bundle: nil)
        }
    
    init?(coder: NSCoder, viewModel: GameFeedViewModel, gamePlayer: GamePlayerControllerProtocol) {
        self.viewModel = viewModel
        self.gamePlayer = gamePlayer
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(coder:viewModel:player:) or init(viewModel:player:)")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
    }

}

