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
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadContentFromNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadContentFromNib()
    }
    
    // MARK: - Setup
    func setupForGameFeedState(_ state: GameFeedState) {
        switch state {
            case .loading:
                show(message: nil, canRetry: false)
            case .empty:
                show(message: "No games to show. Please retry.", canRetry: true)
            case .failed(error: let error):
                show(message: error.userMessage, canRetry: true)
            case .loaded:
                hide()
        }
    }
    
    func setupForGamePlayerState(_ state: GamePlayerState) {
        switch state {
            case .idle:
                hide()
            case .loading:
                show(message: nil, canRetry: false)
            case .running:
                hide()
            case .failed:
                show(message: "Unable to load the game, please retry.", canRetry: true)
        }
    }
    
    // MARK: - Private
    private func loadContentFromNib() {
        let nib = UINib(nibName: "GameFeedStatusView", bundle: nil)
        guard let contentView = nib.instantiate(withOwner: self).first as? UIView else {
            fatalError("GameFeedStatusView.xib has no top-level view.")
        }
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
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
    
    private func hide() {
        isHidden = true
        activityIndicator.stopAnimating()
    }
}
