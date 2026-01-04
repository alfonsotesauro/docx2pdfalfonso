//
//  DocumentConverter.swift
//  DOCX2PDF
//
//  Created on 2026-01-04.
//

import Foundation

enum ConversionError: LocalizedError {
    case libreOfficeNotFound
    case conversionFailed(String)
    case fileAccessDenied
    case invalidInput
    case outputNotGenerated
    
    var errorDescription: String? {
        switch self {
        case .libreOfficeNotFound:
            return "LibreOffice is not installed or not found in the application bundle. Please ensure LibreOffice is properly installed."
        case .conversionFailed(let details):
            return "Conversion failed: \(details)"
        case .fileAccessDenied:
            return "Cannot access the file. Please check file permissions."
        case .invalidInput:
            return "Invalid input file. Please select a valid DOCX file."
        case .outputNotGenerated:
            return "PDF file was not generated. Please check if the input file is valid."
        }
    }
}

class DocumentConverter {
    
    /// Converts a DOCX file to PDF using LibreOffice
    /// - Parameters:
    ///   - inputURL: URL of the input DOCX file
    ///   - outputDirectory: Directory where the PDF should be saved
    /// - Returns: URL of the generated PDF file
    func convertToPDF(inputURL: URL, outputDirectory: URL) async throws -> URL {
        // Verify input file exists and is readable
        guard FileManager.default.fileExists(atPath: inputURL.path) else {
            throw ConversionError.invalidInput
        }
        
        // Ensure output directory exists
        try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true)
        
        // Find LibreOffice
        let soffice = try findLibreOffice()
        
        // Start accessing security-scoped resources
        let inputAccessed = inputURL.startAccessingSecurityScopedResource()
        let outputAccessed = outputDirectory.startAccessingSecurityScopedResource()
        
        defer {
            if inputAccessed {
                inputURL.stopAccessingSecurityScopedResource()
            }
            if outputAccessed {
                outputDirectory.stopAccessingSecurityScopedResource()
            }
        }
        
        // Prepare conversion process
        let process = Process()
        process.executableURL = soffice
        
        // LibreOffice command line arguments for headless conversion
        process.arguments = [
            "--headless",
            "--convert-to", "pdf",
            "--outdir", outputDirectory.path,
            inputURL.path
        ]
        
        // Capture output for debugging
        let outputPipe = Pipe()
        let errorPipe = Pipe()
        process.standardOutput = outputPipe
        process.standardError = errorPipe
        
        // Run the conversion
        return try await withCheckedThrowingContinuation { continuation in
            do {
                try process.run()
                
                process.terminationHandler = { proc in
                    let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
                    let errorOutput = String(data: errorData, encoding: .utf8) ?? ""
                    
                    if proc.terminationStatus == 0 {
                        // Success - find the output PDF
                        let inputFileName = inputURL.deletingPathExtension().lastPathComponent
                        let outputURL = outputDirectory.appendingPathComponent("\(inputFileName).pdf")
                        
                        if FileManager.default.fileExists(atPath: outputURL.path) {
                            continuation.resume(returning: outputURL)
                        } else {
                            continuation.resume(throwing: ConversionError.outputNotGenerated)
                        }
                    } else {
                        continuation.resume(throwing: ConversionError.conversionFailed(errorOutput))
                    }
                }
            } catch {
                continuation.resume(throwing: ConversionError.conversionFailed(error.localizedDescription))
            }
        }
    }
    
    /// Finds the LibreOffice executable
    /// - Returns: URL to the soffice executable
    private func findLibreOffice() throws -> URL {
        // Check common LibreOffice installation paths
        let possiblePaths = [
            // Bundled within the app
            Bundle.main.url(forResource: "LibreOffice", withExtension: "app")?
                .appendingPathComponent("Contents/MacOS/soffice"),
            
            // Standard macOS installation
            URL(fileURLWithPath: "/Applications/LibreOffice.app/Contents/MacOS/soffice"),
            
            // User's Applications folder
            FileManager.default.homeDirectoryForCurrentUser
                .appendingPathComponent("Applications/LibreOffice.app/Contents/MacOS/soffice")
        ].compactMap { $0 }
        
        for path in possiblePaths {
            if FileManager.default.fileExists(atPath: path.path) {
                return path
            }
        }
        
        throw ConversionError.libreOfficeNotFound
    }
}
