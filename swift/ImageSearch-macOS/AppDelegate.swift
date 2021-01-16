//
//  AppDelegate.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/16/21.
//

import Cocoa

class AppDelegate: NSObject, NSApplicationDelegate {
    private var searchWindow: SearchWindow?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        searchWindow = SearchWindow()
        searchWindow?.makeKeyAndOrderFront(nil)
    }
}
