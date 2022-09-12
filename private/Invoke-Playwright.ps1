function Invoke-Playwright {
    <#
        Main            Method     static int Main(string[] args)
        new             Method     Microsoft.Playwright.Program new()
    #>
    Write-Verbose "Running playwright $args"

    if ($isLinux -or $IsMacOs) {
        npx playwright $args
    } else {
        [Microsoft.Playwright.Program]::Main("$args")
    }
}