//
//  FileChooser.swift
//  MacHasher
//
//  Created by changanmoon on 07/10/2025.
//

import Foundation
import AppKit

// A function to select directory
func selectDirectory() -> String? {
    // Open a file browser panel to choose a folder (not to choose a file).
    let panel = NSOpenPanel()
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    panel.canChooseFiles = true
    panel.canSelectHiddenExtension = true
    panel.showsHiddenFiles = true
    
    let result = panel.runModal()
    
    if result == .OK {
        if let str = panel.url?.absoluteString {
            let path = str.components(separatedBy: "file://").joined()
            return path.removingPercentEncoding ?? path
        }
    }
    return nil
}
