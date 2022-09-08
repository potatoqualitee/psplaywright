function Invoke-Node {
    Write-Verbose "Executing $script:nodepath"
    $arglist = $args -join " "
    Write-Verbose "arglist $arglist"

    Invoke-Program -FilePath $script:nodepath -ArgumentList $arglist -WorkingDirectory $script:modulebin
}

function Invoke-NodeNoWorkingDirectory {
    Write-Verbose "Executing $script:nodepath"
    $arglist = $args -join " "
    Write-Verbose "arglist $arglist"

    Invoke-Program -FilePath $script:nodepath -ArgumentList $arglist
}

#https://github.com/microsoft/playwright/blob/main/tests/library/playwright.config.ts