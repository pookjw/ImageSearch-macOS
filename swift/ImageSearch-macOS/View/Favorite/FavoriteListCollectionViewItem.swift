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
    private let selectedBorderThickness: CGFloat = 10
    
    public func configure(_ searchData: SearchData) {
        self.searchData = searchData
        leftImageView.kf.indicatorType = .activity
        leftImageView.kf.setImage(with: searchData.thumbnailImage, placeholder: nil)
        view.wantsLayer = true
        view.layer?.cornerRadius = 10
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                view.layer?.borderColor = NSColor.systemPink.withAlphaComponent(0.7).cgColor
                view.layer?.borderWidth = selectedBorderThickness
            } else {
                view.layer?.borderWidth = 0
            }
        }
    }
    
    override var highlightState: NSCollectionViewItem.HighlightState {
        didSet {
            if highlightState == .forSelection {
                view.layer?.borderColor = NSColor.systemGreen.withAlphaComponent(0.7).cgColor
                view.layer?.borderWidth = selectedBorderThickness
            } else {
                if !isSelected {
                    view.layer?.borderWidth = 0
                } else {
                    view.layer?.borderColor = NSColor.systemPink.withAlphaComponent(0.7).cgColor
                }
            }
        }
    }
}
