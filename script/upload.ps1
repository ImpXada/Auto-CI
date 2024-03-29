# SPDX-FileCopyrightText: 2019 yuzu Emulator Project
# SPDX-License-Identifier: GPL-2.0-or-later

param($BUILD_NAME, $BUILD_DATE, $BUILD_TAG)
Set-Location $env:GITHUB_WORKSPACE\suyu

if ("$BUILD_NAME" -eq "mainline") {
    $RELEASE_DIST = "suyu-windows-msvc"
}
else {
    $RELEASE_DIST = "suyu-windows-msvc-$BUILD_NAME"
}

$MSVC_BUILD_ZIP = "suyu-windows-msvc-$BUILD_DATE-$BUILD_TAG.zip" -replace " ", ""
$env:BUILD_ZIP = $MSVC_BUILD_ZIP

if (Test-Path -Path ".\build\bin\Release") {
    $BUILD_DIR = ".\build\bin\Release"
}
else {
    $BUILD_DIR = ".\build\bin\"
}

# Cleanup unneeded data in submodules
git submodule foreach git clean -fxd

# Create artifact directories
mkdir $RELEASE_DIST
mkdir "artifacts"
$workspace = $env:GITHUB_WORKSPACE

# With vcpkg we now have a few more dll files
Get-ChildItem .\build\bin\*.dll
Copy-Item .\build\bin\*.dll .\artifacts\

# Hopefully there is an exe in either .\build\bin or .\build\bin\Release
Copy-Item .\build\bin\suyu*.exe .\artifacts\
Copy-Item "$BUILD_DIR\*" -Destination "artifacts" -Recurse
Remove-Item .\artifacts\tests.exe -ErrorAction ignore

# Debugging symbols
Copy-Item .\build\bin\suyu*.pdb .\artifacts\

# Build the final release artifacts
Copy-Item "$BUILD_DIR\*" -Destination $RELEASE_DIST -Recurse
Remove-Item "$RELEASE_DIST\*.exe"
Get-ChildItem "$BUILD_DIR" -Recurse -Filter "suyu*.exe" | Copy-Item -destination $RELEASE_DIST
Get-ChildItem "$BUILD_DIR" -Recurse -Filter "QtWebEngineProcess*.exe" | Copy-Item -destination $RELEASE_DIST
7z a -tzip $MSVC_BUILD_ZIP $RELEASE_DIST\*
Get-ChildItem . -Filter "*.zip" | Copy-Item -destination $workspace