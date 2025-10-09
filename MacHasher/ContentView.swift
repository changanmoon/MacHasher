//
//  ContentView.swift
//  MacHasher
//
//  Created by changanmoon on 07/10/2025.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @State private var filePath: String = ""
    @State private var md5: String = ""
    @State private var sha1: String = ""
    @State private var sha256: String = ""
    @State private var sha512: String = ""
    @State private var isCalculating: Bool = false
    @State private var showErrorAlert: Bool = false
    
    // Clear textboxes (except "File Path" section)
    func clear() {
        md5 = ""
        sha1 = ""
        sha256 = ""
        sha512 = ""
    }
    
    // Copy the checksum values to the clipboard
    func copyToClipboard(_ value: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(value, forType: .string)
    }
    
    func calculateAsync() {
        guard !filePath.isEmpty else { return }
        isCalculating = true
        clear()
        
        Task {
            do {
                let url = URL(fileURLWithPath: filePath)
                
                async let md5Value = try url.checksum(with: .md5, filePath: filePath)
                async let sha1Value = try url.checksum(with: .sha1, filePath: filePath)
                async let sha256Value = try url.checksum(with: .sha256, filePath: filePath)
                async let sha512Value = try url.checksum(with: .sha512, filePath: filePath)
                
                let (md5Result, sha1Result, sha256Result, sha512Result) = try await (md5Value, sha1Value, sha256Value, sha512Value)
                
                DispatchQueue.main.async {
                    self.md5 = md5Result
                    self.sha1 = sha1Result
                    self.sha256 = sha256Result
                    self.sha512 = sha512Result
                    self.isCalculating = false
                }
            } catch {
                DispatchQueue.main.async {
                    clear()
                    isCalculating = false
                    showErrorAlert = true
                }
            }
        }
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(NSLocalizedString("File: ", comment: ""))
                    
                    TextField(NSLocalizedString("Choose file...", comment: ""), text: $filePath).disableAutocorrection(true) // Don't implement auto-correction.
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 250)
                        .disabled(isCalculating)
                    
                    Button(NSLocalizedString("Change path", comment: "")) {
                        if let selected = selectDirectory() {
                            self.filePath = selected
                            clear()
                            calculateAsync()
                        }
                    }.disabled(isCalculating)
                    
                    Button(NSLocalizedString("Calculate", comment: "")) {
                        clear()
                        calculateAsync()
                    }.disabled(isCalculating || filePath.isEmpty)
                }.padding(10)

                HStack {
                    Text(NSLocalizedString("md5: ", comment: ""))
                    
                    TextField(NSLocalizedString("md5 goes here...", comment: ""), text: $md5)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 350)
                        .disabled(true)
                    
                    Button(NSLocalizedString("Copy", comment: "Button")) {
                        copyToClipboard(md5)
                    }.disabled(md5.isEmpty || isCalculating)
                }.padding(10)

                HStack {
                    Text(NSLocalizedString("sha1: ", comment: ""))
                    
                    TextField(NSLocalizedString("sha1 goes here...", comment: ""), text: $sha1)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 350)
                        .disabled(true)
                    
                    Button(NSLocalizedString("Copy", comment: "Button")) {
                        copyToClipboard(sha1)
                    }.disabled(sha1.isEmpty || isCalculating)
                }.padding(10)

                HStack {
                    Text(NSLocalizedString("sha256: ", comment: ""))
                    
                    TextField(NSLocalizedString("sha256 goes here...", comment: ""), text: $sha256)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 350)
                        .disabled(true)
                    
                    Button(NSLocalizedString("Copy", comment: "Button")) {
                        copyToClipboard(sha256)
                    }.disabled(sha256.isEmpty || isCalculating)
                }.padding(10)

                HStack {
                    Text(NSLocalizedString("sha512: ", comment: ""))
                    
                    TextField(NSLocalizedString("sha512 goes here...", comment: ""), text: $sha512)
                        .disableAutocorrection(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(minWidth: 350)
                        .disabled(true)
                    
                    Button(NSLocalizedString("Copy", comment: "Button")) {
                        copyToClipboard(sha512)
                    }.disabled(sha512.isEmpty || isCalculating)
                }.padding(10)
            }.padding(10).toolbar{
                ToolbarItemGroup(placement: .automatic) {
                    Button(NSLocalizedString("Clear", comment: "Button"), systemImage: "trash") {
                        clear()
                    }.disabled(isCalculating)
                }
            }
            
            // Overlay for progress.
            if isCalculating {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                VStack {
                    ProgressView(NSLocalizedString("Calculating...", comment: ""))
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(30)
                        .background(VisualEffectBlur())
                        .cornerRadius(16)
                        .shadow(radius: 20)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }.alert(isPresented: $showErrorAlert) {
            Alert(
                title: Text(NSLocalizedString("Error", comment: "")),
                message: Text(NSLocalizedString("Failed to calculate checksums. The file may not exist or is unreadable.", comment: "")),
                dismissButton: .default(Text(NSLocalizedString("OK", comment: "")))
            )
        }
    }
}

// Use VisualEffectBlur,a reusable wrapper for macOS blur effect.
struct VisualEffectBlur: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .hudWindow // or .popover or .sidebar
        view.blendingMode = .withinWindow
        view.state = .active
        return view
    }
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

#Preview {
    ContentView()
}
