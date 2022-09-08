function Save-PwScreenshot {
    <#
    .SYNOPSIS
        Saves a screenshot of the current desktop to a file.
    .DESCRIPTION
        Saves a screenshot of the current desktop to a file.
    .PARAMETER Uri
        The URI of the screenshot to save.
    .PARAMETER Path
        The path to save the screenshot to.
    .PARAMETER FullPage
        If specified, the screenshot will be the full page, not just the visible portion.
    .PARAMETER Width
        The width of the screenshot to take.
    .PARAMETER Height
        The height of the screenshot to take.
    .PARAMETER Headful
        If specified, the screenshot will be taken in headful mode.
    .PARAMETER Clip
        If specified, the screenshot will be clipped to the specified region.
    .PARAMETER WaitForSelector
        If specified, the screenshot will be taken after the specified selector is visible.
    .PARAMETER Browser
        The browser to use for the screenshot.
    .PARAMETER WaitForTimeout
        The timeout to use for the screenshot.
    .PARAMETER ClickSelector
        If specified, the specified selector will be clicked before the screenshot is taken.
     .PARAMETER ChromiumSandbox
        If specified, the Chromium sandbox will be enabled.

    Save-PwScreenshot -Uri https://www.google.com, bbc.com -Path C:\temp
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$Uri,
        [Parameter(Mandatory)]
        [string]$Path,
        [switch]$FullPage,
        [int]$Width = 1520,
        [int]$Height = 790,
        [switch]$Headful,
        [string]$Clip,
        [string]$WaitForSelector,
        [ValidateSet("chrome", "chrome-beta", "chrome-dev", "chrome-canary", "msedge", "msedge-beta", "msedge-dev", "msedge-canary")]
        [string]$Browser = 'chromium',
        [int]$WaitForTimeout = 30000,
        [string]$ClickSelector,
        [switch]$ChromiumSandbox
    )
    process {
        # $Env:PLAYWRIGHT_BROWSERS_PATH="$Env:USERPROFILE\pw-browsers"
        # Places binaries to node_modules\playwright-core\.local-browsers
        # $Env:PLAYWRIGHT_BROWSERS_PATH = 0
        #npm install -D @playwright/test playwright
        #npx playwright install
        $items = @()
        foreach ($currenturl in $Uri) {
            if ($currenturl -notmatch "http") {
                $currenturl = "https://$currenturl"
            }
            $url = [System.Uri]$currenturl
            if ($url.AbsolutePath -ne "/") {
                $text = $url.AbsolutePath
            } else {
                $text = $null
            }
            $invalidchars = [System.IO.Path]::GetInvalidFileNameChars() -join "|\"
            $text = $text -replace $invalidchars, "_"
            $items += @{
                url             = $url.AbsoluteUri
                directory       = "$(Resolve-Path -Path $Path)"
                fullPage        = $FullScreen
                filename        = $url.Host + $text + ".png"
                width           = $Width
                height          = $Height
                headless        = -not $Headful
                waitForSelector = $WaitForSelector
                waitForTimeout  = $WaitForTimeout
                clickSelector   = $ClickSelector
                browser         = $Browser
            }
        }
        $json = ($items | ConvertTo-Json -Compress).Replace('"', '\"')
        $screenshots = Join-Path -Path $script:root -ChildPath js
        $screenshots = Join-Path -Path $screenshots -ChildPath screenshots.js

        if (-not $IsLinux -and -not $isMacOS) {
            $results = Invoke-NodeNoWorkingDirectory "$screenshots" $json
        } else {
            $results = node "$screenshots" $json
        }

        if ($results.ExitCode -contains 1) {
            throw $results.stderr
            return
        }


        foreach ($item in $items) {
            Get-ChildItem -Path (Join-Path -Path $item.directory -ChildPath $item.filename)
        }
    }
}