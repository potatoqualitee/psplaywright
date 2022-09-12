function Install-PSPPlaywright {
    <#
    .SYNOPSIS
        Installs Microsoft Playwright

    .DESCRIPTION
        Installs Microsoft Playwright

    .Example
        Install-PSPPlaywright
    
        Installs Microsoft Playwright
#>
    [cmdletbinding()]
    param()

    if ($isLinux -or $isMac) {
        Write-Verbose "Installing on linux or mac to $script:modulebin"
        Write-Verbose "$script:npmpath --prefix $script:modulebin -y install"
        $exec = Invoke-Program -FilePath $script:npmpath -ArgumentList "--prefix $script:modulebin -y install" -ErrorAction Stop
        $exec = Invoke-Program -FilePath $script:npxpath -ArgumentList "--prefix $script:modulebin -y playwright install" -ErrorAction Stop

        if ($exec.ExitCode -ne 0) {
            $exec
            throw "Failed to install Playwright"
        } else {
            Write-Output "Playwright installed successfully"
        }
    } else {
        Write-Verbose "Installing on Windows"
        $exec = playwright install
        if ($exec -ne 0) {
            throw "Failed to install Playwright"
        } else {
            Write-Output "Playwright installed successfully"
        }
    }
}