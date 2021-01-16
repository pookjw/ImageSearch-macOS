//
//  NSView+fromNib.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/17/21.
//

import Cocoa

extension NSView {
    class func fromNib() -> Self {
        var topLevelObjects: NSArray? = NSArray()
        Bundle.main.loadNibNamed(String(describing: Self.self), owner: self, topLevelObjects: &topLevelObjects)
        let views = (topLevelObjects! as Array).filter { $0 is NSView }
        return views[0] as! Self
    }
}
