//
//  GameFeedViewController.swift
//  nanogram
//
//  Created by Galin Yonchev on 5.11.26.
//

import UIKit

class GameFeedViewController: UIViewController {
    
    // MARK: - Dependencies
    private var viewModel: GameFeedViewModel
    private var gamePlayerController: GamePlayerControllerProtocol
    private var dataSource: GameFeedDataSource
    
    // MARK: - Initialization
    init?(coder: NSCoder, viewModel: GameFeedViewModel, gamePlayerController: GamePlayerControllerProtocol, dataSource: GameFeedDataSource) {
        self.viewModel = viewModel
        self.gamePlayerController = gamePlayerController
        self.dataSource = dataSource
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init with coder, viewModel and gamePlayerController.")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.start()
    }

}

