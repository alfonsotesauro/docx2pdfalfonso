# LibreOffice Bundling Guide

This document provides guidance on bundling LibreOffice with the DOCX2PDF application for distribution.

## Why Bundle LibreOffice?

Bundling LibreOffice makes the application self-contained, eliminating the need for users to install LibreOffice separately. However, it significantly increases the application size (by ~700MB).

## Licensing Considerations

LibreOffice is licensed under the LGPL (Lesser General Public License) v3 and MPLv2. When bundling:

1. **You MUST**:
   - Include LibreOffice's license files
   - Provide attribution to The Document Foundation
   - Inform users that LibreOffice is included
   - Make it clear that LibreOffice is a separate component

2. **You MAY**:
   - Bundle LibreOffice as a separate process/tool
   - Invoke it via command-line interface
   - Distribute the combined package

3. **You MUST NOT**:
   - Claim LibreOffice as your own
   - Remove LibreOffice's copyright notices
   - Violate LGPL terms

## How to Bundle LibreOffice

### Step 1: Obtain LibreOffice

Download LibreOffice from the official website:
```bash
# Visit https://www.libreoffice.org/download/download/
# Download the macOS version
```

### Step 2: Extract the Application

After installation:
```bash
# Copy LibreOffice.app to your project
cp -R /Applications/LibreOffice.app /path/to/your/project/Resources/
```

### Step 3: Add to Xcode Project

1. In Xcode, select your project
2. Select the DOCX2PDF target
3. Go to "Build Phases"
4. Expand "Copy Bundle Resources"
5. Click "+" and add LibreOffice.app

### Step 4: Update Code

The `DocumentConverter.swift` already checks for bundled LibreOffice first:

```swift
Bundle.main.url(forResource: "LibreOffice", withExtension: "app")?
    .appendingPathComponent("Contents/MacOS/soffice")
```

This means bundled LibreOffice takes priority over system-installed versions.

### Step 5: Update Entitlements

If bundling, you can remove the temporary exception for `/Applications/LibreOffice.app/` from the entitlements file, as the bundled version is within the app bundle.

Edit `DOCX2PDF.entitlements`:
```xml
<!-- Remove or comment out: -->
<!-- 
<key>com.apple.security.temporary-exception.files.absolute-path.read-write</key>
<array>
    <string>/Applications/LibreOffice.app/</string>
</array>
-->
```

### Step 6: Include License Files

Create a Licenses folder in your bundle:

```bash
mkdir -p /path/to/project/DOCX2PDF/Licenses
```

Copy LibreOffice license files:
```bash
cp /Applications/LibreOffice.app/Contents/Resources/LICENSE* /path/to/project/DOCX2PDF/Licenses/
```

Add these to Xcode as bundle resources.

### Step 7: Update Info.plist

Add license attribution to your Info.plist or About window:

```xml
<key>NSHumanReadableCopyright</key>
<string>Copyright © 2026. This application includes LibreOffice, licensed under LGPL. See Licenses folder for details.</string>
```

### Step 8: Create an About Window (Optional)

Add an about window that displays:
- Your application's license (MIT)
- LibreOffice attribution
- Link to LibreOffice licenses

## Distribution Checklist

Before distributing a bundled version:

- [ ] LibreOffice.app is included in the bundle
- [ ] License files are included
- [ ] Attribution to The Document Foundation is provided
- [ ] Info.plist mentions LibreOffice
- [ ] Code signing is properly configured
- [ ] Notarization is complete (for macOS distribution)
- [ ] README mentions LibreOffice inclusion
- [ ] File size warning in documentation (~700MB)

## Alternative: Download on First Run

Instead of bundling, you could:

1. Detect if LibreOffice is installed
2. If not, prompt user to download it
3. Provide a direct download link
4. Check again after download

This keeps your app size small while still providing a good user experience.

## Testing

After bundling:

1. Test on a clean macOS system without LibreOffice installed
2. Verify conversion works
3. Check that bundled LibreOffice is being used:
   ```swift
   // Add logging to findLibreOffice() to verify path
   print("Using LibreOffice at: \(path)")
   ```
4. Test signing and notarization

## Performance Considerations

Bundled LibreOffice:
- Increases app size significantly (~700MB)
- Slower first launch (needs to be validated by Gatekeeper)
- Self-contained and reliable
- No dependency on system-installed LibreOffice version

## Maintenance

When bundling LibreOffice:
- Monitor LibreOffice updates for security patches
- Update bundled version periodically
- Test compatibility with new LibreOffice versions
- Document which version is bundled

## Support

For LibreOffice-specific issues:
- Check The Document Foundation documentation
- Visit LibreOffice community forums
- Review LGPL compliance guides
