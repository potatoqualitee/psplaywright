function Install-PwPlaywright {
    [cmdletbinding()]
    $exec = playwright install
    if ($exec -ne 0) {
        throw "Failed to install Playwright"
    } else {
        Write-Output "Playwright installed successfully"
    }
}