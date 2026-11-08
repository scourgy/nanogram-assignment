//
//  GameFeedStatusView.swift
//  nanogram
//
//  Created by Galin Yonchev on 8.11.26.
//

import Foundation
import UIKit

final class GameFeedStatusView: UIView {
    
    // MARK: - Outlets
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var retryButton: UIButton!
    
    // MARK: - Actions
    @IBAction private func retryTapped(_ sender: UIButton) {
        onRetry?()
    }
    
    // MARK: - Callback
    var onRetry: (() -> Void)?
    
    // MARK: - Initialization
    static func loadFromNib() -> GameFeedStatusView {
        let nib = UINib(nibName: "GameFeedStatusView", bundle: nil)
        guard let view = nib.instantiate(withOwner: nil).first as? GameFeedStatusView else {
            fatalError("GameFeedStatusView is not the top-level view in GameFeedStatusView.xib")
        }
        return view
    }
    
    // MARK: - Setup
    func setupForGameState(_ state: GameFeedState) {
        switch state {
            case .loading:
                show(message: nil, canRetry: false)
            case .empty:
                show(message: "No games to show. Please retry.", canRetry: true)
            case .failed(error: let error):
                show(message: error.userMessage, canRetry: true)
            case .loaded(games: _):
                isHidden = true
                activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Private
    private func show(message: String?, canRetry: Bool) {
        self.isHidden = false
        
        messageLabel.text = message
        messageLabel.isHidden = message == nil
        
        retryButton.isHidden = !canRetry
        
        if message == nil {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
