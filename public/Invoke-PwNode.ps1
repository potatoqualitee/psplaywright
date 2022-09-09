function Invoke-PwNode {
    <#
    .SYNOPSIS
        Executes a script using node.

    .DESCRIPTION
        Executes a script using node.

    .PARAMETER FilePath
        The path to the script.

    .PARAMETER ArgumentList
        The arguments to pass to the script.

    .EXAMPLE
        Invoke-PwNode -FilePath C:\temp\test.js

        Executes the script C:\temp\test.js.

    .EXAMPLE
        Invoke-PwNode -FilePath C:\temp\test.js -ArgumentList $host, $username

        Executes the script C:\temp\test.js with the arguments $host and $username.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string[]]$FilePath,
        [string[]]$ArgumentList
    )
    process {
        $arglist = $ArgumentList -join " "
        foreach ($file in $FilePath) {
            if (-not $IsLinux -and -not $isMacOS) {
                $results = Invoke-NodeNoWorkingDirectory $file $arglist
            } else {
                $results = Invoke-Node $file $arglist
            }

            if ($results.ExitCode -contains 1) {
                throw $results.stderr
                return
            } else {
                $results
            }
        }
    }
}