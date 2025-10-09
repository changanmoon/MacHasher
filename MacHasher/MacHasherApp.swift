//
//  MacHasherApp.swift
//  MacHasher
//
//  Created by changanmoon on 07/10/2025.
//

import SwiftUI

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
                Button {
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
                } label: {
                    Text(NSLocalizedString("About MacHasher", comment: "Menu item."))
                }
                
                // A menu item for checking updates. (Needs implementation)
                //Button(NSLocalizedString("Check for updates...", comment: "Menu item.")) {
                
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
        }
    }
}
