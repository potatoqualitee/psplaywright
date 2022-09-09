﻿
$script:root = $PSScriptRoot

function Import-ModuleFile {
    <#
		.SYNOPSIS
			Loads files into the module on module import.

		.DESCRIPTION
			This helper function is used during module initialization.
			It should always be dotsourced itself, in order to proper function.

			This provides a central location to react to files being imported, if later desired

		.PARAMETER Path
			The path to the file to load

		.EXAMPLE
			PS C:\> . Import-ModuleFile -File $function.FullName

			Imports the file stored in $function according to import policy
	    #>
    [CmdletBinding()]
    Param (
        [string]$Path
    )
    if ($doDotSource) {
        . $Path
    } else {
        $ExecutionContext.InvokeCommand.InvokeScript($false, ([scriptblock]::Create([io.file]::ReadAllText($Path))), $null, $null)
    }
}

# Import all internal functions
foreach ($function in (Get-ChildItem "$script:root\private" -Filter "*.ps1" -Recurse -ErrorAction Ignore)) {
    . Import-ModuleFile -Path $function.FullName
}

# Import all public functions
foreach ($function in (Get-ChildItem "$script:root\public" -Filter "*.ps1" -Recurse -ErrorAction Ignore)) {
    . Import-ModuleFile -Path $function.FullName
}

$script:nodepath = Get-ChildItem -Path $script:root -Filter node.exe -Recurse
$nodebin = Join-Path -Path $script:root -ChildPath bin
$env:NODE_PATH = Join-Path -Path $nodebin -ChildPath .playwright
Set-Alias -Name node -Value Invoke-Node
Set-Alias -Name playwright -Value Invoke-Playwright