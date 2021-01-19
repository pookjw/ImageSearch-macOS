//
//  FavoriteListViewModel.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/19/21.
//

import Foundation

final class FavoriteListViewModel {
    public var itemsBeingDragged: Set<IndexPath>?
    
    public func getFavorite(idx: Int) -> SearchData? {
        guard idx < FavoriteModel.shared.searchDataSource.count else {
            return nil
        }
        return FavoriteModel.shared.searchDataSource[idx]
    }
    
    public func performInternalDrag(with items: Set<IndexPath>, to indexPath: IndexPath) {
        var tempDataSource: [SearchData] = FavoriteModel.shared.searchDataSource
        var targetIndex = indexPath.item
        
        items.sorted().forEach { fromIndexPath in
            let fromItemIndex = fromIndexPath.item
            
            if (fromItemIndex > targetIndex) {
                tempDataSource.moveItem(from: fromItemIndex, to: targetIndex)
                targetIndex += 1
            }
        }
        
        items.sorted().reversed().forEach { fromIndexPath in
            let fromItemIndex = fromIndexPath.item
            
            if (fromItemIndex < targetIndex) {
                tempDataSource.moveItem(from: fromItemIndex, to: targetIndex)
                targetIndex -= 1
            }
        }
        
        FavoriteModel.shared.searchDataSource = tempDataSource
    }
    
    public func removeItems(with indexPaths: Set<IndexPath>) {
        var tempDataSource: [SearchData] = FavoriteModel.shared.searchDataSource
        indexPaths.sorted().reversed().forEach { indexPath in
            tempDataSource.remove(at: indexPath.item)
        }
        FavoriteModel.shared.searchDataSource = tempDataSource
    }
}
