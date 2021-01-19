//
//  Array+moveItem.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/20/21.
//

import Foundation

extension Array {
    mutating func moveItem(from: Int, to: Int) {
        let item = self[from]
        remove(at: from)
        
        if to <= from {
            insert(item, at: to)
        } else {
            insert(item, at: to - 1)
        }
    }
}
