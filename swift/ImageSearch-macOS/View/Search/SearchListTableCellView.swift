//
//  SearchListTableCellView.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/17/21.
//

import Cocoa
import Kingfisher

class SearchListTableCellView: NSTableCellView {
    @IBOutlet weak var leftImageView: NSImageView!
    @IBOutlet weak var mainTextField: NSTextField!
    @IBOutlet weak var subTitleField: NSTextField!
    
    public var searchData: SearchData?
    
    public func configure(_ searchData: SearchData) {
        self.searchData = searchData
        leftImageView.kf.setImage(with: searchData.thumbnailImage)
        mainTextField.stringValue = searchData.title ?? "(nil)"
        subTitleField.stringValue = searchData.docURL?.absoluteString ?? "(nil)"
    }
    
    override func rightMouseDown(with event: NSEvent) {
        super.rightMouseDown(with: event)
        let menu: NSMenu = .init(title: "Menu")
        NSMenu.popUpContextMenu(menu, with: event, for: self)
    }
    
    override func mouseDown(with event: NSEvent) {
        let menu: NSMenu = .init(title: "Menu")
        NSMenu.popUpContextMenu(menu, with: event, for: self)
    }
}
