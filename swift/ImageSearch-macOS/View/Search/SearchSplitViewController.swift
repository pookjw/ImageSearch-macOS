//
//  SearchSplitViewController.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/16/21.
//

import Cocoa

class SearchSplitViewController: NSSplitViewController {
    public weak var listViewController: SearchListViewController?
    public weak var imageViewController: SearchImageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
    }
    
    private func addViewControllers() {
        splitViewItems.removeAll()
        
        let listViewController: SearchListViewController = .init()
        let imageViewController: SearchImageViewController = .init()
        
        self.listViewController = listViewController
        self.imageViewController = imageViewController
        
        let listViewItem: NSSplitViewItem = .init(viewController: listViewController)
        let imageViewItem: NSSplitViewItem = .init(viewController: imageViewController)
        imageViewItem.holdingPriority = .fittingSizeCompression
        
        splitViewItems.append(listViewItem)
        splitViewItems.append(imageViewItem)
    }
}
