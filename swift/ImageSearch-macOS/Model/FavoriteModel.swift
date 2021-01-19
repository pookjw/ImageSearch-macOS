//
//  FavoriteModel.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/19/21.
//

import Foundation
import RxSwift
import WidgetKit

final class FavoriteModel {
    public static let shared: FavoriteModel = .init()
    public let searchData: BehaviorSubject<[SearchData]> = .init(value: [])
    public var searchDataSource: [SearchData] {
        get {
            return (try? searchData.value()) ?? []
        }
        set {
            saveData(with: newValue)
            searchData.onNext(newValue)
        }
    }
    private let userDefaults: UserDefaults = UserDefaults(suiteName: "group.com.pookjw.ImageSearch-macOS") ?? .standard
    private let userDefaultsKey: String = "Favorites"
    
    public func reset() {
        searchDataSource.removeAll()
        userDefaults.removeObject(forKey: userDefaultsKey)
    }
    
    private init() {
        loadData()
    }
    
    public func loadData() {
        searchDataSource = userDefaults.getObjects(forKey: userDefaultsKey)
        saveData()
    }
    
    private func saveData(with newValue: [SearchData]? = nil) {
        guard let newValue: [SearchData] = newValue else {
            userDefaults.setObjects(searchDataSource, forKey: userDefaultsKey)
            return
        }
        userDefaults.setObjects(newValue, forKey: userDefaultsKey)
    }
}
