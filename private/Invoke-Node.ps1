function Invoke-Node {
    [CmdletBinding()]
    param()

    Write-Verbose "Executing $script:nodepath"
    $arglist = $args -join " "

    if ($isLinux -or $isMac) {
        Invoke-Program -FilePath $script:nodepath -ArgumentList $arglist -WorkingDirectory $script:modulebin
    } else {
        Invoke-Program -FilePath $script:nodepath -ArgumentList $arglist
    }
}

#https://github.com/microsoft/playwright/blob/main/tests/library/playwright.config.ts