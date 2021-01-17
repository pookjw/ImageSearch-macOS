//
//  SearchWindow.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/16/21.
//

import Cocoa

class SearchWindow: NSWindow {
    convenience init() {
        self.init(
            contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
            styleMask: [.miniaturizable, .closable, .resizable, .titled],
            backing: .buffered,
            defer: false
        )
        contentMinSize = CGSize(width: 800, height: 600)
        contentViewController = SearchSplitViewController()
        title = "ImageSearch-macOS"
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        isMovableByWindowBackground = true
        styleMask = [styleMask, .fullSizeContentView]
        
        delegate = self
    }
}

extension SearchWindow: NSWindowDelegate {
    func windowDidBecomeMain(_ notification: Notification) {
        if let searchMenu = NSApp.mainMenu as? SearchMenu {
            searchMenu.updateMenu(for: .search)
        }
    }
}
