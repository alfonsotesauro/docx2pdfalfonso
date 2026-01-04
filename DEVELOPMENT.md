# Development Guide

This guide provides detailed information for developers working on the DOCX2PDF application.

## Prerequisites

- macOS 13.0 or later
- Xcode 15.0 or later
- LibreOffice installed (for testing)
- Basic understanding of Swift and SwiftUI

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/alfonsotesauro/docx2pdfalfonso.git
cd docx2pdfalfonso
```

### 2. Install LibreOffice

For development and testing, install LibreOffice:

```bash
# Download from https://www.libreoffice.org/download/download/
# Or use Homebrew:
brew install --cask libreoffice
```

Verify installation:
```bash
/Applications/LibreOffice.app/Contents/MacOS/soffice --version
```

### 3. Open the Project

```bash
open DOCX2PDF.xcodeproj
```

### 4. Configure Signing

1. In Xcode, select the DOCX2PDF project
2. Select the DOCX2PDF target
3. Go to "Signing & Capabilities"
4. Select your development team
5. Ensure "Automatically manage signing" is checked

### 5. Build and Run

Press `Cmd+R` or use the build script:

```bash
./build.sh
```

## Project Architecture

### File Structure

```
DOCX2PDF/
├── DOCX2PDFApp.swift           # App entry point and configuration
├── ContentView.swift           # Main user interface
├── DocumentConverter.swift     # Conversion logic
├── Info.plist                  # App configuration
├── DOCX2PDF.entitlements      # Sandbox permissions
└── Assets.xcassets/           # Images and colors
```

### Key Components

#### DOCX2PDFApp.swift

The main app structure using SwiftUI's `@main` attribute. Configures:
- Window style (hidden title bar)
- Window resizability
- Initial view

#### ContentView.swift

The main UI view implementing:
- File selection dialogs (`NSOpenPanel`)
- Conversion trigger button
- Status and error display
- Progress indication
- User feedback

#### DocumentConverter.swift

Core conversion logic:
- LibreOffice path detection
- Process management
- Security-scoped resource access
- Error handling
- Async/await conversion

## Development Workflow

### Running in Debug Mode

1. Set breakpoints as needed
2. Press `Cmd+R` to run
3. The app will launch with debugger attached
4. Use Xcode console to view logs

### Testing Conversions

1. Prepare test DOCX files in various formats:
   - Simple documents
   - Documents with images
   - Documents with tables
   - Documents with complex formatting
   - Large documents

2. Run the app and test each file type

3. Check output PDFs in Preview or Adobe Reader

### Debugging Tips

#### Enable Verbose Logging

Add print statements to track execution:

```swift
// In DocumentConverter.swift
print("🔍 Looking for LibreOffice at: \(path)")
print("📝 Converting: \(inputURL.path)")
print("📁 Output directory: \(outputDirectory.path)")
```

#### View LibreOffice Output

Capture LibreOffice stdout/stderr:

```swift
let outputPipe = Pipe()
let errorPipe = Pipe()
process.standardOutput = outputPipe
process.standardError = errorPipe

