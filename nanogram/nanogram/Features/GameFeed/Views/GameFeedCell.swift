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
    static var nib: UINib { UINib(nibName: "GameFeedCell", bundle: nil) }
    
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
    override func awakeFromNib() {
         super.awakeFromNib()
         statusView.isHidden = true
     }
    
    override func prepareForReuse() {
        onLike = nil
        titleLabel.text = ""
        creatorLabel.text = ""
        statsLabel.text = ""
        likeButton.isSelected = false
        setPlayMode(false)
    }
    
    // MARK: - Setup
    func configure(with game: Game, isLiked: Bool) {
        titleLabel.text = game.title
        
        creatorLabel.text = game.creator.map { "@\($0.username)" }
        creatorLabel.isHidden = game.creator == nil
        
        likeButton.isSelected = isLiked
        
        let likes = game.stats.likes + (isLiked ? 1 : 0)
        statsLabel.text = "\(game.stats.plays) plays | \(likes) likes"
    }
    
    func setPlayMode(_ isPlayMode: Bool) {
        overlayView.isHidden = isPlayMode
    }
    
}
