//
//  FavoriteListViewModel.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/19/21.
//

import Foundation

final class FavoriteListViewModel {
    public func getFavorite(idx: Int) -> SearchData? {
        guard idx < FavoriteModel.shared.searchDataSource.count else {
            return nil
        }
        return FavoriteModel.shared.searchDataSource[idx]
    }
}
