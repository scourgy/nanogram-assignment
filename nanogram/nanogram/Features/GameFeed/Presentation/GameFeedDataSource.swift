//
//  GameFeedDataSource.swift
//  nanogram
//
//  Created by Galin Yonchev on 6.11.26.
//

import Foundation
import UIKit

class GameFeedDataSource: NSObject, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}
