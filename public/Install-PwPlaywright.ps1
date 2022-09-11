function Install-PwPlaywright {
    [cmdletbinding()]
    param()

    if ($isLinux -or $isMac) {
        Write-Verbose "installing on linux or mac $script:npxpath"
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
        Write-Verbose "installing on windows"
        $exec = playwright install
        if ($exec -ne 0) {
            throw "Failed to install Playwright"
        } else {
            Write-Output "Playwright installed successfully"
        }
    }

}