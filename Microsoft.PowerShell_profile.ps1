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

function prompt {
    $hostName = $env:COMPUTERNAME
    $path = Get-Location
    "[$hostName] PS $path> "
}

$env:TERM = "xterm-256color"

[System.Threading.Thread]::CurrentThread.CurrentCulture = 'en-US'
[System.Threading.Thread]::CurrentThread.CurrentUICulture = 'en-US'
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$env:LANG = 'en_US.UTF-8'
