function Invoke-PwPlaywright {
    <#
    .SYNOPSIS
        Executes playwright commands

    .DESCRIPTION
        Executes playwright commands

    .PARAMETER ArgumentList
        The arguments to pass to the script.

    .EXAMPLE
        Invoke-PwPlaywright -ArgumentList install

        Installs playwright

    .EXAMPLE
        Invoke-PwPlaywright -ArgumentList install


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