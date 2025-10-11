//
//  MacHasherApp.swift
//  MacHasher
//
//  Created by changanmoon on 07/10/2025.
//

import Foundation
import SwiftUI
import AppKit

extension Scene {
    func windowResizabilityContentSize() -> some Scene {
        if #available(macOS 13.0, *) {
            return windowResizability(.contentSize)
        } else {
            return self
        }
    }
}

@main
struct MacHasherApp: App {
    // Use AppDelegate.
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // Use colorScheme environment key.
    @Environment(\.colorScheme) var colorScheme
    
    private var gitRepoLink: URL {
        URL(string: "https://github.com/changanmoon/MacHasher")!
    }
    
    // Create a NSWindow that shows "About" window.
    let aboutWindow = NSWindow(contentViewController: NSHostingController(rootView: AboutView()))
    
    var body: some Scene {
        WindowGroup {
            ContentView().presentedWindowToolbarStyle(.unified)
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification), perform: { _ in
                    for window in NSApplication.shared.windows {
                        // Disable the "full screen" button in the main window.
                        // NOTE: This implementation is applied universally!
                        window.standardWindowButton(.zoomButton)?.isEnabled = false
                    }
                })
        }.windowResizabilityContentSize().windowToolbarStyle(.unified)
            .commands {
                // Set to replace Application menu.
                CommandGroup(replacing: .appInfo) {
                    Button(NSLocalizedString("About MacHasher", comment: "Menu item."), systemImage: "info.circle") {
                        // Set the About window as a borderless "full content" style mask window.
                        aboutWindow.styleMask.insert(.fullSizeContentView)
                        
                        // Disable minimize button and full screen button.
                        aboutWindow.standardWindowButton(.miniaturizeButton)?.isEnabled = false
                        aboutWindow.standardWindowButton(.zoomButton)?.isEnabled = false
                        
                        // Set the window’s background color to clear.
                        aboutWindow.backgroundColor = .clear
                        
                        // Do not show its title.
                        aboutWindow.titleVisibility = .visible
                        aboutWindow.title = NSLocalizedString("About MacHasher", comment: "")
                        
                        // Make titlebar not visible (transparent).
                        aboutWindow.titlebarAppearsTransparent = true
                        
                        // Show AboutView window. (This could avoid the problem of duplicating windows when clicking multiple times on this menu item.)
                        aboutWindow.makeKeyAndOrderFront(nil)
                    }
                    
                    // A menu item for checking updates. (Needs implementation)
                    //Button(NSLocalizedString("Check for updates...", comment: "Menu item. (Will be implemented in the future)")) {
                    
                    //}
                }
                
                // Delete "Services" menu item.
                CommandGroup(replacing: .systemServices) {
                    // Leave it blank because we don't need this.
                }
                
                // Delete other items of the "File" menu.
                CommandGroup(replacing: .newItem) {
                    // Leave it blank because we don't need this.
                }
                
                // Delete toggle sidebar menu item.
                CommandGroup(replacing: .sidebar) {
                    // Leave it blank because we don't need this.
                }
                
                // Redesign the help menu.
                CommandGroup(replacing: .help) {
                    // We do have a help book, so let macOS open it.
                    Button(NSLocalizedString("MacHasher Help", comment: "Menu item."), systemImage: "book.pages") {
                        // MARK: Help wanted!
                        // Typically, NSHelpManager.shared.openHelpAnchor(anchor_string, inBook: "YourHelpBookName") may also work here (`anchor_string` is the help book anchor, which is defined in the HTML help pages, and any anchor should not to be ambiguous with others)
                        // However, as long as I implement in this way, when running the app, the help bundle cannot be found.
                        // If anyone could explain this, please contact with me in an issue or a pull request, thank you!
                        
                        // Use another way to open Help book.
                        NSWorkspace.shared.open(URL(string: "help:openbook=%22moe.changanmoon.MacHasherHelp%22")!)
                    }
                    
                    Divider()
                    
                    Button(NSLocalizedString("View source code on GitHub", comment: "Menu item."), systemImage: "ellipsis.curlybraces") {
                        NSWorkspace.shared.open(gitRepoLink)
                    }
                }
            }
    }
}
