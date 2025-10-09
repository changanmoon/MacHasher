//
//  AboutView.swift
//  MacHasher
//
//  Created by changanmoon on 07/10/2025.
//

import SwiftUI
import AppKit

struct VisualEffectView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let effectView = NSVisualEffectView()
        effectView.material = .sidebar
        effectView.state = .followsWindowActiveState
        effectView.blendingMode = .withinWindow
        return effectView
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

struct AboutView: View {
    @State private var isShowingAcknowledgments = false
    @State private var isShowingLicense = false
    
    @Environment(\.colorScheme) var colorScheme
    
    private func getInfoString(for key: String) -> String {
        Bundle.main.infoDictionary?[key] as? String ?? ""
    }
    
    var appName: String { getInfoString(for: "CFBundleName") }
    var appVersion: String { getInfoString(for: "CFBundleShortVersionString") }
    var appBuild: String { getInfoString(for: "CFBundleVersion") }
    var appCopyright: String { getInfoString(for: "NSHumanReadableCopyright") }
    
    private var gitRepoLink: URL {
        URL(string: "https://github.com/changanmoon/MacHasher")!
    }
    
    var body: some View {
        ZStack {
            VisualEffectView().clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous)).shadow(radius: 10).ignoresSafeArea()
            
            HStack(alignment: .center, spacing: 28) {
                Group {
                    if let image = NSImage(named: "AppIcon") {
                        Image(nsImage: image)
                            .resizable()
                            .frame(width: 88, height: 88)
                            .accessibilityLabel(Text(NSLocalizedString("App Icon", comment: "App icon accessibility label")))
                    } else {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 88, height: 88)
                            .overlay(
                                Image(systemName: "questionmark.square.dashed")
                                    .font(.system(size: 40))
                                    .foregroundColor(.secondary)
                            )
                    }
                }.padding(.leading, 10)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(appName).font(.title).bold()
                    
                    Text(
                        String(
                            format: NSLocalizedString("Version %@ (%@)", comment: "About window: version and build number"),
                            appVersion, appBuild
                        )
                    ).font(.subheadline).foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text(
                        String(
                            format: NSLocalizedString(
                                "Copyright © 2025 changanmoon. All rights reserved.\nMacHasher is an open source project, licensed under the Apache License Version 2.0.\n“Apple”, “Apple Logo”, “Mac” and “macOS” are trademarks of Apple Inc.",
                                comment: "About window: copyright and legal"
                            ),
                            appCopyright
                        )
                    ).font(.footnote).foregroundColor(.secondary).fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    HStack(spacing: 18) {
                        // For the credit part, this will be implemented in the future.
                        Button(NSLocalizedString("View source code on GitHub", comment: "Button")){
                            NSWorkspace.shared.open(gitRepoLink)
                        }
                    }.padding(.top, 8)
                }.padding([.trailing, .vertical], 10)
            }.padding(20)
        }.frame(width: 600, height: 210)
        .navigationTitle(NSLocalizedString("About MacHasher", comment: "About window title"))
        .background(Color.clear)
    }
}

#Preview {
    Group {
        AboutView()
    }
}
