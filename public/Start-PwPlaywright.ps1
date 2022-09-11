function Start-PwPlaywright {
    <#
    .SYNOPSIS
        Executes playwright commands

    .DESCRIPTION
        Executes playwright commands

    .PARAMETER ArgumentList
        The arguments to pass to the script.

    .EXAMPLE
        Start-PwPlaywright -ArgumentList install

        Installs playwright

    .EXAMPLE
        Start-PwPlaywright -ArgumentList install


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