# Microsoft.PowerShell_profile.ps1
$script:Colors = @{
    Base      = "`e[38;2;205;214;245m"  # #cdd6f5
    Blue      = "`e[38;2;138;173;244m"  # #8aadf4
    Gray      = "`e[38;2;73;77;100m"    # #494d64
    Lavender  = "`e[38;2;137;180;250m"  # #89b4fa
    Bold      = "`e[1m"
    Reset     = "`e[0m"
}

function Get-OSIcon {
	return "󰖳"
}

function Get-SSHStatus {
    if ($env:SSH_CLIENT -or $env:SSH_TTY) {
        $hostname = $env:COMPUTERNAME ?? $env:HOSTNAME ?? "remote"
        return "SSH:$hostname"
    } else {
        return "LOCAL"
    }
}

function Get-SessionInfo {
    $processId = $PID
    $sessionId = [System.Diagnostics.Process]::GetCurrentProcess().SessionId
    return "$sessionId`:$processId`:1"
}

function prompt {
    $c = $script:Colors

    $leftStatus = @(
        "$($c.Base)▎"
        "$($c.Blue)$($c.Bold)$(Get-OSIcon)"
        "$($c.Gray)│"
        "$($c.Blue)$($c.Bold)$(Get-SSHStatus)"
        "$($c.Gray)│"
        "$($c.Lavender)$($c.Bold)$(Get-SessionInfo)"
        "$($c.Gray)│$($c.Reset)"
    ) -join " "

    $currentPath = $PWD.Path.Replace($env:USERPROFILE, "~")
    if ($currentPath.Length -gt 30) {
        $pathParts = $currentPath.Split([IO.Path]::DirectorySeparatorChar)
        if ($pathParts.Length -gt 3) {
            $currentPath = "$($pathParts[0])/.../$(($pathParts[-2..-1]) -join '/')"
        }
    }

    Write-Host $leftStatus -NoNewline
    Write-Host " $($c.Base)$currentPath$($c.Reset)" -NoNewline

    $gitBranch = ""
    if (Get-Command git -ErrorAction SilentlyContinue) {
        $branch = git branch --show-current 2>$null
        if ($branch) {
            $gitBranch = " $($c.Gray)git:$($c.Blue)$branch$($c.Reset)"
        }
    }

    if ($gitBranch) {
        Write-Host $gitBranch -NoNewline
    }

    Write-Host ""
    Write-Host "$($c.Lavender)❯$($c.Reset) " -NoNewline

    return " "
}



# Alias
Set-Alias -Name vim -Value nvim

Set-Alias -Name gits -Value "git status"
function gitm { git commit -m $args[0] }
Set-Alias -Name gitp -Value "git push"

function nvc {
    Set-Location "$env:USERPROFILE\.config\nvim"
    nvim
}

Set-Alias -Name cl -Value Clear-Host

function lr {
    Get-ChildItem | Sort-Object LastWriteTime | Format-Table Name, Length, LastWriteTime
}

function .. { Set-Location .. }
function ... { Set-Location ..\.. }
function .... { Set-Location ..\..\.. }
function ..... { Set-Location ..\..\..\.. }
function ...... { Set-Location ..\..\..\..\.. }

$env:TERM = "xterm-256color"

