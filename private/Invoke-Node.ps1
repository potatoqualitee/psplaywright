function Invoke-Node {
    Write-Verbose "Executing $script:nodepath"
    $arglist = $args -join " "
    Invoke-Program -FilePath $script:nodepath -ArgumentList $arglist
}

#https://github.com/microsoft/playwright/blob/main/tests/library/playwright.config.ts