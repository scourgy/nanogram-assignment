//
//  GameFeedDataSource.swift
//  nanogram
//
//  Created by Galin Yonchev on 6.11.26.
//

import Foundation
import UIKit

class GameFeedDataSource: NSObject, UICollectionViewDataSource {
    
    // MARK: - Dependencies
    private let viewModel: GameFeedViewModel

    // MARK: - Initialization
    init(viewModel: GameFeedViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    // MARK: - Data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameFeedCell.identifier, for: indexPath) as? GameFeedCell else {
            fatalError("[ERROR] Not a GameFeedCell.")
        }
        let index = indexPath.item
        cell.configure(with: viewModel.game(at: index), isLiked: viewModel.isLiked(at: index))
        cell.onLike = { [weak self] in
            self?.viewModel.toggleLike(at: indexPath.item)
        }
        return cell
    }
    
}
