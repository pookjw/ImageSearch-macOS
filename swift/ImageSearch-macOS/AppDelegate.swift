//
//  AppDelegate.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/16/21.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var searchWindow: SearchWindow?
    
    func applicationWillFinishLaunching(_ notification: Notification) {
        configureMainMenu()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        configureWindow()
    }
    
    private func configureWindow() {
        searchWindow = SearchWindow()
        searchWindow?.makeKeyAndOrderFront(nil)
    }
    
    private func configureMainMenu() {
        NSApp.mainMenu = SearchMenu(title: "")
    }
}
