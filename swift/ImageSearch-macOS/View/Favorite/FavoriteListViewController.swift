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
    
    override func keyUp(with event: NSEvent) {
        super.keyUp(with: event)
        
        guard FavoriteModel.shared.searchDataSource.count > 0 else { return }
        guard let deleteUnicodeScalar: UnicodeScalar = UnicodeScalar(NSDeleteCharacter) else { return }
        
        if event.charactersIgnoringModifiers == String(deleteUnicodeScalar) {
            let selectedIndexPaths: Set<IndexPath> = collectionView.selectionIndexPaths
            viewModel.removeItems(with: selectedIndexPaths)
        }
    }
    
    private func configureCollectionView() {
        collectionView = .init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.wantsLayer = true
        collectionView.layer?.backgroundColor = .clear
        collectionView.isSelectable = true
        collectionView.allowsEmptySelection = true
        collectionView.allowsMultipleSelection = true
        collectionView.registerForDraggedTypes([NSPasteboard.PasteboardType(kUTTypeURL as String)])
        
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
    
    // Dragging
    func collectionView(_ collectionView: NSCollectionView, validateDrop draggingInfo: NSDraggingInfo, proposedIndexPath proposedDropIndexPath: AutoreleasingUnsafeMutablePointer<NSIndexPath>, dropOperation proposedDropOperation: UnsafeMutablePointer<NSCollectionView.DropOperation>) -> NSDragOperation {
        return .move
    }
    
    func collectionView(_ collectionView: NSCollectionView, draggingSession session: NSDraggingSession, willBeginAt screenPoint: NSPoint, forItemsAt indexPaths: Set<IndexPath>) {
        viewModel.itemsBeingDragged = indexPaths
    }
    
    func collectionView(_ collectionView: NSCollectionView, acceptDrop draggingInfo: NSDraggingInfo, indexPath: IndexPath, dropOperation: NSCollectionView.DropOperation) -> Bool {
        guard let itemsBeingDragged: Set<IndexPath> = viewModel.itemsBeingDragged else { return false }
        viewModel.performInternalDrag(with: itemsBeingDragged, to: indexPath)
        return true
    }
    
    func collectionView(_ collectionView: NSCollectionView, pasteboardWriterForItemAt indexPath: IndexPath) -> NSPasteboardWriting? {
        guard let imageURL: URL = viewModel.getFavorite(idx: indexPath.item)?.originalImage else {
            return nil
        }
        return imageURL as NSPasteboardWriting
    }
}
