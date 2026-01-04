# Quick Start Guide

Get up and running with DOCX2PDF in just a few minutes!

## Step 1: Install LibreOffice

**Download LibreOffice:**
- Visit: https://www.libreoffice.org/download/download/
- Download the macOS version
- Install to `/Applications/LibreOffice.app`

**Verify Installation:**
```bash
/Applications/LibreOffice.app/Contents/MacOS/soffice --version
```

You should see something like: `LibreOffice 24.2.0.3 ...`

## Step 2: Build the Application

**Option A: Using the Build Script** (Recommended)
```bash
cd docx2pdfalfonso
chmod +x build.sh
./build.sh
```

**Option B: Using Xcode**
```bash
open DOCX2PDF.xcodeproj
```
Then press `Cmd+R` to build and run.

## Step 3: Run the Application

```bash
open build/Build/Products/Debug/DOCX2PDF.app
```

Or just press `Cmd+R` in Xcode.

## Step 4: Convert a Document

1. **Click "Browse..."** next to "Input File"
2. **Select your DOCX file**
3. **Click "Convert to PDF"**
4. **Wait for conversion** (usually a few seconds)
5. **PDF opens in Finder** automatically!

## That's It! 🎉

Your PDF will be saved in the same directory as the input file.

---

## Troubleshooting

### "LibreOffice is not installed"

**Solution:** Install LibreOffice from step 1 above.

### "Build failed"

**Check:**
- Are you running macOS 13.0 or later?
- Is Xcode 15.0 or later installed?
- Did you open the `.xcodeproj` file?

### "Conversion failed"

**Try:**
1. Open the DOCX file in LibreOffice manually
2. Make sure the file isn't corrupted
3. Check you have write permissions to the output directory

---

## Next Steps

- Read the full [README.md](README.md) for detailed information
- Check [DEVELOPMENT.md](DEVELOPMENT.md) if you want to contribute
- See [LIBREOFFICE_BUNDLING.md](LIBREOFFICE_BUNDLING.md) to create a standalone app

---

## Support

Having issues? 
- Check the [README.md](README.md#troubleshooting) troubleshooting section
- Open an issue on GitHub

Enjoy converting your documents! 📄 → 📕
