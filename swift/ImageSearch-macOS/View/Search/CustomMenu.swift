//
//  CustomMenu.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/17/21.
//

import Cocoa

class CustomMenu: NSMenu {
    public weak var openURLMenuItem: NSMenuItem?
    public weak var downloadImageMenuItem: NSMenuItem?
    
    enum WindowType {
        case search
    }
    
    override init(title: String) {
        super.init(title: title)
        items = [getAppMenuItem()]
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var applicationName: String {
        return ProcessInfo.processInfo.processName
    }
    
    public func updateMenu(for type: WindowType) {
        switch type {
        case .search:
            setSearchMenu()
        }
    }
    
    private func setSearchMenu() {
        let openURLMenuItem: NSMenuItem = .init(title: "Open URL", action: nil, keyEquivalent: "")
        self.openURLMenuItem = openURLMenuItem
        
        let downloadImageMenuItem: NSMenuItem = .init(title: "Download image", action: nil, keyEquivalent: "")
        self.downloadImageMenuItem = downloadImageMenuItem
        
        let resetFavoritesMenuItem: NSMenuItem = .init(title: "Reset Favorites", action: #selector(resetFavorites(_:)), keyEquivalent: "")
        resetFavoritesMenuItem.target = self
        
        let searchMenuItem: NSMenuItem = .init()
        searchMenuItem.submenu = NSMenu(title: "File")
        searchMenuItem.submenu?.items = [
            openURLMenuItem,
            downloadImageMenuItem,
            NSMenuItem.separator(),
            resetFavoritesMenuItem
        ]
        
        items = [getAppMenuItem(), searchMenuItem]
    }
    
    private func getAppMenuItem() -> NSMenuItem {
        let appMenuItem: NSMenuItem = .init()
        appMenuItem.submenu = NSMenu(title: applicationName)
        appMenuItem.submenu?.items = [
            NSMenuItem(title: "About \(applicationName)", action: #selector(NSApp.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Hide \(applicationName)", action: #selector(NSApp.hide(_:)), keyEquivalent: ""),
            NSMenuItem(title: "Hide Others", action: #selector(NSApp.hideOtherApplications(_:)), keyEquivalent: ""),
            NSMenuItem.separator(),
            NSMenuItem(title: "Quit \(applicationName)", action: #selector(NSApp.terminate(_:)), keyEquivalent: "")
        ]
        
        return appMenuItem
    }
    
    @objc private func resetFavorites(_ sender: AnyObject) {
        FavoriteModel.shared.reset()
    }
}
