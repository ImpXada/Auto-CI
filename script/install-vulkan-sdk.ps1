# SPDX-FileCopyrightText: 2023 yuzu Emulator Project
# SPDX-License-Identifier: GPL-3.0-or-later

$ErrorActionPreference = "Stop"

$VulkanSDKVer = "1.3.250.1"
$ExeFile = "VulkanSDK-$VulkanSDKVer-Installer.exe"
$Uri = "https://sdk.lunarg.com/sdk/download/$VulkanSDKVer/windows/$ExeFile"
$Destination = "./$ExeFile"

Write-Output "Downloading Vulkan SDK $VulkanSDKVer from $Uri"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($Uri, $Destination)
Write-Output "Finished downloading $ExeFile"

$VULKAN_SDK = "C:/VulkanSDK/$VulkanSDKVer"
$Arguments = "--root `"$VULKAN_SDK`" --accept-licenses --default-answer --confirm-command install"

Write-Output "Installing Vulkan SDK $VulkanSDKVer"
$InstallProcess = Start-Process -FilePath $Destination -NoNewWindow -PassThru -Wait -ArgumentList $Arguments
$ExitCode = $InstallProcess.ExitCode

if ($ExitCode -ne 0) {
    Write-Output "Error installing Vulkan SDK $VulkanSDKVer (Error: $ExitCode)"
    Exit $ExitCode
}

Write-Output "Finished installing Vulkan SDK $VulkanSDKVer"

if ("$env:GITHUB_ACTIONS" -eq "true") {
    Write-Output "VULKAN_SDK=$VULKAN_SDK" | Out-File -FilePath $env:GITHUB_ENV -Encoding utf8 -Append
    Write-Output "$VULKAN_SDK/Bin" | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append
}
