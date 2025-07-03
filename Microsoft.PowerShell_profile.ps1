# Microsoft.PowerShell_profile.ps1

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

[System.Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'
[System.Threading.Thread]::CurrentThread.CurrentUICulture = 'en-US'
