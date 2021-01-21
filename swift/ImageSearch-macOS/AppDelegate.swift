//
//  AppDelegate.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/16/21.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var searchWindow: SearchWindow?
    private lazy var statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        configureMainMenu()
        configureStatusBarItem()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        configureWindow()
    }
    
    private func configureWindow() {
        searchWindow = SearchWindow()
        searchWindow?.makeKeyAndOrderFront(nil)
    }
    
    private func configureMainMenu() {
        let customMenu: CustomMenu = .init(title: "")
        customMenu.updateMenu(for: .search)
        NSApp.mainMenu = customMenu
    }
    
    private func configureStatusBarItem() {
        statusItem.button?.title = "⭐️"
        statusItem.button?.action = #selector(showFavoritePopover(_:))
    }
    
    @objc private func showFavoritePopover(_ sender: Any) {
        let vc: FavoriteListViewController = .init()
        let popover: NSPopover = .init()
        popover.contentViewController = vc
        popover.behavior = .transient
        popover.show(relativeTo: statusItem.button!.bounds, of: statusItem.button!, preferredEdge: .maxY)
    }
}
