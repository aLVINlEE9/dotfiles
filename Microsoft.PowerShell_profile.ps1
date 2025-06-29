# Microsoft.PowerShell_profile.ps1
$script:Colors = @{
    Base      = "`e[38;2;205;214;245m"  # #cdd6f5
    Blue      = "`e[38;2;138;173;244m"  # #8aadf4
    Gray      = "`e[38;2;73;77;100m"    # #494d64
    Lavender  = "`e[38;2;137;180;250m"  # #89b4fa
    Bold      = "`e[1m"
    Reset     = "`e[0m"
    StatusBg  = "`e[48;2;30;30;46m"
    StatusFg  = "`e[38;2;205;214;245m"
}

function Get-OSIcon {
    return "󰖳"
}

function Get-SSHStatus {
    $serverIP = "local"
    $username = $env:USERNAME
    if ($env:SSH_CONNECTION) {
        $parts = $env:SSH_CONNECTION -split ' '
        if ($parts.Length -ge 3) {
            $serverIP = $parts[2]
        }
    }
    return "$username@$serverIP"
}

function Get-SessionInfo {
    $processId = $PID
    $sessionId = [System.Diagnostics.Process]::GetCurrentProcess().SessionId
    return "$sessionId`:$processId`:1"
}

function Set-StatusBar {
    $c = $script:Colors

    $width = $Host.UI.RawUI.WindowSize.Width

    $leftStatus = @(
        "$($c.StatusBg)$($c.Base)▎"
        "$($c.StatusBg)$($c.Blue)$($c.Bold)$(Get-OSIcon)"
        "$($c.StatusBg)$($c.Gray)│"
        "$($c.StatusBg)$($c.Blue)$($c.Bold)$(Get-SSHStatus)"
        "$($c.StatusBg)$($c.Gray)│"
        "$($c.StatusBg)$($c.Lavender)$($c.Bold)$(Get-SessionInfo)"
        "$($c.StatusBg)$($c.Gray)│"
    ) -join " "

    $currentPath = $PWD.Path.Replace($env:USERPROFILE, "~")
    if ($currentPath.Length -gt 30) {
        $pathParts = $currentPath.Split([IO.Path]::DirectorySeparatorChar)
        if ($pathParts.Length -gt 3) {
            $currentPath = "$($pathParts[0])/.../$(($pathParts[-2..-1]) -join '/')"
        }
    }

    $gitBranch = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git branch --show-current 2>$null
        if ($branch) {
            $gitBranch = " $($c.Gray)git:$($c.Blue)$branch$($c.Reset)"
        }
    }

    $statusContent = "$($c.StatusBg) $($c.StatusFg)$currentPath$gitBranch"

    $contentLength = ($leftStatus + $statusContent).Length - ($leftStatus + $statusContent | Select-String -Pattern "`e\[[0-9;]*m" -AllMatches).Matches.Count * 10
    $remainingSpace = $width - $contentLength
    if ($remainingSpace -gt 0) {
        $statusContent += "$($c.StatusBg)" + (" " * $remainingSpace)
    }

    Clear-Host
    Write-Host "$leftStatus$statusContent$($c.Reset)"
    Write-Host ("─" * $width) -ForegroundColor DarkGray
    Write-Host ""
}

function prompt {
    "$($script:Colors.Lavender)❯$($script:Colors.Reset) "
}

function Set-Location {
    Microsoft.PowerShell.Management\Set-Location @args
    Set-StatusBar
}

function cl { Set-StatusBar }
function clear { Set-StatusBar }
function Clear-Host { Set-StatusBar }
Set-Alias -Name cls -Value Set-StatusBar

Set-StatusBar


# Alias
Set-Alias -Name vim -Value nvim

Set-Alias -Name gits -Value "git status"
function gitm { git commit -m $args[0] }
Set-Alias -Name gitp -Value "git push"

function nvc {
    Set-Location "$env:USERPROFILE\.config\nvim"
    nvim
}

function lr {
    Get-ChildItem | Sort-Object LastWriteTime | Format-Table Name, Length, LastWriteTime
}

function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ..... { Set-Location ..\..\..\.. }
function ...... { Set-Location ..\..\..\..\.. }

$env:TERM = "xterm-256color"

