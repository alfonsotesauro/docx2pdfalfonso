# DOCX to PDF Converter

A minimal sandboxed macOS application that converts DOCX files to PDF using LibreOffice.

## Features

- **Sandboxed Environment**: Operates within macOS's sandbox for security
- **LibreOffice Integration**: Uses LibreOffice's command-line tool for reliable conversion
- **User-Friendly Interface**: Simple SwiftUI-based GUI for file selection
- **Error Handling**: Graceful error handling with informative messages
- **LGPL Compliant**: Respects LibreOffice's licensing requirements

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later
- LibreOffice installed at `/Applications/LibreOffice.app`

## Installation

### Installing LibreOffice

1. Download LibreOffice from [https://www.libreoffice.org/download/download/](https://www.libreoffice.org/download/download/)
2. Install it to `/Applications/LibreOffice.app`
3. Verify installation:
   ```bash
   /Applications/LibreOffice.app/Contents/MacOS/soffice --version
   ```

### Building the Application

1. Clone this repository:
   ```bash
   git clone https://github.com/alfonsotesauro/docx2pdfalfonso.git
   cd docx2pdfalfonso
   ```

2. Open the project in Xcode:
   ```bash
   open DOCX2PDF.xcodeproj
   ```

3. Build the project:
   - Select your development team in the "Signing & Capabilities" tab
   - Press `Cmd+B` to build
   - Press `Cmd+R` to run

## Usage

1. Launch the application
2. Click "Browse..." next to "Input File" to select a DOCX file
3. (Optional) Click "Browse..." next to "Output Directory" to choose where to save the PDF
   - If not specified, the PDF will be saved in the same directory as the input file
4. Click "Convert to PDF"
5. The converted PDF will open in Finder when complete

## Architecture

### Components

- **DOCX2PDFApp.swift**: Main application entry point
- **ContentView.swift**: SwiftUI-based user interface
- **DocumentConverter.swift**: Core conversion logic using LibreOffice

### Sandboxing

The application uses the following entitlements:
- `com.apple.security.app-sandbox`: Enables app sandboxing
- `com.apple.security.files.user-selected.read-write`: Allows reading/writing user-selected files
- `com.apple.security.files.downloads.read-write`: Allows access to Downloads folder
- `com.apple.security.temporary-exception.files.absolute-path.read-write`: Temporary exception for LibreOffice access

### Conversion Process

1. User selects input DOCX file via `NSOpenPanel`
2. User optionally selects output directory
3. Application starts security-scoped resource access
4. LibreOffice is invoked via `Process` with:
   ```
   soffice --headless --convert-to pdf --outdir <output> <input>
   ```
5. Process completes and PDF is generated
6. Security-scoped resources are released
7. Finder opens to show the converted file

## LibreOffice Bundling (Optional)

To create a standalone application without requiring LibreOffice to be pre-installed:

1. Copy the LibreOffice.app bundle into your project
2. Add it to the Xcode project under "Copy Bundle Resources"
3. Update `findLibreOffice()` in `DocumentConverter.swift` to prioritize the bundled version

**Note**: LibreOffice is approximately 700MB, so bundling it significantly increases the app size.

## Licensing

This application is designed to comply with LibreOffice's LGPL licensing:

- LibreOffice is licensed under the LGPL (Lesser General Public License)
- This application invokes LibreOffice as a separate process (command-line tool)
- No LibreOffice code is compiled into this application
- Users must install LibreOffice separately (or it can be bundled as a separate component)

### LGPL Compliance

When distributing this application:

1. **If LibreOffice is NOT bundled**: Users must install LibreOffice separately
2. **If LibreOffice IS bundled**: 
   - Include LibreOffice's license files
   - Inform users that LibreOffice is included and licensed under LGPL
   - Provide attribution to The Document Foundation

## Error Handling

The application handles various error scenarios:

- **LibreOffice Not Found**: Displays message prompting user to install LibreOffice
- **Conversion Failed**: Shows detailed error message from LibreOffice
- **File Access Denied**: Indicates permission issues
- **Invalid Input**: Validates file format before conversion
- **Output Not Generated**: Detects if PDF creation failed

## Development

### Project Structure

```
DOCX2PDF/
├── DOCX2PDF.xcodeproj/       # Xcode project
├── DOCX2PDF/                 # Source files
│   ├── DOCX2PDFApp.swift     # App entry point
│   ├── ContentView.swift     # Main UI
│   ├── DocumentConverter.swift # Conversion logic
│   ├── Info.plist            # App configuration
│   ├── DOCX2PDF.entitlements # Sandbox permissions
│   └── Assets.xcassets/      # App resources
└── README.md                 # This file
```

### Testing

1. Prepare test DOCX files
2. Launch the application in Xcode
3. Test various scenarios:
   - Valid DOCX conversion
   - Invalid file format
   - Missing LibreOffice
   - Permission denied scenarios
   - Large files
   - Files with complex formatting

### Debugging

To see LibreOffice output during conversion:
1. Run the app from Xcode
2. Check the Console for stdout/stderr from the conversion process
3. Review error messages displayed in the UI

## Known Limitations

- Requires LibreOffice to be installed separately (unless bundled)
- Conversion quality depends on LibreOffice's capabilities
- Some complex DOCX features may not convert perfectly
- Sandboxing requires user to explicitly select files

## Troubleshooting

### "LibreOffice is not installed"

**Solution**: Install LibreOffice from [libreoffice.org](https://www.libreoffice.org)

### "Conversion failed"

**Possible causes**:
- Corrupted DOCX file
- Unsupported document features
- Insufficient disk space
- LibreOffice crash

**Solution**: Try opening the file in LibreOffice manually to verify it's valid

### Permission Errors

**Solution**: Ensure the application has the necessary permissions in System Settings > Privacy & Security

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## Support

For issues and questions:
- Open an issue on GitHub
- Check LibreOffice documentation for conversion-related questions

## Acknowledgments

- LibreOffice and The Document Foundation for the conversion engine
- Apple for the SwiftUI framework

## License

This application code is available under the MIT License. Note that LibreOffice (required for conversion) is licensed under LGPL.
