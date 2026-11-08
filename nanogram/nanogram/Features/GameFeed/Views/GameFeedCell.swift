//
//  GameFeedCell.swift
//  nanogram
//
//  Created by Galin Yonchev on 8.11.26.
//

import Foundation
import UIKit

class GameFeedCell: UICollectionViewCell {
    
    static let identifier = "GameFeedCell"
    
    // MARK: - Outlets
    @IBOutlet private(set) weak var playerContainer: UIView!
    @IBOutlet private weak var statusView: GameFeedStatusView!
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var creatorLabel: UILabel!
    @IBOutlet private weak var statsLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var overlayBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Actions
    @IBAction private func likeTapped(_ sender: UIButton) {
        onLike?()
    }
    
    // MARK: - Callbacks
    var onLike: (() -> Void)?
    
    // MARK: - Lifecycle
    override func prepareForReuse() {
        onLike = nil
        titleLabel.text = ""
        creatorLabel.text = ""
        statsLabel.text = ""
    }
    
    // MARK: - Setup
    func setup() {
        // TODO: - Add setup
    }
    
}
