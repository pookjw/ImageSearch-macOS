//
//  ActionModel.swift
//  ImageSearch-macOS
//
//  Created by Jinwoo Kim on 1/20/21.
//

import Cocoa

final class ActionModel {
    public static let shared: ActionModel = .init()
    
    private init() {}
    
    public func save(_ searchData: SearchData) {
        DispatchQueue.global().async {
            guard let imageURL: URL = searchData.originalImage,
                  let data: Data = try? .init(contentsOf: imageURL),
                  let image: NSImage = NSImage(data: data),
                  let tiffData: Data = image.tiffRepresentation,
                  let imageRep: NSBitmapImageRep = NSBitmapImageRep(data: tiffData),
                  let png: Data = imageRep.representation(using: .png, properties: [:])
                  else { return }
        
            DispatchQueue.main.async {
                let panel: NSSavePanel = .init()
                panel.allowedFileTypes = ["png"]
                
                panel.begin { result in
                    if result == .OK {
                        guard let url = panel.url else { return }
                        
                        do {
                            try png.write(to: url)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    public func openDoc(_ searchData: SearchData) {
        guard let url: URL = searchData.docURL else { return }
        DispatchQueue.main.async {
            NSWorkspace.shared.open(url)
        }
    }
}
