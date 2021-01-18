//
//  CustomMenu.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/17/21.
//

import Cocoa

class CustomMenu: NSMenu {
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
        let resetFavoritesMenuItem: NSMenuItem = .init(title: "Reset Favorites", action: #selector(resetFavorites(_:)), keyEquivalent: "")
        resetFavoritesMenuItem.target = self
        
        let searchMenuItem: NSMenuItem = .init()
        searchMenuItem.submenu = NSMenu(title: "File")
        searchMenuItem.submenu?.items = [
            NSMenuItem(title: "Open URL", action: nil, keyEquivalent: ""),
            NSMenuItem(title: "Download image", action: nil, keyEquivalent: ""),
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
