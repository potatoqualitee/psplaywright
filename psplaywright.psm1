
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

if ($isLinux -or $isMac) {
    $script:nodepath = (whereis node) -split " " | Select-Object -First 1 -Skip 1
    $script:npxpath = (whereis npx) -split " " | Select-Object -First 1 -Skip 1
    $script:npmpath = (whereis npm) -split " " | Select-Object -First 1 -Skip 1
    $script:nodebin = Join-Path -Path $script:root -ChildPath bin
    $script:modulebin = (npm config get prefix | Out-String).Trim()
    $Env:NODE_PATH = $script:modulebin + ":" + (Join-Path -Path $script:nodebin -ChildPath .playwright) + ":" + "/usr/share/nodejs"
    if (-not $script:nodepath) {
        throw "Node.js is not installed. Please install Node.js and try again."
    }
} else {
    $script:nodepath = Get-ChildItem -Path $script:root -Filter node.exe -Recurse
    $nodebin = Join-Path -Path $script:root -ChildPath bin
    $env:NODE_PATH = Join-Path -Path $nodebin -ChildPath .playwright

    if (-not (Get-Command node -ErrorAction Ignore)) {
        Set-Alias -Name node -Value Invoke-Node
        Export-ModuleMember -Alias node
    }
    if (-not (Get-Command playwright -ErrorAction Ignore)) {
        Set-Alias -Name playwright -Value Invoke-Playwright
        Export-ModuleMember -Alias playwright
    }
}