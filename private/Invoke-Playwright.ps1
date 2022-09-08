function Invoke-Playwright {
    <#
        Main            Method     static int Main(string[] args)
        new             Method     Microsoft.Playwright.Program new()
    #>
    [Microsoft.Playwright.Program]::Main("$args")
}