function Start-PSPPlaywright {
    <#
    .SYNOPSIS
        Executes playwright commands

    .DESCRIPTION
        Executes playwright commands

    .PARAMETER ArgumentList
        The arguments to pass to the script.

    .EXAMPLE
        Start-PSPPlaywright -ArgumentList install

        Installs playwright

    .EXAMPLE
        Start-PSPPlaywright -ArgumentList install


    #>
    [CmdletBinding()]
    param(
        [string[]]$ArgumentList
    )
    process {
        $arglist = $ArgumentList -join " "
        Invoke-Playwright $file $arglist
    }
}