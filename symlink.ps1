# install.ps1

$ErrorActionPreference = "Stop"

function Log-Info {
    param([string]$Message)
    Write-Host -ForegroundColor Cyan "[INFO] " -NoNewline
    Write-Host $Message
}

function Log-Success {
    param([string]$Message)
    Write-Host -ForegroundColor Green "[SUCCESS] " -NoNewline
    Write-Host $Message
}

function Log-Warning {
    param([string]$Message)
    Write-Host -ForegroundColor Yellow "[WARNING] " -NoNewline
    Write-Host $Message
}

function Log-Error {
    param([string]$Message)
    Write-Host -ForegroundColor Red "[ERROR] " -NoNewline
    Write-Host $Message
}

$dotfilesDir = $PSScriptRoot
$backupDir = Join-Path $env:USERPROFILE "dotfiles_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

if (-not (Test-Path -Path $dotfilesDir)) {
    Log-Error "Dotfiles directory not found: $dotfilesDir"
    exit 1
}

Log-Info "Starting dotfiles installation..."
Log-Info "Dotfiles path: $dotfilesDir"

New-Item -ItemType Directory -Path $backupDir | Out-Null
Log-Info "Created backup directory: $backupDir"

function Create-Symlink {
    param(
        [string]$Source,
        [string]$Target
    )

    $targetDir = Split-Path -Parent $Target

    # Create target's parent directory if it doesn't exist
    if (-not (Test-Path -Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }

    # Handle existing files or symlinks at the target location
    if (Test-Path -Path $Target) {
        if ((Get-Item $Target -Force -ErrorAction SilentlyContinue).LinkType) {
            Log-Warning "Removing existing symlink: $Target"
            Remove-Item -Path $Target -Force
        }
        else {
            Log-Warning "Backing up existing item: $Target -> $backupDir"
            Move-Item -Path $Target -Destination $backupDir -Force
        }
    }

    # Determine if source is a directory or a file to create the correct link type
    $isContainer = Test-Path -Path $Source -PathType Container
    $linkType = if ($isContainer) { "Junction" } else { "Symbolic" }

    # Create the new symlink
    try {
        New-Item -ItemType $linkType -Path $Target -Value $Source | Out-Null
        Log-Success "Created symlink: $Target -> $Source"
    }
    catch {
        Log-Error "Failed to create symlink for $Target. Try running PowerShell as an Administrator."
    }
}

Log-Info "Linking configuration files..."

# Wezterm
$weztermSource = Join-Path $dotfilesDir "wezterm"
if (Test-Path -Path $weztermSource) {
    Create-Symlink -Source $weztermSource -Target (Join-Path $env:USERPROFILE ".config\wezterm")
}

# Neovim
$nvimSource = Join-Path $dotfilesDir "nvim"
if (Test-Path -Path $nvimSource) {
    Create-Symlink -Source $nvimSource -Target (Join-Path $env:LOCALAPPDATA "nvim")
}

# Git
$gitConfigSource = Join-Path $dotfilesDir ".gitconfig"
if (Test-Path -Path $gitConfigSource) {
    Create-Symlink -Source $gitConfigSource -Target (Join-Path $env:USERPROFILE ".gitconfig")
}

# Windows Terminal
$wtSource = Join-Path $dotfilesDir "windows-terminal-settings.json"
if (Test-Path -Path $wtSource) {
    $wtTarget = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
    Create-Symlink -Source $wtSource -Target $wtTarget
}

# PowerShell Profile
$psProfileSource = Join-Path $dotfilesDir "Microsoft.PowerShell_profile.ps1"
if (Test-Path -Path $psProfileSource) {
    # $PROFILE is a built-in variable for the current user's profile path
    Create-Symlink -Source $psProfileSource -Target $PROFILE
}


Log-Success "Dotfiles installation completed!"
Log-Info "Backed up files are in: $backupDir"

# Remove the backup directory if it's empty
if (-not (Get-ChildItem -Path $backupDir)) {
    Remove-Item -Path $backupDir -Force
    Log-Info "Removed empty backup directory."
}

Write-Host ""
Log-Info "Next steps:"
Write-Host "  1. Restart any open terminals (PowerShell, Windows Terminal) to apply changes."
Write-Host "  2. If you linked a PowerShell profile, you may need to approve its execution."
Write-Host ""

Log-Success "Done!!!"
