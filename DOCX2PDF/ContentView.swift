//
//  ContentView.swift
//  DOCX2PDF
//
//  Created on 2026-01-04.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var selectedInputFile: URL?
    @State private var selectedOutputDirectory: URL?
    @State private var statusMessage: String = "Select a DOCX file to convert"
    @State private var isConverting: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    private let converter = DocumentConverter()
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("DOCX to PDF Converter")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
            
            Divider()
            
            // Input file selection
            VStack(alignment: .leading, spacing: 10) {
                Text("Input File:")
                    .font(.headline)
                
                HStack {
                    Text(selectedInputFile?.lastPathComponent ?? "No file selected")
                        .foregroundColor(selectedInputFile == nil ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                    
                    Button("Browse...") {
                        selectInputFile()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(.horizontal)
            
            // Output directory selection
            VStack(alignment: .leading, spacing: 10) {
                Text("Output Directory:")
                    .font(.headline)
                
                HStack {
                    Text(selectedOutputDirectory?.path ?? "Same as input file")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(5)
                    
                    Button("Browse...") {
                        selectOutputDirectory()
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(.horizontal)
            
            // Convert button
            Button(action: convertDocument) {
                HStack {
                    if isConverting {
                        ProgressView()
                            .scaleEffect(0.8)
                            .padding(.trailing, 5)
                    }
                    Text(isConverting ? "Converting..." : "Convert to PDF")
                        .font(.headline)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .buttonStyle(.borderedProminent)
            .disabled(selectedInputFile == nil || isConverting)
            .padding(.horizontal)
            .padding(.top, 10)
            
            // Status message
            VStack(spacing: 5) {
                Text(statusMessage)
                    .font(.body)
                    .foregroundColor(showError ? .red : .secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                if showError && !errorMessage.isEmpty {
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .frame(minHeight: 60)
            
            Spacer()
            
            // Footer with info
            VStack(spacing: 5) {
                Divider()
                Text("Powered by LibreOffice")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Licensed under LGPL")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .padding(.bottom, 10)
        }
        .frame(width: 500, height: 450)
    }
    
    private func selectInputFile() {
        let panel = NSOpenPanel()
        panel.title = "Select a DOCX file"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [
            UTType(filenameExtension: "docx") ?? .data
        ]
        
        if panel.runModal() == .OK {
            selectedInputFile = panel.url
            statusMessage = "File selected: \(panel.url?.lastPathComponent ?? "")"
            showError = false
            errorMessage = ""
        }
    }
    
    private func selectOutputDirectory() {
        let panel = NSOpenPanel()
        panel.title = "Select output directory"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        
        if panel.runModal() == .OK {
            selectedOutputDirectory = panel.url
            statusMessage = "Output directory: \(panel.url?.path ?? "")"
        }
    }
    
    private func convertDocument() {
        guard let inputURL = selectedInputFile else { return }
        
        isConverting = true
        showError = false
        errorMessage = ""
        statusMessage = "Converting document..."
        
        // Determine output directory
        let outputDir = selectedOutputDirectory ?? inputURL.deletingLastPathComponent()
        
        Task {
            do {
                let outputURL = try await converter.convertToPDF(inputURL: inputURL, outputDirectory: outputDir)
                
                await MainActor.run {
                    isConverting = false
                    statusMessage = "✓ Conversion successful!"
                    showError = false
                    
                    // Show the file in Finder
                    NSWorkspace.shared.activateFileViewerSelecting([outputURL])
                }
            } catch {
                await MainActor.run {
                    isConverting = false
                    showError = true
                    statusMessage = "✗ Conversion failed"
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
