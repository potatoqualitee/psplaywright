function Invoke-Playwright {
    <#
        Main            Method     static int Main(string[] args)
        new             Method     Microsoft.Playwright.Program new()
    #>
    Write-Verbose "Running playwright $args"
    [Microsoft.Playwright.Program]::Main("$args")
}