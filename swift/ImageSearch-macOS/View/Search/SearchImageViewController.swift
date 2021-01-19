//
//  SearchImageViewController.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/16/21.
//

import Cocoa
import Quartz

class SearchImageViewController: NSViewController {
    private var imageView: IKImageView!
    private var searchData: SearchData?
    
    override func loadView() {
        view = NSView()
        view.widthAnchor.constraint(greaterThanOrEqualToConstant: 500).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImageView()
    }
    
    private func configureImageView() {
        imageView = .init()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageView.backgroundColor = .clear
        imageView.isHidden = true
        imageView.wantsLayer = true
        imageView.layer?.backgroundColor = nil
        imageView.hasVerticalScroller = true
        imageView.hasHorizontalScroller = true
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Download", action: #selector(downloadImage(_:)), keyEquivalent: ""))
        imageView.menu = menu
    }
    
    public func update(_ searchData: SearchData) {
        self.searchData = searchData
        DispatchQueue.main.async { [weak self] in
            if let url = self?.searchData?.originalImage {
                self?.imageView.setImageWith(url)
                self?.imageView.isHidden = false
                self?.imageView.zoomImageToFit(nil)
            }
        }
    }
    
    @objc func downloadImage(_ sender: AnyObject) {
        guard let searchData = searchData else { return }
        ActionModel.shared.save(searchData)
    }
}
