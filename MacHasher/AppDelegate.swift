//
//  AppDelegate.swift
//  MacHasher
//
//  Created by changanmoon on 07/10/2025.
//

import Foundation
import AppKit
import SwiftUI

// Use AppDelegate.
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Disable app's tab feature.
        NSWindow.allowsAutomaticWindowTabbing = false
    }
    
    // Set to exit the application when all the windows are closed.
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
