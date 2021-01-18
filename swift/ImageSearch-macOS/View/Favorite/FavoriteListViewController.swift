//
//  FavoriteListViewController.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/18/21.
//

import Cocoa
import RxSwift

class FavoriteListViewController: NSViewController {
    private var collectionView: NSCollectionView!
    private let viewModel: FavoriteListViewModel = .init()
    private var disposeBag: DisposeBag = .init()

    override func loadView() {
        self.view = NSView()
        self.view.frame = .init(x: 0, y: 0, width: 600, height: 400)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }
    
    private func configureCollectionView() {
        collectionView = .init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.wantsLayer = true
        collectionView.layer?.backgroundColor = .clear
        
        let flowLayout: NSCollectionViewFlowLayout = .init()
        flowLayout.itemSize = .init(width: 128, height: 128)
//        flowLayout.estimatedItemSize = .init(width: 128, height: 128)
        collectionView.collectionViewLayout = flowLayout
        
        let identifier: NSUserInterfaceItemIdentifier = .init("Favorite")
        collectionView.register(NSNib(nibNamed: "FavoriteListCollectionViewItem", bundle: .main), forItemWithIdentifier: identifier)
        
        let scrollView: NSScrollView = .init()
        scrollView.documentView = collectionView
        scrollView.autohidesScrollers = true
        scrollView.hasVerticalScroller = true
        scrollView.wantsLayer = true
        scrollView.layer?.backgroundColor = .clear
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func bind() {
        FavoriteModel.shared.searchData
            .withUnretained(self)
            .subscribe(onNext: { (weakSelf, _) in
                weakSelf.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
}

extension FavoriteListViewController: NSCollectionViewDelegate, NSCollectionViewDataSource {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return FavoriteModel.shared.searchDataSource.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell: FavoriteListCollectionViewItem
        if let rcell = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier("Favorite"), for: indexPath) as? FavoriteListCollectionViewItem {
            cell = rcell
        } else {
            cell = FavoriteListCollectionViewItem.fromNib()
        }

        guard let searchData: SearchData = viewModel.getFavorite(idx: indexPath.item) else {
            cell.configure(.getSampleData())
            return cell
        }
        
        cell.configure(searchData)
        return cell
    }
}