// After process runs:
let output = String(data: outputPipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
print("LibreOffice output: \(output ?? "")")
```

#### Test Sandbox Behavior

Run the app outside of Xcode to test sandbox restrictions:

```bash
open build/Build/Products/Debug/DOCX2PDF.app
```

Check Console.app for sandbox violations.

## Common Development Tasks

### Adding a New Feature

1. Create a new branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Implement the feature
3. Test thoroughly
4. Commit changes:
   ```bash
   git add .
   git commit -m "Add feature: description"
   ```

5. Push and create a pull request

### Modifying the UI

The UI is built with SwiftUI. To modify:

1. Open `ContentView.swift`
2. Make changes to the SwiftUI view hierarchy
3. Use Xcode previews for rapid iteration:
   - Canvas should show live preview
   - Press `Cmd+Option+P` to refresh

### Changing Conversion Logic

To modify how conversion works:

1. Open `DocumentConverter.swift`
2. Modify the `convertToPDF` method
3. Update LibreOffice arguments if needed
4. Test with various document types

### Adding New Entitlements

If you need additional permissions:

1. Open `DOCX2PDF.entitlements`
2. Add the required entitlement key
3. Update documentation to explain why it's needed
4. Test that sandbox still works

## Testing

### Manual Testing Checklist

- [ ] App launches successfully
- [ ] File selection dialog works
- [ ] Can select DOCX files
- [ ] Can select output directory
- [ ] Conversion completes successfully
- [ ] PDF opens in Finder
- [ ] Error messages display correctly
- [ ] Progress indicator works
- [ ] Multiple conversions in a row
- [ ] Very large files (>50MB)
- [ ] Files with special characters in name
- [ ] Files in different directories

### Testing Without LibreOffice

To test the "LibreOffice not found" error:

1. Temporarily rename LibreOffice:
   ```bash
   sudo mv /Applications/LibreOffice.app /Applications/LibreOffice.app.backup
   ```

2. Run the app and verify error message

3. Restore LibreOffice:
   ```bash
   sudo mv /Applications/LibreOffice.app.backup /Applications/LibreOffice.app
   ```

### Testing Sandbox Violations

Check Console.app for sandbox denial messages:

1. Open Console.app
2. Filter for "DOCX2PDF"
3. Look for "deny" messages
4. Fix any violations

## Code Style

### Swift Conventions

- Use Swift naming conventions (camelCase for variables, PascalCase for types)
- Prefer `let` over `var` when possible
- Use meaningful variable names
- Add comments for complex logic
- Use async/await for asynchronous operations

### SwiftUI Best Practices

- Keep views small and focused
- Extract complex views into separate structs
- Use `@State` for local view state
- Use `@StateObject` for observable objects
- Prefer composition over inheritance

### Error Handling

- Use custom error types that conform to `LocalizedError`
- Provide user-friendly error messages
- Log detailed errors for debugging
- Handle all possible failure cases

## Building for Release

### Debug Build

```bash
./build.sh Debug
```

### Release Build

```bash
./build.sh Release
```

### Archive and Export

1. In Xcode: Product > Archive
2. Wait for archive to complete
3. Click "Distribute App"
4. Choose distribution method:
   - Development: For testing on other Macs
   - Mac App Store: For store distribution
   - Developer ID: For distribution outside the store

### Code Signing

Ensure proper code signing:

```bash
codesign -vvv --deep --strict build/Build/Products/Release/DOCX2PDF.app
```

### Notarization

For distribution outside the Mac App Store:

1. Archive the app
2. Export with Developer ID
3. Submit for notarization:
   ```bash
   xcrun notarytool submit DOCX2PDF.zip --apple-id your@email.com --team-id TEAMID --wait
   ```
4. Staple the notarization ticket:
   ```bash
   xcrun stapler staple DOCX2PDF.app
   ```

## Troubleshooting

### Build Errors

**"No such module 'SwiftUI'"**
- Ensure you're using macOS as the target
- Check minimum deployment target (macOS 13.0)

**"Signing for 'DOCX2PDF' requires a development team"**
- Select a development team in Signing & Capabilities

**"Command PhaseScriptExecution failed"**
- Check build phase scripts
- Ensure all files exist

### Runtime Errors

**"LibreOffice not found"**
- Install LibreOffice at `/Applications/LibreOffice.app`
- Check path in `findLibreOffice()`

**"Operation not permitted"**
- Check entitlements
- Verify file permissions
- Review sandbox logs in Console.app

**"Conversion failed"**
- Check if DOCX file is valid
- Try opening in LibreOffice manually
- Check disk space
- Review LibreOffice output

## Performance Optimization

### Async Operations

The app uses async/await for conversion:
- Keeps UI responsive
- Proper error propagation
- Clean cancellation handling

### Large Files

For very large files:
- Conversion happens in background
- Progress indicator shows activity
- Memory is managed by LibreOffice process

### Optimization Tips

1. Don't block the main thread
2. Use Task for async operations
3. Release security-scoped resources promptly
4. Let LibreOffice handle file processing

## Contributing

### Before Submitting a PR

1. Test all functionality
2. Update documentation
3. Follow code style guidelines
4. Add comments for complex code
5. Ensure no compiler warnings
6. Test on a clean macOS installation

### Code Review Checklist

- [ ] Code compiles without warnings
- [ ] Manual testing completed
- [ ] Documentation updated
- [ ] Error handling implemented
- [ ] Follows existing code style
- [ ] No hardcoded paths or values
- [ ] Sandbox compliance maintained

## Resources

### Apple Documentation

- [SwiftUI](https://developer.apple.com/documentation/swiftui/)
- [App Sandbox](https://developer.apple.com/documentation/security/app_sandbox)
- [Process](https://developer.apple.com/documentation/foundation/process)
- [File System Programming Guide](https://developer.apple.com/library/archive/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/)

### LibreOffice Documentation

- [LibreOffice Command Line](https://help.libreoffice.org/latest/en-US/text/shared/guide/start_parameters.html)
- [Headless Mode](https://wiki.documentfoundation.org/Development/CommandLineOptions)

### Community

- [Swift Forums](https://forums.swift.org/)
- [Apple Developer Forums](https://developer.apple.com/forums/)
- [LibreOffice Forums](https://ask.libreoffice.org/)

## License

See LICENSE file for details.
