# get a hold of all the scripts (from the public and the private directories)
$PublicScripts = Get-ChildItem "$PSScriptRoot\Public" -Recurse -File -Filter *.ps1
$PrivateScripts = Get-ChildItem "$PSScriptRoot\Private" -Recurse -File -Filter *.ps1
$EnvironmentScripts = Get-ChildItem "$PSScriptRoot\Env" -Recurse -File -Filter *.ps1

# dot-source all scripts
$PublicScripts + $PrivateScripts + $EnvironmentScripts | ForEach-Object { # dot-source it
   . $_
}

# export public module functions
$PublicScripts | ForEach-Object { # export its functions
   Export-ModuleMember -Function $_.BaseName
}
