//
//  FavoriteListCollectionViewItem.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/18/21.
//

import Cocoa
import Kingfisher

class FavoriteListCollectionViewItem: NSCollectionViewItem {
    @IBOutlet weak var leftImageView: NSImageView!
    public var searchData: SearchData?
    
    public func configure(_ searchData: SearchData) {
        self.searchData = searchData
        leftImageView.kf.indicatorType = .activity
        leftImageView.kf.setImage(with: searchData.thumbnailImage, placeholder: nil)
    }
}
