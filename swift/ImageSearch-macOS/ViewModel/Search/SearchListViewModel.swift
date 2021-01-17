//
//  SearchListViewModel.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/17/21.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchListViewModel {
    public var searchData: BehaviorSubject<[SearchData]> = .init(value: [.getSampleData()])
    private var disposeBag: DisposeBag = .init()
    
    init() {
        bind()
    }
    
    public func request(text: String) {
        guard !text.isEmpty else { return }
        SearchModel.shared.request(text: text, page: 1)
    }
    
    public func getSearchData() -> [SearchData] {
        guard let _searchData: [SearchData] = try? searchData.value() else {
            return []
        }
        return _searchData
    }
    
    private func bind() {
        SearchModel.shared.receivedData
            .withUnretained(self)
            .map { (weakSelf, receivedData) -> [SearchData] in
                return weakSelf.convert(receivedData: receivedData)
            }
            .bind(to: searchData)
            .disposed(by: disposeBag)
    }
    
    private func convert(receivedData: ReceivedData) -> [SearchData] {
        return receivedData.documents
            .map { document in
                SearchData(
                    title: document.display_sitename,
                    thumbnailImage: URL(string: document.thumbnail_url),
                    originalImage: URL(string: document.image_url),
                    docURL: URL(string: document.doc_url)
                )
            }
    }
}
