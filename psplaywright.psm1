
$dir = Join-Path $PSScriptRoot bin
$null = Add-Type -Path (Join-Path -Path $dir -ChildPath Microsoft.Playwright.dll)

function playwright {
    [Microsoft.Playwright.Program]::Main("$args")
}
function Install-PwPlaywright {
    $exec = playwright install
    if ($exec -ne 0) {
        throw "Failed to install Playwright"
    } else {
        Write-Output "Playwright installed successfully"
    }
}