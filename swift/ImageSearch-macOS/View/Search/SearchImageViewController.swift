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
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Download", action: #selector(downloadImage(_:)), keyEquivalent: ""))
        imageView.menu = menu
    }
    
    public func update(_ searchData: SearchData) {
        self.searchData = searchData
        if let url = searchData.originalImage {
            imageView.setImageWith(url)
            imageView.isHidden = false
        }
    }
    
    @objc func downloadImage(_ sender: AnyObject) {
        
    }
}